variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "tags" {
  type = map(string)
}
