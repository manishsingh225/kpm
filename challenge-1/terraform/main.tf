provider "aws" {
  region  = "ap-south-1"
  profile = "<AWS_PROFILE>"
}

terraform {
  required_version = "0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 1.0"
    }
  }
}