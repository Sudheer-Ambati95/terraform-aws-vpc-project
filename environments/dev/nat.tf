########################################
# Elastic IP
########################################

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

########################################
# NAT Gateway
########################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = module.vpc.public_subnets[0]

  tags = {
    Name = "dev-nat-gateway"
  }

}

########################################
# Private Route Table
########################################

resource "aws_route_table" "private_rt" {

  vpc_id = module.vpc.vpc_id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }

  tags = {
    Name = "private-route-table"
  }

}

########################################
# Associate Private Subnets
########################################

resource "aws_route_table_association" "private_assoc" {

  count = length(module.vpc.private_subnets)

  subnet_id = module.vpc.private_subnets[count.index]

  route_table_id = aws_route_table.private_rt.id

}
