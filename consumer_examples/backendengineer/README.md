# Kate - The Backend Engineer at Beejan Technologies

## The Scenario

Kate is a Backend Engineer at Beejan Technologies. Her team is responsible for building and running backend applications that support the company's products and services.

For a new project, Kate needs an AWS environment where her team can:
* Run their backend application using a containerized workload
* Use Amazon ECS with Fargate to run the application without managing EC2 servers
* Store application data and files in S3
* Have a properly isolated network foundation for the workload

Previously, Kate would have to request these resources from the Platform Engineering team or create the Terraform herself. With COB, she can consume the company's standard infrastructure capabilities instead.

## How Kate Uses COB

Kate does not need to know how COB creates the underlying AWS resources. She simply composes the capabilities required for her workload:

| Step | Component |
|------|-----------|
| 1 | Kate → "I need a standard backend environment" |
| 2 | COB |
| 2a | ├── Naming |
| 2b | ├── Networking |
| 2c | ├── Storage |
| 2d | ├── IAM |
| 2e | └── Compute |
| 3 | → AWS Backend Environment |

Her consumer configuration tells COB what she needs for her environment. For example, her inputs include:

```
Environment: prod
AWS Region: eu-west-2
Availability Zones:
  - eu-west-2a
  - eu-west-2b
VPC CIDR: <CIDR>
NAT Gateway Strategy: <strategy>
EC2 Role: false
ECS Roles: true
S3 Access Policy: true
```

Kate then connects the capabilities together so that the compute workload can use the networking, storage, and IAM capabilities provisioned for her environment.

## What Kate Gets

After provisioning, COB gives Kate the infrastructure she needs without her having to manually define every underlying AWS resource.

The resulting environment includes:

**Networking:**

| Component |
|-----------|
| VPC |
| ├── Public Subnets |
| ├── Private Subnets |
| └── Database Subnets |

**Backend application flow:**

| Order | Resource |
|-------|----------|
| 1 | S3 Data Bucket |
| 2 | ECS Cluster |
| 3 | ECS Task Definition |
| 4 | ECS Fargate Service |

**IAM:**

| Component |
|-----------|
| ECS Task Execution Role |
| ECS Task Role |
| S3 Access Policy |

Because Kate is using Fargate, an EC2 instance role and instance profile are not provisioned for this environment.

COB also exposes useful outputs to Kate:

| Output |
|--------|
| `vpc_id` |
| `data_bucket_name` |
| `data_bucket_arn` |
| `ecs_cluster_id` |
| `ecs_service_id` |

These outputs give Kate the information she needs to reference the infrastructure from other parts of her backend application or deployment workflow.

## What This Solves for Kate

Before COB, Kate would need to spend time designing and provisioning the infrastructure herself or wait for Platform Engineering to do it.

With COB, she provisions faster because the infrastructure capabilities already exist.

In short, Kate doesn't have to ask:

"How do I build all of this AWS infrastructure?"

She can focus on:

"What infrastructure does my backend workload need?"

and let COB handle the standardised implementation.