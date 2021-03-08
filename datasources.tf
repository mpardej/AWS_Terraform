data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["MainVPC_WM"]
  }
}