output "ecr_repository_name" {
  value       = aws_ecr_repository.app.name
  description = "The name of the ECR repository"
}

output "ecr_repository_arn" {
  value       = aws_ecr_repository.app.arn
  description = "The ARN of the ECR repository"
}
