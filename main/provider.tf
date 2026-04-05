terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"
    }
  }

  backend "s3" {
    bucket = "aws-mihai-titan-bucket"
    key = "eks-cluster/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "aws-mihai-lock"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-central-1"
}
