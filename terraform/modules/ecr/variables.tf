variable "repository_name" {
  type        = string
  description = "The name of the ECR repository"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "The tag mutability settings for the repository."
}

variable "force_delete" {
  type        = bool
  default     = true
  description = "Specifies whether the repository should be deleted when the Terraform resource is destroyed"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Indicates whether images are scanned after being pushed to the repository"
}
