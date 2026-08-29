output "cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "service_id" {
  description = "ECS service ID"
  value       = aws_ecs_service.ecs_service.id
}