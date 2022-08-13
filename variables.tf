variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-west-1"
}

variable "domain" {
  type    = string
  default = "yourdomainname.com"
}

variable "log_retention_days" {
  default = 3
}
