terraform {
  backend "s3" {
    bucket = "hyun6ik-backend"
    key = "bastion/terraform.tfstate"
    region = "ap-northeast-2"
    max_retries = 3
  }
}