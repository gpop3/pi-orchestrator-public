variable "data_dir" {
  type = string
}

variable "timezone" {
  type = string
}

variable "image" {
  type = string
}

variable "zigbee_device" {
  type = string
}

variable "backend_network" {
  description = "Nom du réseau Docker backend auquel HA est rattaché"
  type        = string
}

variable "dns_servers" {
  description = "Serveurs DNS du conteneur"
  type        = list(string)
  default     = ["192.168.1.254"]
}
