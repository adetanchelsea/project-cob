output "db_instance_id" {
  description = "ID of the RDS database instance"
  value       = aws_db_instance.postgres.id
}

output "db_endpoint" {
  description = "Endpoint of the RDS database"
  value       = aws_db_instance.postgres.endpoint
}

output "security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database.id
}