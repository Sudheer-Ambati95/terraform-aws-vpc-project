variable "environment" {

  default = "dev"
}

variable "vpc_cidr" {

  default = "10.0.0.0/16"
}

############################
# IAM Role Name
############################

variable "instance_role_name" {
  description = "Name of EC2 IAM role for SSM access"
  type        = string
}
