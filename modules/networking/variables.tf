variable "standard_name" {
  description = "Standardised name for networking resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to networking resources"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "nat_gateway_strategy" {
  description = "NAT Gateway strategy: single or one_per_az"
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "one_per_az"], var.nat_gateway_strategy)
    error_message = "nat_gateway_strategy must be either 'single' or 'one_per_az'."
  }
}