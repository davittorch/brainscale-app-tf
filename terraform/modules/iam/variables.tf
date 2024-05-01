variable "role_name" {
  type        = string
  description = "The name of the IAM role for EC2 instances"
}

variable "instance_profile_name" {
  type        = string
  description = "The name of the IAM instance profile associated with the role"
}
