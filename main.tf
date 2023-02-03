
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

# Create a VPC
resource "aws_vpc" "project_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "project_1"
  }
}

# Create a Subnet
resource "aws_subnet" "pri_sub_1" {
  vpc_id     = aws_vpc.project_1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pri_sub_1"
  }
}

resource "aws_subnet" "pri_sub_2" {
  vpc_id     = aws_vpc.project_1.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "pri_sub_2"
  }
}

resource "aws_subnet" "pub_sub_1" {
  vpc_id     = aws_vpc.project_1.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "pub_sub_1"
  }
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id     = aws_vpc.project_1.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "pub_sub_2"
  }
}

# Create route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.project_1.id

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.project_1.id

  tags = {
    Name = "private_route_table"
  }
}

# Create Route Table association

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.pri_sub_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.pri_sub_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create internet gateway
resource "aws_internet_gateway" "project_1_igw" {
  vpc_id = aws_vpc.project_1.id

  tags = {
    Name = "project_1_igw"
  }
}


# Create Internet gateway aws route
resource "aws_route" "public_internet_gateway_route" {
  route_table_id = aws_route_table.public_route_table.id
  gateway_id                = aws_internet_gateway.project_1_igw.id
  destination_cidr_block    = "0.0.0.0/0"
}