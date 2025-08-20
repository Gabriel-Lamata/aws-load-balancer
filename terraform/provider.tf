# PROVIDER
terraform {
  required_version = "~> 1.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }

  backend "s3" {
    bucket = "aws-s3-tfstate-lamata"
    key    = "tfstate"
    region = "us-east-1"
  }
}