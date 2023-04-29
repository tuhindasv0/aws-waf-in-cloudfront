data "aws_vpc" "poc-vpc" {
  id = "vpc-"
}
data "aws_subnet" "poc-vpc-private-us-east-1a" {
  id = "subnet-"
}
data "aws_subnet" "poc-vpc-public-us-east-1a" {
  id = "subnet-"
}

data "aws_subnet" "poc-vpc-public-us-east-1b" {
  id = "subnet-"
}
