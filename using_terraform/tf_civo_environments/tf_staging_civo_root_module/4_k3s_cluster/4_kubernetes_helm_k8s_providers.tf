
data "civo_kubernetes_cluster" "civo_k3s_cluster_details" {
  name       = "${local.common_tags.PROJECT_NAME}-k3s-cluster"
  depends_on = [module.k3s_cluster_instance]
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = format("%s%s%s", "civo kubernetes config ", data.civo_kubernetes_cluster.civo_k3s_cluster_details.name, " --save --overwrite --yes")
  }
}

/*output "host" {
  value = "${yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.server}"
}

output "client_certificate" {
  value = "${base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-certificate-data)}"
}

output "client_key" {
  value = "${base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-key-data)}"
}

output "cluster_ca_certificate" {
  value = "${base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.certificate-authority-data)}"
}*/

provider "helm" {
  kubernetes {
    host                   = yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.server
    client_certificate     = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-certificate-data)
    client_key             = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-key-data)
    cluster_ca_certificate = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.certificate-authority-data)
  }
}

provider "kubernetes" {
  host                   = yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.server
  client_certificate     = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-certificate-data)
  client_key             = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.certificate-authority-data)
}

provider "kubectl" {
  host                   = yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.server
  client_certificate     = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-certificate-data)
  client_key             = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(data.civo_kubernetes_cluster.civo_k3s_cluster_details.kubeconfig).clusters.0.cluster.certificate-authority-data)
  load_config_file       = false
}

resource "kubernetes_namespace" "kafkazk" {
  metadata {
    annotations = {
      "PROJECT_NAME" = "${var.project_environment_name}-${var.project_name}",
      "TERRAFORM"    = "yes",
      "RESPONSIBLE"  = "Ravi"
    }

    labels = {
      app = "kafka-zk-cluster"
    }

    name = "kakfazk"
  }
}

resource "kubernetes_namespace" "kafkaraft" {
  metadata {
    annotations = {
      "PROJECT_NAME" = "${var.project_environment_name}-${var.project_name}",
      "TERRAFORM"    = "yes",
      "RESPONSIBLE"  = "Ravi"
    }

    labels = {
      app = "kafka-raft-cluster"
    }

    name = "kakfaraft"
  }
}

/*resource "helm_release" "ingress-nginx" {
  name              = "ingress-controller"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  dependency_update = true
  chart             = "ingress-nginx"
  version           = "4.12.0"
  depends_on        = [data.civo_kubernetes_cluster.civo_k3s_cluster_details]
}

resource "time_sleep" "wait_for_ingress_nginx_controller" {
  depends_on = [helm_release.ingress-nginx]
  create_duration = "1m"
}*/
