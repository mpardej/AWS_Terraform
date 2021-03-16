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

provider "aws" {
  region  = local.region
}



module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.30"

  identifier           = local.identifier
  engine               = "sqlserver-ex"
  engine_version       = "14.00.3356.20.v1"
  instance_class       = "db.t2.micro"
  character_set_name = local.char_set

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  name     = null
  username = "admin"
  password = "Password1"
  port     = 1433

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["error"]
  option_group_name               = local.option_group_name
  vpc_security_group_ids          = data.aws_security_groups.securedb_sg.ids
  subnet_ids                      = data.aws_subnet_ids.sql_subnet.ids

  #this needs to be linked explicitly due to a bug in terraform-aws-modules/rds/aws https://github.com/terraform-aws-modules/terraform-aws-rds/issues/242
  monitoring_role_arn       = "arn:aws:iam::078681072058:role/enhanced_monitoring"

  backup_retention_period   = 0
  final_snapshot_identifier = local.name
  deletion_protection       = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  license_model             = "license-included"
  timezone                  = "GMT Standard Time"
}