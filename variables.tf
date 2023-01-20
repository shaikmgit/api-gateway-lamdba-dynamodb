locals {
  bucket_name = "aws-terraform-serverless-tester"
  routes = {
    "index" : {
      name : "index"
      http_verb : "GET"
      path = "/"
      policies : "dynamodb:Scan"
      resource : "*"
    },
    "questions" : {
      name : "questions"
      http_verb : "GET"
      path = "/questions"
      policies : "dynamodb:Scan"
      resource : "${aws_dynamodb_table.questions.arn}"
    },
    "question-post" : {
      name : "question-post"
      http_verb : "POST"
      path = "/question"
      policies : "dynamodb:PutItem"
      resource : "${aws_dynamodb_table.questions.arn}"
    },
    "question-delete" : {
      name : "question-delete"
      http_verb : "DELETE"
      path = "/question"
      policies : "dynamodb:DeleteItem"
      resource : "${aws_dynamodb_table.questions.arn}"
    },
  }
}

variable "aws_region" {
  type    = string
  default = "us-west-1"
}