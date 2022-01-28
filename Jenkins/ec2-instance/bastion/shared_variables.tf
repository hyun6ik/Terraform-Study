variable "backend_s3" {
  default = "hyun6ik-backend"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "vpc_key" {
  default = "s3-backend/terraform.tfstate"
}

variable "tags" {}