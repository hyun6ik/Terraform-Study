provider "aws" {
  region = "ap-northeast-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

locals {
  vpc_name = "hyun6ik"
  common_tags = {
    "Project" = "provisioner-userdata"
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = local.vpc_name
  }
}

module "security_group" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "0.24.0"

  name = "${local.vpc_name}-provisioner-userdata"
  vpc_id = aws_default_vpc.default.id

  ingress_rules = [
    {
      id = "ssh"
      protocol = "tcp"
      from_port = 22
      to_port =22
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      id = "http"
      protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
  egress_rules = [
    {
      id = "all/all"
      protocol = "-1"
      from_port = 0
      to_port = 0

      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = local.common_tags
}

# Userdata
resource "aws_instance" "userdata" {
  ami = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  # ssh_key
  key_name = "dev"

  user_data = <<EOT
#!/bin/bash
sudo apt-get update
sudo apt-get intall -y nginx
EOT

  vpc_security_group_ids = [
    module.security_group.id,
  ]

  tags = {
    Name = "hyun6ik-userdata"
  }
}
###################################################
# Provisioner - in EC2
###################################################

# resource "aws_instance" "provisioner" {
#   ami           = data.aws_ami.ubuntu.image_id
#   instance_type = "t2.micro"
#   key_name      = "dev"
#
#   vpc_security_group_ids = [
#     module.security_group.id,
#   ]
#
#   tags = {
#     Name = "hyun6ik-provisioner"
#   }
#
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install -y nginx",
#     ]
#
#     connection {
#       type = "ssh"
#       user = "ubuntu"
#       host = self.public_ip
#     }
#   }
# }


###################################################
# Provisioner - in null-resources
###################################################

resource "aws_instance" "provisioner" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = "dev"

  vpc_security_group_ids = [
    module.security_group.id,
  ]

  tags = {
    Name = "hyun6ik-provisioner"
  }
}

resource "null_resource" "provisioner" {
  triggers = {
    instance_id = aws_instance.provisioner.id
    script       = filemd5("${path.module}/files/install-nginx.sh")
    index_file   = filemd5("${path.module}/files/index.html")
  }

  provisioner "local-exec" {
    command = "echo Hello World"
  }

  provisioner "file" {
    source      = "${path.module}/files/index.html"
    destination = "/tmp/index.html"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.provisioner.public_ip
    }
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/install-nginx.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.provisioner.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/index.html /var/www/html/index.html"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.provisioner.public_ip
    }
  }
}
