output "id" {
  description = "The AWS Account ID"
  value = data.aws_caller_identity.this.account_id
}

output "name" {
  description = "Name of the AWS account. The account alias"
  value = aws_iam_account_alias.this.account_alias
}

output "signin_url" {
  description = "The URL to signin for the AWS account"
  value = "https://${var.name}.signin.aws.amazion.com/console"
}

output "password_policy" {
  description = "Password Policy for the AWS Account"
  value = aws_iam_account_password_policy.this
}