##### Service Account to access
## system:serviceaccount:kube-system:efs-csi-controller-sa

resource "kubernetes_service_account" "efs-csi-controller-sa" {
  metadata {
    name = "efs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
        "eks.amazonaws.com/role-arn" : module.iam_assumable_role_efs_csi_driver.iam_role_arn
    }
  }
}

output "efs_file_system_dns" {
  value = aws_efs_file_system.eks-volumes.dns_name
}

resource "aws_efs_file_system" "eks-volumes" {
   creation_token = "${var.cluster_name}-eks-volumes"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
   tags = {
     Name = "${var.cluster_name}-EKSVolumes"
     ENV = "PRD"
     GRUPO = "Forecast1x"
   }
}

resource "aws_security_group" "efs-target-eks-volumes" {
  name        = "${var.cluster_name}-efs-target-eks-volumes"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

resource "aws_efs_mount_target" "eks-volumes-ca-target-2" {
  file_system_id = aws_efs_file_system.eks-volumes.id
  subnet_id      = module.vpc.private_subnets.1

  security_groups = [
    aws_security_group.efs-target-eks-volumes.id
  ]
}

resource "aws_efs_mount_target" "eks-volumes-ca-target-3" {
  file_system_id = aws_efs_file_system.eks-volumes.id
  subnet_id      = module.vpc.private_subnets.2

  security_groups = [
    aws_security_group.efs-target-eks-volumes.id
  ]
}