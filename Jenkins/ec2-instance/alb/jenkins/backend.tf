terraform {
  backend "s3" {
    bucket = "hyun6ik-terraform-backend"
    key = "alb/jenkins/terraform.tfstate"
    region = "ap-northeast-2"
    max_retries = 3
  }
}