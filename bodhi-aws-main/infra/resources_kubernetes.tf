provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# resource "helm_release" "k8s-device-plugin" {
#   name  = "k8s-device-plugin"
#   repository = "https://nvidia.github.io/k8s-device-plugin"
#   chart = "nvidia-device-plugin"
#   version = "0.6.0"
#   namespace = "kube-system"
# }