terraform {
  required_version = "~> 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "../../modules/vpc"

  name       = "demo"
  cidr_block = "10.0.0.0/16"

  public_subnets = {
    a = { cidr_block = "10.0.0.0/24", availability_zone = "eu-west-1a" }
    b = { cidr_block = "10.0.1.0/24", availability_zone = "eu-west-1b" }
  }

  private_subnets = {
    a = { cidr_block = "10.0.10.0/24", availability_zone = "eu-west-1a" }
    b = { cidr_block = "10.0.11.0/24", availability_zone = "eu-west-1b" }
  }

  tags = {
    Environment = "dev"
    Project     = "continental-interview"
  }
}
