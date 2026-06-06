resource "docker_network" "edge" {
  name   = "edge"
  driver = "bridge"
}

resource "docker_network" "backend" {
  name   = "backend"
  driver = "bridge"
}
