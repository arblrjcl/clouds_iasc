
data "civo_network" "project_civo_network" {
  label = "${var.project_name}-network"
}

data "civo_firewall" "project_civo_network_firewall" {
  name = "${var.project_name}-network-firewall"
}

# Query instance disk image
data "civo_disk_image" "debian10_disk_image" {
  filter {
    key    = "name"
    values = ["debian-10"]
  }
}

resource "civo_ssh_key" "project_instance_ssh_key" {
  name       = "${var.project_name}-ssh-key"
  public_key = file(var.ssh_public_key_file_name_with_path)
}

# Query small instance size
data "civo_size" "small_size_instance" {
  filter {
    key      = "name"
    values   = ["g3.small"]
    match_by = "re"
  }

  filter {
    key    = "type"
    values = ["instance"]
  }

}

resource "civo_instance" "project_instance" {
  hostname    = var.instance_name
  tags        = var.instance_tags
  notes       = var.instance_notes
  firewall_id = data.civo_firewall.project_civo_network_firewall.id
  network_id  = data.civo_network.project_civo_network.id
  size        = var.instance_size
  disk_image  = data.civo_disk_image.debian10_disk_image.diskimages[0].id
  sshkey_id   = civo_ssh_key.project_instance_ssh_key.id
  volume_type = var.volume_type
}
