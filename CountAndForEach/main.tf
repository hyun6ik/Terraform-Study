provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "user_1" {
  name = "user-1"
}

resource "aws_iam_user" "user_2" {
  name = "user-2"
}

resource "aws_iam_user" "user_3" {
  name = "user-3"
}

output "user_arns" {
  value = [
    aws_iam_user.user_1.arn,
    aws_iam_user.user_2.arn,
    aws_iam_user.user_3.arn
  ]
}

/*
* count (resource, data, module 에도 사용 가능)
* [user0, user1, user2, ... ]
*/

resource "aws_iam_user" "count" {
  count = 10

  name = "count-user-${count.index}"
}

output "count_user_arns" {
  value = aws_iam_user.count.*.arn
}