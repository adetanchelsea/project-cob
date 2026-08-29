variable "standard_name" {
  description = "Standardised name for EC2 resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to EC2 resources"
  type        = map(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet where the EC2 instance will be deployed"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access the EC2 instance"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC where the EC2 security group will be created"
  type        = string
}
