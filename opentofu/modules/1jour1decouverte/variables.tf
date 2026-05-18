variable "data_dir" {
  type = string
}

variable "timezone" {
  type = string
}

variable "puid" {
  type = number
}

variable "pgid" {
  type = number
}

variable "image" {
  type = string
}

variable "container_name" {
  type    = string
  default = "decouverte-du-jour"
}

variable "anthropic_api_key" {
  type      = string
  sensitive = true
}

variable "twilio_account_sid" {
  type      = string
  sensitive = true
}

variable "twilio_auth_token" {
  type      = string
  sensitive = true
}

variable "twilio_from" {
  type = string
}

variable "whatsapp_to" {
  type = string
}

variable "heure_envoi" {
  type    = string
  default = "07:30"
}

variable "log_max_size" {
  type    = string
  default = "10m"
}

variable "log_max_file" {
  type    = string
  default = "3"
}