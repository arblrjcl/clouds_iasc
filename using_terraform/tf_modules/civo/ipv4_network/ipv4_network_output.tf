
output "civo_network_name" {
  value = one(civo_network.project_civo_network[*].name)
}

output "civo_network_id" {
  value = one(civo_network.project_civo_network[*].id)
}

output "civo_network_default_or_not" {
  value = one(civo_network.project_civo_network[*].default)
}

output "civo_network_label" {
  value = one(civo_network.project_civo_network[*].label)
}

data "civo_network" "civo_default_network" {
  label = "default"
  //default = true
  #cidr_v4        = "192.168.1.0/24"
  #nameservers_v4 = tolist(["8.8.8.8", "1.1.1.1"])
}

/*
output "ipv4_network_instance" { 
  value = one(civo_network.project_civo_network[*].default) ? [merge(data.civo_network.civo_default_network, {"cidr_v4" = "192.168.1.0/24", 
  "nameservers_v4" = tolist(["8.8.8.8", "1.1.1.1"]), "timeouts" = null})] : civo_network.project_civo_network
  //value = one(civo_network.project_civo_network[*].default) ? [data.civo_network.civo_default_network] : civo_network.project_civo_network
}
*/