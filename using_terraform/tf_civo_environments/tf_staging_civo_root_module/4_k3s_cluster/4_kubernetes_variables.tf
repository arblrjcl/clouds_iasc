
variable "apps_to_be_installed_from_k8s_cluster" {
  type = string
  #default = "argocd,linkerd:Linkerd with Dashboard & Jaeger"
  #default = "civo-cluster-autoscaler,metrics-server,cert-manager,argocd,argo-workflows,kubernetes-dashboard" #,keycloak,kyverno"
  default = "civo-cluster-autoscaler,metrics-server,argocd,argo-workflows,cert-manager" #kubernetes-dashboard,keycloak,kyverno"
}
