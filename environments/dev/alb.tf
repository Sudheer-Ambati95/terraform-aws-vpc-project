############################################
# ALB Security Group
############################################

resource "aws_security_group" "alb_sg" {

  name = "alb-sg"

  vpc_id = module.vpc.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

############################################
# Application Load Balancer
############################################

resource "aws_lb" "app_alb" {

  name = "dev-alb"

  load_balancer_type = "application"

  subnets = module.vpc.public_subnets

  security_groups = [
    aws_security_group.alb_sg.id
  ]

}

############################################
# Target Group
############################################

resource "aws_lb_target_group" "app_tg" {

  name = "dev-target-group"

  port = 80

  protocol = "HTTP"

  vpc_id = module.vpc.vpc_id

}

############################################
# Attach EC2 to Target Group
############################################

resource "aws_lb_target_group_attachment" "ec2_attach" {

  target_group_arn = aws_lb_target_group.app_tg.arn

  target_id = aws_instance.private_ec2.id

  port = 80

}

############################################
# Listener
############################################

resource "aws_lb_listener" "http_listener" {

  load_balancer_arn = aws_lb.app_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.app_tg.arn

  }

}
