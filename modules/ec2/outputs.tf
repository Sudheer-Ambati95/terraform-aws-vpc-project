############################
# Auto Scaling Group Name
############################

output "asg_name" {
  value = aws_autoscaling_group.this.name
}
