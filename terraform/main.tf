terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "tf-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet-private" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = var.subnet-private-cidr

  tags = {
    Name = var.subnet-private-name
  }
}

resource "aws_subnet" "subnet-public" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = var.subnet-public-cidr

  tags = {
    Name = var.subnet-public-name
  }
}

resource "aws_internet_gateway" "tf-gateway" {
  vpc_id = aws_vpc.tf-vpc.id
  depends_on = []
  
  tags = {
    Name = var.igw-name
  }
}

resource "aws_eip" "tf-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.tf-gateway]

  tags = {
    Name = var.eip-name
  }
}

resource "aws_nat_gateway" "tf-nat-gateway" {
  allocation_id = aws_eip.tf-eip.id 
  subnet_id = aws_subnet.subnet-public.id

  tags = {
    Name = var.nat-name
  }
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.tf-vpc.id

    route {
      cidr_block = var.all-traffic-cidr
      gateway_id = aws_internet_gateway.tf-gateway.id
    }

    tags = {
      Name = var.public-rt-name
    }
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.tf-vpc.id

    route {
      cidr_block = var.all-traffic-cidr
      nat_gateway_id = aws_nat_gateway.tf-nat-gateway.id
    }

    tags = {
      Name = var.private-rt-name
    }
}

resource "aws_route_table_association" "public-rt-association" {
  subnet_id = aws_subnet.subnet-public.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-rt-association" {
  subnet_id = aws_subnet.subnet-private.id
  route_table_id = aws_route_table.private-rt.id
}