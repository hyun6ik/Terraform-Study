terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hyun6ik-terraform-study"

    workspaces {
      name = "Terraform-Study"
    }
  }
}



provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_group" "this" {
  for_each = toset(["developer", "employee"])

  name = each.key
}

output "groups" {
  value = aws_iam_group.this
}

variable "users" {
  type = list(any)
}

resource "aws_iam_user" "this" {
  for_each = {
    for user in var.users :
      user.name => user
  }

  name = each.key

  tags = {
    level = each.value.level
    role = each.value.role
  }
}

resource "aws_iam_user_group_membership" "this" {
  for_each = {
    for user in var.users :
      user.name => user
  }

  user = each.key
  groups = each.value.is_developer ? [aws_iam_group.this["developer"].name, aws_iam_group.this["employee"].name] : [aws_iam_group.this["employee"].name]
}

locals {
  developers = [
    for user in var.users :
      user
    if user.is_developer
  ]
}

resource "aws_iam_user_policy_attachment" "developer" {
  for_each = {
    for user in local.developers:
      user.name => user
  }
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user = each.key

  depends_on = [
    aws_iam_user.this
  ]
}

output "developers" {
  value = local.developers
}

output "high_level_users" {
  value = [
    for user in var.users :
      user
    if user.level > 5
  ]
}