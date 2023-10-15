terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # backend "s3" {
  #   bucket = "terraform-tfstate-bodhiask-test"
  #   key = "infra1/terraform.tfstate"
  #   region = "us-east-2"
  # }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

