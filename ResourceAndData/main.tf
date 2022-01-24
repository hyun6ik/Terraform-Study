provider "aws" {
  region = "ap-northeast-2"
}

# Canonical이 만든 Ubuntu 중에서 20.04 버전이고 가상화 타입이 hvm인 Ubuntu들 중에서
# 가장 최신으로 생성된 것을 가져오기
data "aws_ami" "ubuntu" {
  # ami 중에서 제일 최신
  most_recent = true

  # ami를 가져올 때 ubuntu의 20.04 버전을 가져오기(amd64)
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  # 가상화 타입이 hvm인 것만
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  # Canonical이 만든 Ubuntu만 가져오기
  owners = ["099720109477"]
}

resource "aws_instance" "ubuntu" {
  ami = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"

  tags = {
    Name = "Hyun6ik-Ubuntu"
  }
}