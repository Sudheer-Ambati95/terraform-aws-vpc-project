variable "cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "enable_vpc_endpoints" {
  type    = bool
  default = true
}
