# data "aws_vpc" "vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["MainVPC_WM"]
#   }
# }

# data "aws_availability_zones" "available" {
#   state = "available"
# }