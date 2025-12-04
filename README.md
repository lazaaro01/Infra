# Documentação – Projeto de Estudos Terraform + Docker

## Descrição do Projeto

Este projeto é um ambiente simples criado para fins de estudo, utilizando **Terraform** para provisionar infraestrutura local com **Docker**. O objetivo é aprender a declarar recursos, aplicar configurações e entender como Terraform interage com o Docker Engine.

### Recursos Criados

O projeto cria os seguintes componentes:

- Uma rede Docker chamada `dev_network`
- Uma imagem Docker do Nginx (`nginx:latest`)
- Um container Docker chamado `nginx_dev`
- Exposição da porta `8080` → `80`
- Tudo totalmente automatizado via Terraform

---

## Estrutura do Projeto

```
terraform-docker/
│
├── main.tf              # Configuração principal do Terraform
├── variables.tf         # Variáveis parametrizadas do projeto
├── outputs.tf           # Outputs exibidos após o apply
├── terraform.tfstate    # Estado (gerado automaticamente)
└── terraform.tfstate.backup
```

---

## Configuração

### `main.tf` – Configuração Principal

O arquivo `main.tf` contém toda a infraestrutura declarativa:

#### 1. Declaração do Provider

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}
```

Este bloco permite que o Terraform execute comandos no Docker Engine da sua máquina.

#### 2. Criação da Rede Docker

```hcl
resource "docker_network" "dev_network" {
  name = "dev_network"
}
```

Uma rede personalizada é importante para isolar containers e permitir comunicação futura entre eles.

#### 3. Download da Imagem do Nginx

```hcl
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}
```

- Baixa automaticamente a última versão do Nginx
- Remove a imagem local quando `terraform destroy` é executado

#### 4. Criação do Container Nginx

```hcl
resource "docker_container" "nginx" {
  name  = "nginx_dev"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.dev_network.name
  }

  ports {
    internal = 80
    external = 8080
  }
}
```

O container sobe rodando o Nginx e expõe a porta `8080` do host, mapeando para a porta `80` interna.

### `variables.tf` – Configurações Parametrizadas

O arquivo `variables.tf` permite alterar valores sem modificar o `main.tf`. Exemplo sugerido:

```hcl
variable "container_name" {
  description = "Nome do container Nginx"
  type        = string
  default     = "nginx_dev"
}

variable "external_port" {
  description = "Porta exposta no host"
  type        = number
  default     = 8080
}

variable "docker_network_name" {
  description = "Nome da rede Docker"
  type        = string
  default     = "dev_network"
}
```

Para integrar no `main.tf`, basta referenciar: `name = var.container_name`

### `outputs.tf` – Informações Após o Apply

```hcl
output "app_url" {
  value = "http://localhost:8080"
}
```

O Terraform exibirá a URL final no terminal após o `apply`.

---

## Como Executar

### 1. Inicializar o Terraform

```bash
terraform init
```

Prepara o ambiente e baixa os providers necessários.

### 2. Ver o Plano de Execução

```bash
terraform plan
```

Mostra quais recursos serão criados/modificados/destruídos.

### 3. Criar a Infraestrutura

```bash
terraform apply
```

Executa o plano e provisiona todos os recursos.

### 4. Acessar a Aplicação

Após finalizar, abra no navegador:

```
http://localhost:8080
```

### 5. Destruir a Infraestrutura

```bash
terraform destroy
```

Remove todos os recursos criados.

---

## Resultados Esperados

Após o `apply`, o Docker terá:

| Recurso | Quantidade | Nome |
|---------|-----------|------|
| Imagem | 1 | `nginx:latest` |
| Container | 1 | `nginx_dev` |
| Rede | 1 | `dev_network` |

Você poderá acessar o Nginx pelo navegador através de `http://localhost:8080`.

---

## Pré-requisitos

- Terraform instalado e configurado
- Docker instalado e em execução
- Permissão para executar comandos do Docker