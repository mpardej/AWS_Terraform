data "aws_security_groups" "securedb_sg" {
  filter {
    name   = "tag:Name"
    values = ["sql-sg"]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["MainVPC_WM"]
  }
}

data "aws_subnet" "main_sbn" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["Main"]
  }
}