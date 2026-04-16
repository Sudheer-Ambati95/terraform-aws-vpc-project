data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

############################
# VPC
############################

resource "aws_vpc" "this" {
  cidr_block = var.cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

############################
# Internet Gateway
############################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

############################
# Public Subnets
############################

resource "aws_subnet" "public" {
  count = 2

  vpc_id = aws_vpc.this.id

  cidr_block = cidrsubnet(var.cidr, 4, count.index)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-${count.index}"
  }
}

############################
# Private Subnets
############################

resource "aws_subnet" "private" {
  count = 2

  vpc_id = aws_vpc.this.id

  cidr_block = cidrsubnet(var.cidr, 4, count.index + 2)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.environment}-private-${count.index}"
  }
}

############################
# EIP
############################

resource "aws_eip" "nat" {
  domain = "vpc"
}

############################
# NAT Gateway
############################

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.igw
  ]
}

############################
# Public Route Table
############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id = aws_subnet.public[count.index].id

  route_table_id = aws_route_table.public.id
}

############################
# Private Route Table
############################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id = aws_subnet.private[count.index].id

  route_table_id = aws_route_table.private.id
}

############################
# VPC Endpoints
############################

locals {
  endpoints = [
    "ssm",
    "ec2messages",
    "ssmmessages",
    "logs"
  ]
}

resource "aws_security_group" "endpoint_sg" {
  name   = "${var.environment}-endpoint-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [var.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "interface" {
  count = var.enable_vpc_endpoints ? length(local.endpoints) : 0

  vpc_id = aws_vpc.this.id

  service_name = "com.amazonaws.${data.aws_region.current.name}.${local.endpoints[count.index]}"

  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true
}
