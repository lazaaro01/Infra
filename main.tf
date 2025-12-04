terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_network" "dev_network" {
  name = var.network_name
}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = false
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.dev_network.name
  }

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

output "app_url" {
  value = "http://localhost:${var.external_port}"
}