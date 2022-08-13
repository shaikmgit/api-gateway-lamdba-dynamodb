# API Gateway, Lambda, and DynamoDB

Used as boilerplate code to scaffold out a small serverless AWS application using [Terraform](https://www.terraform.io) which produces API Gateway routes, Lambda functions, and a DynamoDB table - includes correlating CloudWatch Logs.

## Installation

Must have an AWS account and [Terraform](https://www.terraform.io) installed. Designed to be used with a domain name in a Route 53 Zone. If using repo without a domain name, rename the `domain.tf` file to `domain.tf.txt` so it's not included when running the `terraform apply` command.

## How to import and existing Route 53 Zone

Run `terraform import aws_route53_zone.primary YOUR_ROUTE_53_ZONE_ID` (Replace YOUR_ROUTE_53_ZONE_ID with your Route 53 Hosted Zone ID).

Rename the variable `domain` in `variables.tf` to whatever your domain name is, for example: `example.com`. The variable `domain` in `variables.tf` creates an S3 bucket for uploading Lamdba function .zip files.

## Renaming App Name

To support multiple deployments of this code (or a fork of this code) to AWS, I have littered the code with the label `yourapp` to support multiple functions, roles, and policies within the same AWS Account. Replace `yourapp` with your desired project name so you have the ability to deploy multiple versions (modified or not) of this repo within your AWS Account.

### Examples

This repo demonstrates multiple ways of serving content from Lambda, some of which may be considered unconventional (serving HTML files from Lambda). This is for simplification purposes, instead of serving static assets from a CloudFront distrubution backed by and S3 bucket.
