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
  version = "~> 2.36.0"
}

# Call the seed_module to build our ADO seed info
#module "bootstrap" {
#  source                      = "./modules/bootstrap"
#  name_of_s3_bucket           = "s3bucket-aws-wmakarzak01"
#  dynamo_db_table_name        = "aws-locks-wmakarzak"
#}

# Build the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  tags = {
    Name      = "MainVPC_WM"
    Terraform = "true"
  }
}
# add subnet
resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.10.0/24"

  tags = {
    Name = "Main"
  }
}
