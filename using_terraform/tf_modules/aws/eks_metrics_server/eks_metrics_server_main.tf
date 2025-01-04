
data "aws_eks_cluster" "eks_cluster_instance" {
  name = "${var.project_name}_eks_cluster"
}

data "aws_eks_node_group" "eks_cluster_workers_general_node_group" {
  cluster_name    = data.aws_eks_cluster.eks_cluster_instance.name
  node_group_name = "${var.project_name}_eks_cluster_workers_general_node_group"
}

resource "helm_release" "eks_cluster_metrics_server" {
  name             = "${var.project_name}-metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  create_namespace = false
  version          = var.metrics_server_helm_chart_version
  values           = [file("${path.module}/values/metrics_server_values.yaml")]
  depends_on       = [data.aws_eks_node_group.eks_cluster_workers_general_node_group]
}
