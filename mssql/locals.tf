
locals {
  identifier                = "sql-db"
  name                      = "complete-mssql"
  region                    = "eu-central-1"
  option_group_name         = "sqlbackuprestore"
  char_set                  = "Latin1_General_CI_AS"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}