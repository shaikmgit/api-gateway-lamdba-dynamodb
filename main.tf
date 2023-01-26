terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "random" {
  length  = 10
  special = false
  upper   = false
  lower   = true
  numeric  = false
}

resource "aws_s3_bucket" "lambda_zip" {
  bucket = "api-gateway-lambda-dynamodb-${random_string.random.result}"
}

resource "aws_dynamodb_table" "questions" {
  name           = "questions"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
