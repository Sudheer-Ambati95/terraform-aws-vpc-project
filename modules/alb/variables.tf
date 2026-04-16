############################
# Environment
############################

variable "environment" {
  type = string
}

############################
# VPC
############################

variable "vpc_id" {
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
