
data "aws_eks_cluster" "eks_cluster_instance" {
  name = format("%s%s", local.common_tags.PROJECT_NAME, "_eks_cluster")
}

data "aws_eks_cluster_auth" "eks_cluster_instance_auth" {
  name = "${var.project_name}_eks_cluster"
}

data "aws_region" "current" {}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster_instance.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_instance.certificate_authority[0].data)
    #token                  = data.aws_eks_cluster_auth.eks_cluster_instance_auth.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "${data.aws_eks_cluster.eks_cluster_instance.name}", "--region", "${data.aws_region.current.name}"]
      command     = "aws"
    }
  }
}
