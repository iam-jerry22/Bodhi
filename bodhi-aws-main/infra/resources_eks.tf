module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = var.cluster_name
  cluster_version = "1.23"


  vpc_id                      = module.vpc.vpc_id
  subnet_ids                  = module.vpc.private_subnets
  create_cloudwatch_log_group = false

  eks_managed_node_group_defaults = {
    # ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"
      ami_type = "AL2_x86_64"
      instance_types = ["m5.2xlarge"]
      min_size       = 2
      max_size       = 30
      desired_size   = 2

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT


      vpc_security_group_ids = [
        aws_security_group.all_worker_mgmt.id
      ]
    }


    # two = {
    #   name = "node-group-2"
    #   ami_type = "BOTTLEROCKET_x86_64_NVIDIA"
    #   platform = "bottlerocket"
    #   instance_types = ["p2.xlarge"]
    #   labels = {
    #     nodetype = "app"
    #   }
    #   taints = [
    #     {
    #       key    = "sku"
    #       value  = "gpu"
    #       effect = "NO_SCHEDULE"
    #     }
    #   ]
    #   min_size     = 0
    #   max_size     = 1
    #   desired_size = 1

    #   pre_bootstrap_user_data = <<-EOT
    #   echo 'foo bar'
    #   EOT

    #   vpc_security_group_ids = [
    #     aws_security_group.all_worker_mgmt.id
    #   ]
    # }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

## OIDC config
data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

#resource "aws_iam_openid_connect_provider" "example" {
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint], var.oidc_thumbprint_list)
#  url             = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
#}

module "ebs_csi_driver_controller" {
  source = "DrFaust92/ebs-csi-driver/kubernetes"
  #version = "<VERSION>"

  ebs_csi_controller_image                   = "k8s.gcr.io/provider-aws/aws-ebs-csi-driver"
  ebs_csi_controller_role_name               = "ebs-csi-driver-controller"
  ebs_csi_controller_role_policy_name_prefix = "ebs-csi-driver-policy"
  oidc_url                                   = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
