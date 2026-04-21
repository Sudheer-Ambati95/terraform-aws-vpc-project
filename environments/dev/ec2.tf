################################
# EC2 Security Group
################################

resource "aws_security_group" "ec2_sg" {

  name = "${var.environment}-ec2-sg"

  vpc_id = module.vpc.vpc_id

  ingress {

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}
