variable "name_prefix" {
  type        = string
  description = "Prefix for names of resources"
}

variable "internal" {
  type        = bool
  default     = false
  description = "Whether the load balancer is internal"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for the load balancer"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs for the load balancer"
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "Enable or disable deletion protection"
}

variable "port" {
  type        = number
  default     = 3000
  description = "Port number for the target group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the target group is located"
}

variable "health_check_path" {
  type        = string
  default     = "/login"
  description = "Health check path"
}

variable "listener_port" {
  type        = number
  default     = 80
  description = "Port number for the listener"
}
