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

/*
* for_each
* set = List Unique Element
* map = Key Value
*/

# for_each를 사용하면 블록안에서
# each.key와 each.value를 사용할 수 있다.
# set = each.key와 each.value가 같다.
# map = each.key, each.value가 key value와 같다.
resource "aws_iam_user" "for_each_set" {
  for_each = toset([
    "for-each-set-user-1",
    "for-each-set-user-2",
    "for-each-set-user-3",
  ])

  name = each.key
}

output "for_each_set_user_arns" {
  value = values(aws_iam_user.for_each_set).*.arn
}

resource "aws_iam_user" "for_each_map" {
  for_each = {
    hyun6ik = {
      level = "high"
      manager = "hyun6ikManager"
    }
    bob = {
      level = "mid"
      manager = "hyun6ikManager"
    }
    john = {
      level = "low"
      manager = "steve"
    }
  }

  name = each.key
  tags = each.value
}

output "for_each_map_user_arns" {
  value = values(aws_iam_user.for_each_map).*.arn
}