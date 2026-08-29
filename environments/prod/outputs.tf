output "vpc_id" {
  description = "ID of the prod VPC"
  value       = module.networking.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the prod private subnets"
  value       = module.networking.private_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs of the prod database subnets"
  value       = module.networking.database_subnet_ids
}

output "s3_bucket_name" {
  description = "Name of the prod S3 bucket"
  value       = module.storage.bucket_name
}

output "ec2_instance_id" {
  description = "ID of the prod EC2 instance"
  value       = module.ec2.instance_id
}