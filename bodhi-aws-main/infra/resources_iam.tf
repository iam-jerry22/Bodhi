
# ####### cluster autoscaler #################### 

output "cluster_autoscaler_role_arn" {
  value = module.iam_assumable_role_admin.iam_role_arn
}


module "iam_assumable_role_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-cluster-autoscaler"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler"]
}


resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "${var.cluster_name}-cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster/${var.cluster_name}"
      # variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/${module.eks.cluster_id}"
      values = ["owned"]
    }

    # condition {
    #   test     = "StringEquals"
    #   variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
    #   values   = ["true"]
    # }
  }
}



############## EFS 



output "efs_csi_driver_role_arn" {
  value = module.iam_assumable_role_efs_csi_driver.iam_role_arn
}

module "iam_assumable_role_efs_csi_driver" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-efs-csi-driver"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.efs_csi_driver_allow.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
}


resource "aws_iam_policy" "efs_csi_driver_allow" {
  name_prefix = "${var.cluster_name}-efs-csi-driver"
  description = "EFS CSI Driver Allow for cluster ${module.eks.cluster_id}"
  policy      =  data.aws_iam_policy_document.efs_csi_driver_allow_policy_document.json
  
}

data "aws_iam_policy_document" "efs_csi_driver_allow_policy_document" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["elasticfilesystem:CreateAccessPoint"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["elasticfilesystem:DeleteAccessPoint"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
}

############### AWS LoadBalancer ##############

output "load_balancer_controller_role_arn" {
  value = module.iam_assumable_role_load_balancer_controller.iam_role_arn
}


module "iam_assumable_role_load_balancer_controller" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-load-balancer-controller"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.policy_load_balancer_controller.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}

output "load_balancer_controller_arn" {
  value = aws_iam_policy.policy_load_balancer_controller.arn
}

resource "aws_iam_policy" "policy_load_balancer_controller" {
  name_prefix = "${var.cluster_name}-load-balancer-controller"
  description = "Load Balancer Controller for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.policy_doc_policy_load_balancer_controller.json
}


data "aws_iam_policy_document" "policy_doc_policy_load_balancer_controller" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:CreateServiceLinkedRole",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeTags",
      "ec2:GetCoipPoolUsage",
      "ec2:DescribeCoipPools",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTags",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cognito-idp:DescribeUserPoolClient",
      "acm:ListCertificates",
      "acm:DescribeCertificate",
      "iam:ListServerCertificates",
      "iam:GetServerCertificate",
      "waf-regional:GetWebACL",
      "waf-regional:GetWebACLForResource",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
      "shield:GetSubscriptionState",
      "shield:DescribeProtection",
      "shield:CreateProtection",
      "shield:DeleteProtection",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateSecurityGroup"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    actions   = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSecurityGroup"]
    }

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup",
    ]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:DeleteRule",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
    ]

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*",
    ]

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:DeleteTargetGroup",
    ]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]

    actions = [
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:SetWebAcl",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:ModifyRule",
    ]
  }
}


############# Route 53 DNS

module "iam_assumable_role_route53_external_dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-route53-external-dns"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.policy_route53_external_dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:external-dns"]
}

resource "aws_iam_policy" "policy_route53_external_dns" {
  name_prefix = "${var.cluster_name}-route53-external-dns"
  description = "Route53 external dns support for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.policy_doc_route53_external_dns.json
}



