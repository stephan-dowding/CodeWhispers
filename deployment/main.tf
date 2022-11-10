locals {
  region = "ap-southeast-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      App = "CodeWhispers"
    }
  }
}