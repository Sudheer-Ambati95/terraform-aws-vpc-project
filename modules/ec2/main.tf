############################
# Launch Template
############################

resource "aws_launch_template" "this" {

  name_prefix = "${var.environment}-lt"

  image_id = var.ami_id

  instance_type = var.instance_type

  vpc_security_group_ids = [
    var.security_group_id
  ]

  iam_instance_profile {

    name = var.instance_profile_name
  }

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.environment}-ec2"
    }
  }
}

############################
# Auto Scaling Group
############################

resource "aws_autoscaling_group" "this" {

  name = "${var.environment}-asg"

  desired_capacity = 1

  min_size = 1

  max_size = 2

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type = "ELB"

  launch_template {

    id = aws_launch_template.this.id

    version = "$Latest"
  }
}
