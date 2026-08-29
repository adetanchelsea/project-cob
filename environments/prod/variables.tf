variable "aws_region" {
  description = "AWS region for the prod environment"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the prod VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "azs" {
  description = "Availability Zones for the prod environment"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "nat_gateway_strategy" {
  description = "NAT Gateway strategy for the prod environment"
  type        = string
  default     = "single"
}

variable "ami_id" {
  description = "AMI ID for the prod EC2 instance"
  type        = string
}

variable "container_image" {
  description = "Container image for the prod ECS service"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}