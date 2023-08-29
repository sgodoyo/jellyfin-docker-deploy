# main.tf
terraform {
    required_version = ">= 0.15"
    required_providers {
        linode = {
            source = "linode/linode"
        }
    }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "docker_host" {
  label       = "webapp-itechile"
  region      = "us-east"
  type        = "g6-nanode-1"
  image      = "linode/debian10"
  authorized_keys = [
    var.ssh_public_key
  ]

  tags = ["nginx-webapp"]
}

resource "null_resource" "install_docker" {
  depends_on = [linode_instance.docker_host]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/linode-itechile-devops")
    host        = linode_instance.docker_host.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install locales-all",
      "apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common git",
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -",
      "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable\"",
      "apt-get update",
      "apt-get install -y docker-ce docker-ce-cli containerd.io",
      "systemctl enable docker",
      "systemctl start docker",
      "curl -sSL https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose"
    ]
  }
}


resource "null_resource" "install_gitlab_runner" {
  depends_on = [linode_instance.docker_host, null_resource.install_docker]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/linode-itechile-devops")
    host        = linode_instance.docker_host.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash",
      "apt-get install -y gitlab-runner",
      "gitlab-runner register --non-interactive --url https://gitlab.com/ --token '${var.runner_token}'",
      "systemctl enable gitlab-runner",
      "systemctl start gitlab-runner"
    ]
  }
}
