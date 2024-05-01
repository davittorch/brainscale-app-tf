output "instance_sg_id" {
  value       = aws_security_group.instance_sg.id
  description = "ID of the instance security group"
}

output "loadbalancer_sg_id" {
  value       = aws_security_group.loadbalancer_sg.id
  description = "ID of the load balancer security group"
}
