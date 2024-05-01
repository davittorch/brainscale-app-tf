output "load_balancer_arn" {
  value       = aws_lb.app_lb.arn
  description = "ARN of the load balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.lb_tg.arn
  description = "ARN of the target group"
}

output "target_group" {
  value = aws_lb_target_group.lb_tg.id
  description = "Target Group of the Load Balancer"
}

output "image_id" {
  value = data.aws_ami.ubuntu.id
  description = "ID of the Ubuntu image"
}
