terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "Blog_vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "Test_vpc_igw"
  }

}

resource "aws_default_route_table" "my_vpc_default_rt" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    "Name" = "my-default-rt"
  }
}

resource "aws_subnet" "my_az" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone[0]
  tags = {
    "Name" = "my_subnet"
  }
}
