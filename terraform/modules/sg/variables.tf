variable "name_prefix" {
  type        = string
  description = "Prefix for the names of the security groups"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security groups will be created"
}
