data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["test-vpc"]
  }
}

data "aws_security_groups" "securedb_sg" {
  filter {
    name   = "group-name"
    values = ["sqldb-service-*"]
  }
}
data "aws_subnet_ids" "sql_subnet" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["test-vpc-private*"]
  }
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}