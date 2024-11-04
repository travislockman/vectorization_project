resource "aws_vpc" "vectortask_vpc" {
  cidr_block           = var.vpc_cidr_block
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

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vectortask_vpc.id
  cidr_block              = var.public_subnet_cidr_a
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "${var.project_prefix}-public-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vectortask_vpc.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.project_prefix}-private-subnet-a"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "${var.project_prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "vectortask_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "${var.project_prefix}-nat-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vectortask_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vectortask_igw.id
  }
  tags = {
    Name = "${var.project_prefix}-public-rt"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vectortask_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vectortask_nat.id
  }
  tags = {
    Name = "${var.project_prefix}-private-rt"
  }
}

resource "aws_route_table_association" "public_subnet_a_assoc" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_a_assoc" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

output "vpc_id" {
  value = aws_vpc.vectortask_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_a.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_a.id]
}
