terraform {
  backend "local" {
    path = "/opt/opentofu/state/homelab.tfstate"
  }

  required_version = ">= 1.8.0, < 2.0.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address  = "ghcr.io"
    username = var.ghcr_username
    password = var.ghcr_token
  }
}