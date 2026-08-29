variable "standard_name" {
  description = "Standardised name for data platform resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to data platform resources"
  type        = map(string)
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}