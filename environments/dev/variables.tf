variable "aws_region" {
  description = "AWS region for the dev environment"
  type        = string
  default     = "eu-west-2"
}

variable "ami_id" {
  description = "AMI ID for the dev EC2 instance"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones for the dev environment"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "nat_gateway_strategy" {
  description = "NAT Gateway strategy for the dev environment"
  type        = string
  default     = "single"
}

variable "container_image" {
  description = "Container image for the dev ECS service"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

