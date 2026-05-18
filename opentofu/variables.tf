variable "data_dir" {
  description = "Base directory used to store persistent container data"
  type        = string
  default     = "/opt/projets/data"
}

variable "timezone" {
  description = "Timezone used by containers"
  type        = string
  default     = "Europe/Paris"
}

variable "puid" {
  description = "Linux user ID used by compatible containers"
  type        = number
  default     = 1000
}

variable "pgid" {
  description = "Linux group ID used by compatible containers"
  type        = number
  default     = 1000
}

variable "mealie_image" {
  description = "Mealie Docker image"
  type        = string
  default     = "ghcr.io/mealie-recipes/mealie:latest"
}

variable "mealie_port" {
  description = "Host port exposed by Mealie"
  type        = number
  default     = 9925
}

variable "mealie_base_url" {
  description = "Base URL used by Mealie"
  type        = string
  default     = "http://localhost:9925"
}

variable "mealie_allow_signup" {
  description = "Allow signup in Mealie"
  type        = bool
  default     = true
}

variable "homeassistant_image" {
  description = "Home Assistant Docker image"
  type        = string
  default     = "ghcr.io/home-assistant/home-assistant:stable"
}

variable "zigbee_device" {
  description = "Zigbee USB device path exposed to Home Assistant"
  type        = string
  default     = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_18fb85990922f0119969678fb887153e-if00-port0"
}

variable "mqtt_image" {
  description = "Mosquitto Docker image"
  type        = string
  default     = "eclipse-mosquitto:2.0"
}

variable "mqtt_port" {
  description = "Host MQTT port"
  type        = number
  default     = 1883
}

variable "mqtt_websocket_port" {
  description = "Host MQTT WebSocket port"
  type        = number
  default     = 9001
}

variable "node_red_image" {
  description = "Node-RED Docker image"
  type        = string
  default     = "nodered/node-red:latest"
}

variable "node_red_port" {
  description = "Host Node-RED port"
  type        = number
  default     = 1880
}

variable "decouverte_image" {
  description = "Docker image name built for 1jour1decouverte"
  type        = string
}

variable "decouverte_container_name" {
  description = "Container name for 1jour1decouverte"
  type        = string
  default     = "decouverte-du-jour"
}

variable "decouverte_anthropic_api_key" {
  description = "Anthropic API key used by 1jour1decouverte"
  type        = string
  sensitive   = true
}

variable "decouverte_twilio_account_sid" {
  description = "Twilio account SID used by 1jour1decouverte"
  type        = string
  sensitive   = true
}

variable "decouverte_twilio_auth_token" {
  description = "Twilio auth token used by 1jour1decouverte"
  type        = string
  sensitive   = true
}

variable "decouverte_twilio_from" {
  description = "Twilio WhatsApp sender"
  type        = string
}

variable "decouverte_whatsapp_to" {
  description = "WhatsApp recipient"
  type        = string
}

variable "decouverte_heure_envoi" {
  description = "Daily send time for 1jour1decouverte"
  type        = string
  default     = "07:30"
}

variable "ghcr_username" {
  description = "GitHub username used to authenticate against GitHub Container Registry"
  type        = string
}

variable "ghcr_token" {
  description = "GitHub token used to authenticate against GitHub Container Registry"
  type        = string
  sensitive   = true
}