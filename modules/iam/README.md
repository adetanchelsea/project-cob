# COB IAM Module

The IAM module provides the standard IAM roles and instance profile required by COB compute workloads.

## Purpose

This module creates separate IAM identities for:
- ECS task execution
- ECS application tasks
- EC2 workloads

Separating these roles allows each workload to receive only the permissions it requires.

## Resources

### ECS Task Execution Role

The execution role is used by Amazon ECS to perform AWS operations required to start and manage ECS tasks. The module attaches the AWS-managed `AmazonECSTaskExecutionRolePolicy`.

### ECS Task Role

The task role is assumed by the application running inside the ECS container. Optional S3 permissions can be attached when an S3 bucket ARN is provided.

### EC2 Instance Role

The EC2 instance role provides AWS permissions to workloads running on the EC2 instance.

### EC2 Instance Profile

The instance profile makes the EC2 IAM role available to the EC2 instance.

## S3 Access

The ECS task can optionally receive access to a configured S3 bucket.

When `s3_bucket_arn` is provided, the task receives:

- `s3:GetObject`
- `s3:PutObject`
- `s3:ListBucket`

When the variable is omitted, the additional S3 policy is not created.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `standard_name` | string | — | Standardised name for IAM resources |
| `tags` | map(string) | — | Tags applied to IAM resources |
| `s3_bucket_arn` | string | `null` | ARN of the S3 bucket the ECS task is allowed to access |

## Outputs

| Name | Description |
|---|---|
| `ecs_task_execution_role_arn` | ARN of the ECS task execution role |
| `ecs_task_role_arn` | ARN of the ECS task role |
| `ec2_instance_profile_name` | Name of the EC2 instance profile |
| `ec2_role_arn` | ARN of the EC2 instance IAM role |

## Security Considerations

- IAM roles are separated by workload responsibility rather than sharing a single role across ECS and EC2.
- Optional S3 access is created only when a bucket ARN is supplied.
- The module should be extended with additional permissions only when a workload has a documented requirement for them.

## Example

```hcl
module "iam" {
  source = "../../modules/iam"
  standard_name = module.naming.standard_name
  tags          = module.naming.common_tags
  s3_bucket_arn = module.storage.bucket_arn
}