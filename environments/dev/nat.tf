############################################
# Elastic IP for NAT
############################################

resource "aws_eip" "nat" {

  domain = "vpc"

}

############################################
# NAT Gateway
############################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  #########################################
  # Runs in PUBLIC subnet
  #########################################

  subnet_id = module.vpc.public_subnet_ids[0]

  tags = {
    Name = "nat-gateway"
  }

}
