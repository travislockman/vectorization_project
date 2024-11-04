resource "aws_vpc" "vectortask_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "vectortask_igw" {
  vpc_id = aws_vpc.vectortask_vpc.id
  tags = {
    Name = "${var.project_prefix}-igw"
  }
}

resource "aws_subnet" "vectortask_public_subnet_a" {
  vpc_id                  = aws_vpc.vectortask_vpc.id
  cidr_block              = var.public_subnet_cidr_a
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
  tags = {
    Name = "${var.project_prefix}-public-subnet-a"
  }
}

resource "aws_subnet" "vectortask_public_subnet_b" {
  vpc_id                  = aws_vpc.vectortask_vpc.id
  cidr_block              = var.public_subnet_cidr_b
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
  tags = {
    Name = "${var.project_prefix}-public-subnet-b"
  }
}

resource "aws_subnet" "vectortask_private_subnet_a" {
  vpc_id            = aws_vpc.vectortask_vpc.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = "us-east-2a"
  tags = {
    Name = "${var.project_prefix}-private-subnet-a"
  }
}

resource "aws_subnet" "vectortask_private_subnet_b" {
  vpc_id            = aws_vpc.vectortask_vpc.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = "us-east-2b"
  tags = {
    Name = "${var.project_prefix}-private-subnet-b"
  }
}

resource "aws_route_table" "vectortask_public_route_table" {
  vpc_id = aws_vpc.vectortask_vpc.id
  tags = {
    Name = "${var.project_prefix}-public-route-table"
  }
}

resource "aws_route" "vectortask_public_route" {
  route_table_id         = aws_route_table.vectortask_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vectortask_igw.id
}

resource "aws_route_table_association" "vectortask_public_route_table_association_a" {
  subnet_id      = aws_subnet.vectortask_public_subnet_a.id
  route_table_id = aws_route_table.vectortask_public_route_table.id
}

resource "aws_route_table_association" "vectortask_public_route_table_association_b" {
  subnet_id      = aws_subnet.vectortask_public_subnet_b.id
  route_table_id = aws_route_table.vectortask_public_route_table.id
}

resource "aws_route_table" "vectortask_private_route_table" {
  vpc_id = aws_vpc.vectortask_vpc.id
  tags = {
    Name = "${var.project_prefix}-private-route-table"
  }
}

resource "aws_route_table_association" "vectortask_private_route_table_association_a" {
  subnet_id      = aws_subnet.vectortask_private_subnet_a.id
  route_table_id = aws_route_table.vectortask_private_route_table.id
}

resource "aws_route_table_association" "vectortask_private_route_table_association_b" {
  subnet_id      = aws_subnet.vectortask_private_subnet_b.id
  route_table_id = aws_route_table.vectortask_private_route_table.id
}

output "vpc_id" {
  value = aws_vpc.vectortask_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.vectortask_public_subnet_a.id, aws_subnet.vectortask_public_subnet_b.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.vectortask_private_subnet_a.id, aws_subnet.vectortask_private_subnet_b.id]
}
