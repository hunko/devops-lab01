# Cấu hình Docker Provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# 1. Resource: Docker Image
# Dùng Ansible để tạo Dockerfile (ví dụ: file Dockerfile.j2)
resource "docker_image" "webapp_image" {
  name = "webapp-ansible-app:latest"
  build {
    context    = "../ansible"
    dockerfile = "Dockerfile"
    # Dùng build args để Ansible nhận biết môi trường
    build_args = {
      ANSIBLE_SETUP = "true"
    }
  }
}

# 2. Resource: Docker Container
# Deploy container sử dụng image đã build
resource "docker_container" "webapp_container" {
  name  = "webapp-ansible-container"
  image = docker_image.webapp_image.name

  # Mở cổng 8080 trên Host (Windows) trỏ vào cổng 5000 trong Container
  ports {
    internal = 5000
    external = 8080
  }

  # Ansible run the setup on the container
  provisioner "local-exec" {
    command = "ansible-playbook -i 'localhost,' -c local ../ansible/playbook.yml --extra-vars 'container_id=${self.id}'"
    when = destroy
  }
}
