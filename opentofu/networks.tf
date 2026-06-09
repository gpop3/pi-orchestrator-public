resource "docker_network" "edge" {
  name   = "edge"
  driver = "bridge"

  ipam_config {
    subnet  = "172.18.0.0/24"
    gateway = "172.18.0.1"
  }
}

resource "docker_network" "backend" {
  name   = "backend"
  driver = "bridge"

  ipam_config {
    subnet  = "172.19.0.0/24"
    gateway = "172.19.0.1"
  }
}
