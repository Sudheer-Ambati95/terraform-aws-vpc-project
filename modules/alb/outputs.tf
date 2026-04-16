############################
# Target Group ARN
############################

output "target_group_arn" {

  value = aws_lb_target_group.this.arn
}

############################
# ALB DNS
############################

output "alb_dns_name" {

  value = aws_lb.this.dns_name
}
