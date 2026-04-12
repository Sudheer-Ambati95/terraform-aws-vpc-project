resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "dev-vpc"
    }
  )
}

data "aws_availability_zones" "available" {}

############################################
# Public Subnets
############################################

resource "aws_subnet" "public" {
  count = 2

  vpc_id = aws_vpc.this.id

  cidr_block = cidrsubnet(var.cidr, 4, count.index)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

############################################
# Private Subnets
############################################

resource "aws_subnet" "private" {
  count = 2

  vpc_id = aws_vpc.this.id

  cidr_block = cidrsubnet(var.cidr, 4, count.index + 2)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

############################################
# Internet Gateway
############################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "dev-igw"
  }
}
