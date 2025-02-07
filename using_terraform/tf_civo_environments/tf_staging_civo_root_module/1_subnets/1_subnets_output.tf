
output "civo_network_name" {
  value     = module.ipv4_private_network.civo_network_name
  sensitive = true
}

output "civo_network_id" {
  value     = module.ipv4_private_network.civo_network_id
  sensitive = true
}

output "civo_network_default_or_not" {
  value     = module.ipv4_private_network.civo_network_default_or_not
  sensitive = true
}

output "civo_network_label" {
  value     = module.ipv4_private_network.civo_network_label
  sensitive = true
}

/*output "ipv4_network_instance" { 
  value = module.ipv4_private_network.ipv4_network_instance
}*/

# ---------------------------------------------------------------------------------------------------------------------
data "civo_network" "civo_default_network" {
  label = "default"
  //default = true
  #cidr_v4        = "192.168.1.0/24"
  #nameservers_v4 = tolist(["8.8.8.8", "1.1.1.1"])
}

output "ipv4_default_network" {
  #value = module.ipv4_default_network_instance.ipv4_network_instance
  value     = data.civo_network.civo_default_network
  sensitive = true
}
