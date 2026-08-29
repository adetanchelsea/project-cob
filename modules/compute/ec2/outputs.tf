output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.application_server.id
}

output "security_group_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2_security_group.id
}