terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hyun6ik-terraform-study"

    workspaces = {
      name = "Terraform-Study"
    }
  }
}

# Local Variables

locals {
  aws_accounts = {
    hyun6ik = {
      id = "xxxxxxx"
      region = "ap-northeast-2"
      alias = "hyun6ik-aws"
    },
  }
  # var.config_file에 YAML의 PATH가 있는데 이 Path가 file 함수를 만나면
  # file Read를 수행하게 되는데 이 함수를 yamldecode를 이용하면
  # YAML -> HCL로 변환시켜준다.
  context = yamldecode(file(var.config_file)).context
  # templatefile은 context variables을 template에 전달하여 렌더링할 수 있게 해준다.
  # ${..}

  config = yamldecode(templatefile(var.config_file, local.context))
}

# Providers

provider "aws" {
  region = local.aws_accounts.hyun6ik.region

  # 이 템플릿에서 운영할 수 있는 AWS 계정 ID
  allowed_account_ids = [local.aws_accounts.hyun6ik.id]

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_accounts.hyun6ik.id}:role/terraform-access"
    session_name = local.context.workspace
  }
}