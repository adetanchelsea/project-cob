# COB Compute Modules

The Compute layer provides reusable infrastructure for workloads that require compute resources. COB currently provides two compute capabilities:

- EC2
- ECS

Both capabilities are implemented as reusable Terraform modules and can be consumed by multiple environments without duplicating the underlying infrastructure code.

## EC2 Module

The EC2 module provisions an EC2 application server and its associated security group. The module receives environment-specific configuration such as the AMI, instance type, subnet, IAM instance profile, and tags from the consuming environment. The EC2 instance is deployed into a private subnet supplied by the Networking module.

### Resources

The EC2 module provisions:

- EC2 instance
- EC2 security group

### Networking

The EC2 instance is deployed into a subnet supplied by the Networking module. The subnet and VPC are provided by the environment configuration, allowing the same EC2 module to be reused across Dev and Prod.

### IAM

The EC2 instance receives an IAM instance profile supplied by the IAM module. The EC2 module does not create the IAM role or instance profile itself.

### Security

The EC2 security group controls network traffic to and from the instance. Inbound access is controlled through the `ingress_cidr_blocks` variable. No inbound CIDR blocks are allowed by default.

### EC2 Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `standard_name` | `string` | — | Standardised name for EC2 resources |
| `tags` | `map(string)` | — | Tags applied to EC2 resources |
| `iam_instance_profile` | `string` | — | IAM instance profile for the EC2 instance |
| `ami_id` | `string` | — | AMI ID for the EC2 instance |
| `instance_type` | `string` | `t3.micro` | EC2 instance type |
| `subnet_id` | `string` | — | Subnet where the EC2 instance is deployed |
| `ingress_cidr_blocks` | `list(string)` | `[]` | CIDR blocks allowed to access the EC2 instance |
| `vpc_id` | `string` | — | VPC where the EC2 security group is created |

### EC2 Outputs

| Name | Description |
|---|---|
| `instance_id` | EC2 instance ID |
| `security_group_id` | EC2 security group ID |

## ECS Module

The ECS module provides reusable infrastructure for running containerised workloads using Amazon ECS with AWS Fargate. The module creates the ECS resources required to run a containerised workload while receiving environment-specific configuration from the consuming environment.

### Resources

The ECS module provisions:

- ECS cluster
- ECS Fargate task definition
- ECS service
- CloudWatch log group

### Task Configuration

The ECS task definition supports configurable:

- Container image
- Container port
- CPU
- Memory
- Desired task count

The container image is supplied by the consuming environment through the `container_image` variable.

### Networking

ECS tasks are deployed into private subnets supplied by the Networking module. Public IP assignment is disabled so that ECS tasks do not receive public IP addresses. The ECS module does not create the VPC or subnet infrastructure itself. These resources are provided by the Networking capability.

### IAM

The ECS task definition receives:

- ECS task execution role
- ECS task role

Both roles are supplied by the IAM module. This keeps IAM responsibilities separate from the Compute module.

### Logging

The ECS module creates a dedicated CloudWatch log group for container logs. The log group has a 30-day retention period.Container logs are configured to use the AWS CloudWatch Logs driver.

### ECS Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `standard_name` | `string` | — | Standardised name for ECS resources |
| `tags` | `map(string)` | — | Tags applied to ECS resources |
| `private_subnet_ids` | `list(string)` | — | Private subnets where ECS tasks will run |
| `execution_role_arn` | `string` | — | ARN of the ECS task execution role |
| `task_role_arn` | `string` | — | ARN of the ECS task role |
| `container_image` | `string` | — | Container image for the ECS task |
| `container_port` | `number` | `80` | Port exposed by the container |
| `cpu` | `number` | `256` | CPU units allocated to the ECS task |
| `memory` | `number` | `512` | Memory in MiB allocated to the ECS task |
| `desired_count` | `number` | `1` | Number of ECS tasks to keep running |

### ECS Outputs

| Name | Description |
|---|---|
| `cluster_id` | ECS cluster ID |
| `service_id` | ECS service ID |

## Environment Reuse

The Compute modules are designed to be reused across multiple environments.

COB currently supports:

- Dev
- Prod

The Dev and Prod environments consume the same EC2 and ECS modules while supplying their own specific configuration.

For example:

    module "ecs" {
      source = "../../modules/compute/ecs"
      standard_name      = module.naming.standard_name
      tags               = module.naming.common_tags
      private_subnet_ids = module.networking.private_subnet_ids
      execution_role_arn = module.iam.ecs_task_execution_role_arn
      task_role_arn      = module.iam.ecs_task_role_arn
      container_image    = var.container_image
    }

The module implementation is therefore not duplicated between environments.

## Module Responsibilities

The Compute layer is responsible for provisioning compute workloads. 

| Capability | Responsibility |
|---|---|
| Networking | VPC, subnets, routing and network infrastructure |
| IAM | IAM roles, policies and instance profiles |
| Storage | S3 storage infrastructure |
| Compute | EC2 and ECS workloads |
| Database | RDS database infrastructure |
| Data Platform | Glue and Athena infrastructure |

Compute consumes outputs from other capabilities where required.

## Example Usage

### EC2

    module "ec2" {
      source = "../../modules/compute/ec2"
      standard_name        = module.naming.standard_name
      tags                 = module.naming.common_tags
      ami_id               = var.ami_id
      subnet_id            = module.networking.private_subnet_ids[0]
      vpc_id               = module.networking.vpc_id
      iam_instance_profile = module.iam.ec2_instance_profile_name
    }

### ECS

    module "ecs" {
      source = "../../modules/compute/ecs"
      standard_name      = module.naming.standard_name
      tags               = module.naming.common_tags
      private_subnet_ids = module.networking.private_subnet_ids
      execution_role_arn = module.iam.ecs_task_execution_role_arn
      task_role_arn      = module.iam.ecs_task_role_arn
      container_image    = var.container_image
    }

## Security Considerations

The Compute modules are designed to support secure-by-default infrastructure. Current security measures include:

- EC2 instances are deployed into private subnets.
- ECS tasks are deployed into private subnets.
- ECS tasks do not receive public IP addresses.
- EC2 inbound traffic is controlled through security-group rules.
- IAM roles and instance profiles are managed separately through the IAM capability.
- Environment-specific infrastructure is separated through independent Dev and Prod configurations.