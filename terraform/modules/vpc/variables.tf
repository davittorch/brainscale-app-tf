variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Boolean flag to enable/disable DNS support in the VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Boolean flag to enable/disable DNS hostnames in the VPC"
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for the subnets"
}
