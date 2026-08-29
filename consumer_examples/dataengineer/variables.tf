variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either 'dev' or 'prod'."
  }
}

variable "team" {
  description = "Name of the consuming team"
  type        = string
}

variable "project" {
  description = "Name of the consuming project"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "nat_gateway_strategy" {
  description = "NAT Gateway strategy"
  type        = string

  validation {
    condition     = contains(["single", "one_per_az"], var.nat_gateway_strategy)
    error_message = "nat_gateway_strategy must be either 'single' or 'one_per_az'."
  }
}