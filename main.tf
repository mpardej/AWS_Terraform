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

  enable_nat_gateway = true
  enable_vpn_gateway = true

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


# Call the seed_module to build our ADO seed info
#module "bootstrap" {
#  source                      = "./modules/bootstrap"
#  name_of_s3_bucket           = "s3bucket-aws-wmakarzak01"
#  dynamo_db_table_name        = "aws-locks-wmakarzak"
#}

# Build the VPC
# resource "aws_vpc" "vpc" {
#   cidr_block           = "10.1.0.0/16"
#   instance_tenancy     = "default"
#   tags = {
#     Name      = "MainVPC_WM"
#     Terraform = "true"
#   }
# }
# # add subnet
# resource "aws_subnet" "sql_sbn" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.1.10.0/24"
#   availability_zone = data.aws_availability_zones.available.names[0]

#   tags = {
#     Name = "sql_sbn"
#   }
# }

# resource "aws_subnet" "sql_sbn_secondary" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.1.20.0/24"
#   availability_zone = data.aws_availability_zones.available.names[1]

#   tags = {
#     Name = "sql_sbn"
#   }
# }

# resource "aws_db_subnet_group" "default" {
#     name       = "main"
#     subnet_ids = [aws_subnet.sql_sbn.id, aws_subnet.sql_sbn_secondary.id]

#     tags = {
#     Name = "sql_subnet"
#   }
# }

# module "security_group" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 3"

#   name        = "sql-sg"
#   description = "Complete SqlServer example security group"
#   vpc_id      = data.aws_vpc.vpc.id

#   # ingress
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 1433
#       to_port     = 1433
#       protocol    = "tcp"
#       description = "SqlServer access from within VPC"
#       cidr_blocks = data.aws_vpc.vpc.cidr_block
#     },
#   ]

# }

# module "db" {
#  source     = "./mssql"
  
# }
