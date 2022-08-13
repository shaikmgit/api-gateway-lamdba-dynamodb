# API Gateway, Lambda, and DynamoDB

Used as boilerplate code to scaffold out a serverless AWS application using [Terraform](https://www.terraform.io) which produces API Gateway routes, Lambda functions, a DynamoDB table with correlating CloudWatch Logs.

## Installation

Must have an AWS account and Terraform installed. Designed to be used with a domain name in a Route 53. If using without a domain name, rename the `domain.tf` file to `domain.tf.txt` so it's not included when running the `terraform apply` command.

## How to import and existing Route 53 Zone

Run `terraform import aws_route53_zone.primary YOUR_ROUTE_53_ZONE_ID` (Replace YOUR_ROUTE_53_ZONE_ID with your Route 53 Hosted Zone ID).

Rename the variable `domain` in `variables.tf` to whatever your domain name is, for example: `example.com`.

# Renaming App Name

To support multiple deployments of this code (or a fork of this code) to AWS, I have littered the code with the label `yourapp`. You may not create functions, roles, policies, etcetera with the same name in the same region. Furthermore, you may not create the same roles and policies in an AWS Account with the same name - so replace `yourapp` with whatever you desire to name your project so you have the option of deploying multiple versions (modified or not) within your AWS Account.
