################################
# IAM Role
################################

resource "aws_iam_role" "ec2_role" {

  name = var.instance_role_name

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }

    ]

  })

}

################################
# Attach SSM Policy
################################

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

################################
# Instance Profile
################################

resource "aws_iam_instance_profile" "ssm_profile" {

  name = "${var.environment}-ssm-profile"

  role = aws_iam_role.ec2_role.name

}
