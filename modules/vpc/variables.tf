variable "cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_vpc_endpoints" {
  description = "Enable VPC endpoints"
  type        = bool
  default     = true
}
