output "standard_name" {
  description = "Standardised resource name"
  value       = local.name_prefix
}

output "common_tags" {
  description = "Standard tags applied to resources"
  value       = local.common_tags
}