data "aws_security_groups" "securedb_sg" {
  filter {
    name   = "tag:Name"
    values = ["sql-sg"]
  }
}

