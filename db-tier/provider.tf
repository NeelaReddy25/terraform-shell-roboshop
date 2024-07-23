terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.50.0"
    }
  }
  backend "s3" {
    bucket = "neelareddy.stores"
    key = "expense-aws-db-tier"
    region = "us-east-1"
    dynamodb_table = "neelareddy-prod"
  }
}

#provide authentication here
provider "aws" {
    region = "us-east-1"
}