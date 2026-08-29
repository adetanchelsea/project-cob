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

output "glue_database_name" {
  description = "Glue Data Catalog database name"
  value       = module.data_platform.glue_database_name
}

output "glue_table_name" {
  description = "Name of the Glue Data Catalog table"
  value       = module.data_platform.glue_table_name
}

output "athena_workgroup_name" {
  description = "Name of the Athena workgroup"
  value       = module.data_platform.athena_workgroup_name
}