output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value = var.create_ecs_roles ? aws_iam_role.ecs_task_execution_role[0].arn : null
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value = var.create_ecs_roles ? aws_iam_role.ecs_task_role[0].arn : null
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value = var.create_ec2_role ? aws_iam_instance_profile.ec2_instance_profile[0].name : null
}

output "ec2_role_arn" {
  description = "ARN of the EC2 instance IAM role"
  value = var.create_ec2_role ? aws_iam_role.ec2_instance_role[0].arn : null
}