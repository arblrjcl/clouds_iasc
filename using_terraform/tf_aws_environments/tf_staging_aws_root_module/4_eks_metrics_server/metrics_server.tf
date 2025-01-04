
module "eks_cluster_metrics_server" {
  source                            = "../../../tf_modules/aws/eks_metrics_server/"
  project_name                      = local.common_tags.PROJECT_NAME
  metrics_server_helm_chart_version = "3.12.1"
}