output "role_route53_external_dns_arn" {
  value = module.iam_assumable_role_route53_external_dns.iam_role_arn
}
data "aws_iam_policy_document" "policy_doc_route53_external_dns" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::change/*"]
    actions   = ["route53:GetChange"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/${var.route_53_hosted_zone_id}"]

    actions = [
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "route53:ListHostedZonesByName",
      "route53:ListHostedZones",
    ]
  }
}



############# CERT Manager  DNS
output "role_cert_manager" {
  value = module.iam_assumable_role_cert_manager.iam_role_arn
}

module "iam_assumable_role_cert_manager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-cert-manager"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.policy_cert_manager.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:cert-manager:cert-manager"]
}

resource "aws_iam_policy" "policy_cert_manager" {
  name_prefix = "${var.cluster_name}-cert-manager"
  description = "Cert Manager support for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.policy_doc_cert_manager.json
}

data "aws_iam_policy_document" "policy_doc_cert_manager" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::change/*"]
    actions   = ["route53:GetChange"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/${var.route_53_hosted_zone_id}"] #["arn:aws:route53:::hostedzone/Z01092051A89AGGYVS6KN"]

    actions = [
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
    ]
  }
}





#### S3 Policy

module "iam_assumable_role_pipeline_s3_access" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-pipeline-s3-access"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.policy_pipeline_s3_access.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:pipeline-s3-access"]
}

resource "aws_iam_policy" "policy_pipeline_s3_access" {
  name_prefix = "${var.cluster_name}-pipeline-s3-access"
  description = "Pipeline to S3 access for cluster ${module.eks.cluster_id} on buckets ${var.cluster_name}-*"
  policy      = data.aws_iam_policy_document.policy_doc_pipeline_s3_access.json
}



data "aws_iam_policy_document" "policy_doc_pipeline_s3_access" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["s3:List*"]
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["redshift-data:ExecuteStatement*"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.cluster_name}-*/*"]
    actions   = ["s3:*Object"]
  }
}


######## External Secrets
output "external_secret_role_arn" {
  value = module.iam_assumable_role_external_secret.iam_role_arn
}

module "iam_assumable_role_external_secret" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-external-secret"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.policy_external_secret.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:external-secrets"]
}

resource "aws_iam_policy" "policy_external_secret" {
  name_prefix = "${var.cluster_name}-external-secret"
  description = "External secret support for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.policy_doc_external_secret.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "policy_doc_external_secret" {
  statement {
    sid    = ""
    effect = "Allow"
    # resources = ["arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.cluster_name}*"]
    resources = ["*"]

    actions = [
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetSecretValue",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets"
    ]
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-external-secret"]
    actions   = ["sts:AssumeRole"]
  }

}


# data "aws_iam_policy_document" "policy_doc_external_secret" {
#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}_external_secret*"]
#     actions   = ["sts:AssumeRole"]
#   }
# }

######### EKSCNI Role : https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html


output "eks_cni_role_arn" {
  value = module.iam_assumable_role_eks_cni.iam_role_arn
}

module "iam_assumable_role_eks_cni" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-eks-cni"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-node"]
}


######## Pipeline with Required Access 

output "pipeline_role_arn" {
  value = module.iam_assumable_role_pipeline.iam_role_arn
}

# resource "aws_iam_instance_profile" "EMR_EC2_DefaultRole" {
#   name = "EMR_EC2_DefaultRole"
#   role = "bodhi-pipeline-access"
# }


