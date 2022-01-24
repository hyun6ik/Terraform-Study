provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "foo" {
  cidr_block = "10.123.0.0/16"

  tags = {
    "Name" = "hyun6ik"
  }
}

output "vpc_foo" {
  value = aws_vpc.foo
}

data "aws_vpcs" "this" {}

output "vpcs"{
  value = data.aws_vpcs.this
}