variable "team" {
  description = "Name of the consuming team"
  type        = string
}

variable "project" {
  description = "Name of the consuming project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either 'dev' or 'prod'."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability Zones for the environment"
  type        = list(string)
}

variable "nat_gateway_strategy" {
  description = "NAT Gateway deployment strategy"
  type        = string

  validation {
    condition     = contains(["one_per_az", "single"], var.nat_gateway_strategy)
    error_message = "nat_gateway_strategy must be either 'one_per_az' or 'single'."
  }
}

variable "container_image" {
  description = "Docker image used by the backend application"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the backend application"
  type        = number
}

variable "cpu" {
  description = "CPU units allocated to the ECS task"
  type        = number
}

variable "memory" {
  description = "Memory allocated to the ECS task"
  type        = number
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
}