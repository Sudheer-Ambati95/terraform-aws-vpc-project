############################################
# Security Group for ALB
############################################

resource "aws_security_group" "alb_sg" {

  name = "alb-sg"

  description = "Allow HTTP traffic"

  vpc_id = module.vpc.vpc_id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
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
# Application Load Balancer
# Uses PUBLIC subnets
############################################

resource "aws_lb" "app_alb" {

  name = "app-alb"

  internal = false

  load_balancer_type = "application"

  subnets = module.vpc.public_subnet_ids

  security_groups = [
    aws_security_group.alb_sg.id
  ]

}
