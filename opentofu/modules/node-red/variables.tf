variable "data_dir" {
  type = string
}

variable "timezone" {
  type = string
}

variable "image" {
  type = string
}

variable "port" {
  type = number
}

variable "puid" {
  type = number
}

variable "pgid" {
  type = number
}

variable "backend_network" {
  description = "Reseau backend partage avec nginx"
  type        = string
}
