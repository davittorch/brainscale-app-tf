variable "name_prefix" {
  type        = string
  description = "Prefix for names of resources"
}

variable "public_key" {
  type        = string
  description = "SSH public key for the EC2 instances"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdQerMA+HrPYuQP4NRExGv7aseTYSlN/86n0Zi+pmGX7T2yjMgOACQh+kcEkdnK/TOtvLMCboW5Bov2fsRcM1hJaDuFywhoHTHGDAB1A2uIwukSiWmVEK5hntf+1EXMFEJ9ATLDR7aqmB/K8SEh4/6W9BwvnwyMzOv7pHBTCXgzYrZ82Up2OUtM3d9mcnUdFa/vuNZSs1IcZ6nF8JYQA9vdIlzICEdd749FZqzsIecwlL9Wh/PritUiitUqELSf4Gc1QNalI0L6IEIGegmrptoE7S9NgHQWk4MS8HqdUBTYm+p1ScrHuRAb9fhpoB34PDCpAM/jARZp7waxHFFn8annKsjINLUKh7MJWe1rollzXbYLqyWw9SJqaPd2I+gnn61sFyo2jrlD4tvzqBAWHzVcaXucaElCrm1GdRuGVgVX3Nj1OqNXizf3GKgXh4gEOh1qbimVQj5Q05f6Kd9Y7seX+cpRaIaTKGpKJsR5mrFfyPWAwrXv7uAzeKnBfS7fGVpPfh0H7ziCeqQw5kFF2rdATPksKnGSuDxL8VfghTPZOOCUBtsvEjSyDpp4wV2GTmWs2MtSgYvGPT1W/GoLMcq1IQt0wPzzqp8IJTVFZye3ahC9qECMrxcGKnHFJrSo1F3AFXKntcHp60G9a7Qb0kaERTd76bxmdJCMVv6kWkc0w== david@Torch"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for the EC2 instances"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for EC2 instances"
}

variable "image_id" {
  type        = string
  description = "AMI ID for the EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "user_data" {
  type        = string
  description = "User data for EC2 instances"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the autoscaling group"
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity of the autoscaling group"
}

variable "max_size" {
  type        = number
  description = "Maximum size of the autoscaling group"
}

variable "min_size" {
  type        = number
  description = "Minimum size of the autoscaling group"
}

variable "asg_depends_on" {
  type        = list(string)
  description = "Dependencies for autoscaling group"
}

variable "lb_target_group_arn" {
  type        = string
  description = "Load balancer target group ARN for attachment"
}
