variable "network_name" {
  type        = string
  default     = "dev_network"
  description = "Nome da rede Docker"
}

variable "container_name" {
  type        = string
  default     = "nginx_dev"
  description = "Nome do container"
}

variable "image_name" {
  type        = string
  default     = "nginx:latest"
  description = "Imagem que será usada no container"
}

variable "internal_port" {
  type        = number
  default     = 80
  description = "Porta interna do container"
}

variable "external_port" {
  type        = number
  default     = 8080
  description = "Porta externa exposta"
}