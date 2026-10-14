# Runs against a mocked AWS provider: no credentials or real resources needed.
mock_provider "aws" {}

variables {
  name       = "test"
  cidr_block = "10.0.0.0/16"

  public_subnets = {
    a = { cidr_block = "10.0.0.0/24", availability_zone = "eu-west-1a" }
    b = { cidr_block = "10.0.1.0/24", availability_zone = "eu-west-1b" }
  }

  private_subnets = {
    a = { cidr_block = "10.0.10.0/24", availability_zone = "eu-west-1a" }
    b = { cidr_block = "10.0.11.0/24", availability_zone = "eu-west-1b" }
  }

  tags = { Environment = "test" }
}

run "creates_vpc_subnets_and_routing" {
  command = apply 

  assert {
    condition     = aws_vpc.vpc.enable_dns_support && aws_vpc.vpc.enable_dns_hostnames
    error_message = "DNS support and DNS hostnames must be enabled."
  }

  assert {
    condition     = aws_vpc.vpc.tags == tomap({ Name = "test", Environment = "test" })
    error_message = "VPC must carry the caller tags plus its Name."
  }

  assert {
    condition     = aws_route.public_internet[0].destination_cidr_block == "0.0.0.0/0" && aws_route.public_internet[0].gateway_id == aws_internet_gateway.igw[0].id
    error_message = "Public route table must send 0.0.0.0/0 to the Internet Gateway."
  }

  assert {
    condition     = alltrue([for a in aws_route_table_association.public : a.route_table_id == aws_route_table.public[0].id])
    error_message = "Every public subnet must use the public route table."
  }

  assert {
    condition     = alltrue([for a in aws_route_table_association.private : a.route_table_id == aws_route_table.private.id]) && aws_route.public_internet[0].route_table_id != aws_route_table.private.id
    error_message = "Private subnets must use their own route table, with no internet route."
  }
}

run "no_public_subnets_means_no_internet_gateway" {
  command = plan

  variables {
    public_subnets = {}
  }

  assert {
    condition     = length(aws_internet_gateway.igw) == 0 && length(aws_route_table.public) == 0
    error_message = "No Internet Gateway or public route table may exist without public subnets."
  }
}

run "rejects_subnet_outside_vpc_cidr" {
  command = plan

  variables {
    private_subnets = {
      a = { cidr_block = "10.1.0.0/24", availability_zone = "eu-west-1a" }
    }
  }

  expect_failures = [var.private_subnets]
}
