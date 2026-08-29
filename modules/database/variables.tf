variable "standard_name" {
  description = "Standardised name for database resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to database resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC where the database security group will be created"
  type        = string
}

variable "database_subnet_ids" {
  description = "Database subnets for the RDS instance"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to access the database"
  type        = list(string)
}

variable "engine" {
  description = "RDS database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "multi_az" {
  description = "Whether the RDS instance should be Multi-AZ"
  type        = bool
  default     = false
}