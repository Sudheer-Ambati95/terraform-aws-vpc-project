############################################
# Security Group for EC2
############################################

resource "aws_security_group" "ec2_sg" {

  name = "ec2-sg"

  description = "Allow HTTP from ALB"

  vpc_id = module.vpc.vpc_id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

}

############################################
# Private EC2 Instance
############################################

resource "aws_instance" "private_ec2" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = "t3.micro"

  #########################################
  # Uses PRIVATE subnet
  #########################################

  subnet_id = module.vpc.private_subnet_ids[0]

  #########################################
  # Enables SSM access
  #########################################

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tags = {
    Name = "private-ec2"
  }

}
