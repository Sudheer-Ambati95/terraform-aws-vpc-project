############################
# Environment
############################

variable "environment" {
  type = string
}

############################
# Subnets
############################

variable "subnet_ids" {
  type = list(string)
}

############################
# Security Group
############################

variable "security_group_id" {
  type = string
}

############################
# AMI
############################

variable "ami_id" {
  type = string
}

############################
# Instance Type
############################

variable "instance_type" {
  default = "t3.micro"
}

############################
# Instance Profile
############################

variable "instance_profile_name" {
  type = string
}

############################
# Target Group
############################

variable "target_group_arn" {
  type = string
}

################################
# Private Subnets
################################

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG"
  type        = list(string)
}
