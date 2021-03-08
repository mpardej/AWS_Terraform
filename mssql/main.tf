resource "aws_db_instance" "sqlserver" {

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

  backup_retention_period   = 0
  final_snapshot_identifier = local.name
  deletion_protection       = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  license_model             = "license-included"
  timezone                  = "GMT Standard Time"
}