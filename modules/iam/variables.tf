variable "standard_name" {
  description = "Standardised name for IAM resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to IAM resources"
  type        = map(string)
}

variable "create_ec2_role" {
  description = "Whether to create the IAM role and instance profile for EC2"
  type        = bool
  default     = false
}

variable "create_ecs_roles" {
  description = "Whether to create IAM roles for ECS"
  type        = bool
  default     = false
}

variable "create_s3_access_policy" {
  description = "Whether to create an IAM policy granting ECS tasks access to the S3 bucket"
  type        = bool
  default     = false
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket the ECS task is allowed to access"
  type        = string
  default     = null
}