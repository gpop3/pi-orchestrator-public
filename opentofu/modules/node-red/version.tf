terraform {
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