module "iam_assumable_role_pipeline" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

  create_role  = true
  role_name    = "${var.cluster_name}-pipeline-access"
  provider_url = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonElasticMapReduceFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    aws_iam_policy.policy_pipeline_assume_role.arn,
    aws_iam_policy.policy_pipeline_s3_access.arn
  ]
  # oidc_fully_qualified_subjects = [
  #   "system:serviceaccount:kubeflow:argo",
  #   "system:serviceaccount:kubeflow:kubeflow-pipelines-cache",
  #   "system:serviceaccount:kubeflow:kubeflow-pipelines-cache-deployer-sa",
  #   "system:serviceaccount:kubeflow:kubeflow-pipelines-container-builder",
  #   "system:serviceaccount:kubeflow:kubeflow-pipelines-metadata-writer",
  #   "system:serviceaccount:kubeflow:kubeflow-pipelines-viewer",
  #   "system:serviceaccount:kubeflow:meta-controller-service",
  #   "system:serviceaccount:kubeflow:metadata-grpc-server",
  #   "system:serviceaccount:kubeflow:ml-pipeline-persistenceagent",
  #   "system:serviceaccount:kubeflow:ml-pipeline-scheduledworkflow",
  #   "system:serviceaccount:kubeflow:ml-pipeline-ui",
  #   "system:serviceaccount:kubeflow:ml-pipeline-viewer-crd-service-account",
  #   "system:serviceaccount:kubeflow:ml-pipeline-visualizationserver",
  #   "system:serviceaccount:kubeflow:pipeline-runner",

  # ]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*:default-editor",
    "system:serviceaccount:kubeflow:argo",
    "system:serviceaccount:kubeflow:kubeflow-pipelines-cache",
    "system:serviceaccount:kubeflow:kubeflow-pipelines-cache-deployer-sa",
    "system:serviceaccount:kubeflow:kubeflow-pipelines-container-builder",
    "system:serviceaccount:kubeflow:kubeflow-pipelines-metadata-writer",
    "system:serviceaccount:kubeflow:kubeflow-pipelines-viewer",
    "system:serviceaccount:kubeflow:meta-controller-service",
    "system:serviceaccount:kubeflow:metadata-grpc-server",
    "system:serviceaccount:kubeflow:ml-pipeline-persistenceagent",
    "system:serviceaccount:kubeflow:ml-pipeline-scheduledworkflow",
    "system:serviceaccount:kubeflow:ml-pipeline-ui",
    "system:serviceaccount:kubeflow:ml-pipeline-viewer-crd-service-account",
    "system:serviceaccount:kubeflow:ml-pipeline-visualizationserver",
    "system:serviceaccount:kubeflow:pipeline-runner",
  ]
}

resource "aws_iam_policy" "policy_pipeline_assume_role" {
  name_prefix = "${var.cluster_name}-policy-pipeline-assume-role"
  description = "policy_pipeline_assume_role for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.policy_doc_pipeline_assume_role.json
}

data "aws_iam_policy_document" "policy_doc_pipeline_assume_role" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-pipeline-access"]
    actions   = ["sts:AssumeRole"]
  }
}

# resource "aws_iam_policy" "policy_pipeline_full_s3_access" {
#   name_prefix = "bodhi_pipeline_full_s3_access"
#   description = "bodhi_pipeline_full_s3_access for cluster ${module.eks.cluster_id}"
#   policy      = data.aws_iam_policy_document.policy_doc_pipeline_full_s3_access.json
# }

# data "aws_iam_policy_document" "policy_doc_pipeline_full_s3_access" {
#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]
#     actions   = ["s3:List*"]
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]
#     actions   = ["s3:*Object"]
#   }
# }


#### IAM User with S3 Access

resource "aws_iam_access_key" "cluster_s3_access" {
  user = aws_iam_user.cluster_s3_access.name
}

resource "aws_iam_user" "cluster_s3_access" {
  name = "${var.cluster_name}-s3-access"
}

resource "aws_iam_user_policy" "policy_cluster_s3_access" {
  user   = aws_iam_user.cluster_s3_access.name
  name   = "${var.cluster_name}-cluster-s3-access"
  policy = data.aws_iam_policy_document.policy_doc_cluster_s3_access.json
}

data "aws_iam_policy_document" "policy_doc_cluster_s3_access" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["s3:List*"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.cluster_name}-*/*"]
    actions   = ["s3:*Object"]
  }
}

## AWS config

resource "aws_iam_access_key" "current" {
  user    = aws_iam_user.current.name
}

resource "aws_iam_user" "current" {
  name = "external-secret"
  # path = "/system/"
}

resource "aws_iam_user_policy" "policy_aws_access" {
  user   = aws_iam_user.current.name
  name   = "${var.cluster_name}-aws-access"
  policy = data.aws_iam_policy_document.aws_config.json
}

data "aws_iam_policy_document" "aws_config" {
  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["eks:*"]
  }
  
}


