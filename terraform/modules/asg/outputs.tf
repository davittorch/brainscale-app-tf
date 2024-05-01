output "launch_template_id" {
  value       = aws_launch_template.app_template.id
  description = "ID of the launch template"
}

output "autoscaling_group_id" {
  value       = aws_autoscaling_group.app_asg.id
  description = "ID of the autoscaling group"
}
