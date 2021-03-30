# Require TF version to be same as or greater than 0.12.13
terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "s3bucket-aws-wmakarzak01"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "aws-locks-wmakarzak"
    encrypt        = true
  }
}

# Download any stable version in AWS provider of 2.36.0 or higher in 2.36 train
provider "aws" {
  region  = "eu-central-1"
  version = "~> 2.70.0"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  enable_nat_gateway = false
  enable_vpn_gateway = false

  map_public_ip_on_launch = false

  tags = {
    Terraform = "true"
    Environment = "test"
  }
}


module "sql_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sqldb-service"
  description = "Complete SqlServer example security group"
  vpc_id      = data.aws_vpc.test-vpc.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      description = "SqlServer access from within VPC"
      cidr_blocks = data.aws_vpc.test-vpc.cidr_block
    },
  ]
}


