data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2"
    ]
  }
}

###########################
# VPC
###########################

module "vpc" {

  source = "../../modules/vpc"

  cidr        = var.vpc_cidr
  environment = var.environment
}

###########################
# ALB
###########################

module "alb" {

  source = "../../modules/alb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = aws_security_group.alb_sg.id
}

###########################
# EC2
###########################

module "ec2" {

  source = "../../modules/ec2"

  environment = var.environment

  # REQUIRED
  subnet_ids = module.vpc.private_subnet_ids

  # REQUIRED
  private_subnet_ids = module.vpc.private_subnet_ids

  security_group_id = aws_security_group.ec2_sg.id

  ami_id = data.aws_ami.amazon_linux.id

  instance_profile_name = aws_iam_instance_profile.ssm_profile.name

  target_group_arn = module.alb.target_group_arn
}
