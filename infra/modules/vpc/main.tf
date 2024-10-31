terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_vpc" "Blog_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "Blog_Vpc"
  }
}

resource "aws_internet_gateway" "Blog_Igw" {
  vpc_id = aws_vpc.Blog_vpc.id
  tags = {
    "Name" = "Blog_Vpc_igw"
  }

}

resource "aws_default_route_table" "Blog_vpc_default_rt" {
  default_route_table_id = aws_vpc.Blog_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Blog_Igw.id
  }
  tags = {
    "Name" = "Blog-default-rt"
  }
}



resource "aws_subnet" "Blog_az" {
  vpc_id            = aws_vpc.Blog_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone[0]
  tags = {
    "Name" = "Blog_subnet"
  }
}

resource "aws_route_table_association" "Blog_public_subnet_association" {
  subnet_id      = aws_subnet.Blog_az.id
  route_table_id = aws_default_route_table.Blog_vpc_default_rt.id
}

resource "aws_default_security_group" "Blog_sec_group" {
  vpc_id = aws_vpc.Blog_vpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sec_grp_name
  }
}
