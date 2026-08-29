output "vpc_id" {
  description = "ID of the VPC provisioned"
  value       = module.networking.vpc_id
}

output "data_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.storage.bucket_name
}

output "data_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.storage.bucket_arn
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_service_id" {
  description = "ID of the ECS service"
  value       = module.ecs.service_id
}