
data "twingate_remote_network" "twingate_remote_network" {
  name       = var.remotenetworkname
  depends_on = [resource.twingate_remote_network.twingate_remote_network]
}

resource "twingate_remote_network" "twingate_remote_network" {
  name = var.remotenetworkname
}

resource "twingate_group" "custom_twingate_group" {
  name = var.twingate_group_name
}

/*resource "twingate_connector" "twingate_remote_nw_connector" {
  remote_network_id = data.twingate_remote_network.twingate_remote_network.id
  status_updates_enabled = true
  depends_on = [data.twingate_remote_network.twingate_remote_network]
}*/

locals {
  twingate_operator_helm_chart_values_file_contents = {
    twingateOperator = {
      apiKey          = var.twingate_api_token
      network         = var.twingate_network_or_account_name
      remoteNetworkId = data.twingate_remote_network.twingate_remote_network.id
      logFormat       = var.twingate_operator_logFormat
      logVerbosity    = var.twingate_operator_logVerbosity
    }
    image : {
      repository = "twingate/kubernetes-operator"
      pullPolicy = "IfNotPresent"
      tag        = "latest"
    }
    imagePullSecrets = []
    nameOverride     = ""
    fullnameOverride = ""
    serviceAccount = {
      create      = true
      annotations = {}
      name        = ""
    }
    podAnnotations = {}
    podLabels      = {}
    podSecurityContext = {
      seccompProfile = {
        type = "RuntimeDefault"
      }
    }
    securityContext = {
      capabilities = {
        drop = ["ALL"]
      }
      readOnlyRootFilesystem   = true
      runAsNonRoot             = true
      allowPrivilegeEscalation = false
      runAsUser                = 1000
    }
    resources         = {}
    nodeSelector      = {}
    tolerations       = []
    affinity          = {}
    priorityClassName = ""
  }
}
