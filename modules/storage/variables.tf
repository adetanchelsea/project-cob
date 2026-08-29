variable "standard_name" {
  description = "Standardised name for the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags applied to the S3 bucket"
  type        = map(string)
}

variable "versioning_enabled" {
  description = "Whether S3 bucket versioning is enabled"
  type        = bool
  default     = true
}

variable "lifecycle_expiration_days" {
  description = "Number of days before old object versions expire"
  type        = number
  default     = 90

  validation {
    condition     = var.lifecycle_expiration_days > 0
    error_message = "lifecycle_expiration_days must be greater than 0."
  }
}