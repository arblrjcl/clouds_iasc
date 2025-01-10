
resource "civo_dns_domain_name" "domain_name" {
  name = var.domain_name
}

data "http" "mypublicip" {
  url = "https://ipv4.icanhazip.com"
}

resource "civo_network" "project_civo_network" {
  #count          = var.default_network_instance ? 0 : 1
  label          = "${var.project_name}-private-network"
  nameservers_v4 = var.custom_v4_nameservers
  cidr_v4        = var.cidr_v4
}

resource "civo_firewall" "project_civo_network_firewall" {
  #count                = var.default_network_instance ? 0 : 1
  name                 = "${var.project_name}-network-firewall"
  create_default_rules = false
  ingress_rule {
    label      = "k8s"
    protocol   = "tcp"
    port_range = "6443"
    cidr       = [var.cidr_v4]
    action     = "allow"
  }

  ingress_rule {
    label      = "ssh"
    protocol   = "tcp"
    port_range = "22"
    cidr       = [var.cidr_v4]
    action     = "allow"
  }

  ingress_rule {
    label      = "Allow everything from my [private] public ip"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["${chomp(data.http.mypublicip.response_body)}/32"]
    action     = "allow"
  }

  ingress_rule {
    label      = "K3S Cluster - API Server"
    protocol   = "tcp"
    port_range = "6443"
    cidr       = ["${chomp(data.http.mypublicip.response_body)}/32"]
    action     = "allow"
  }

  egress_rule {
    label      = "all"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
  #network_id = civo_network.project_civo_network[count.index].id
  network_id = civo_network.project_civo_network.id
}
