output "glue_database_name" {
  description = "Name of the Glue catalog database"
  value       = aws_glue_catalog_database.data_catalog.name
}

output "glue_table_name" {
  description = "Name of the Glue catalog table"
  value       = aws_glue_catalog_table.s3_data.name
}

output "athena_workgroup_name" {
  description = "Name of the Athena workgroup"
  value       = aws_athena_workgroup.analytics.name
}

