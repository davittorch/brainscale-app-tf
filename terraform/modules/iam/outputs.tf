output "iam_role_name" {
  value       = aws_iam_role.ec2_instance_role.name
  description = "The name of the IAM role created"
}

output "iam_instance_profile_name" {
  value       = aws_iam_instance_profile.ec2_instance_role.name
  description = "The name of the IAM instance profile created"
}
