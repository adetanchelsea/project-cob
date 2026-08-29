# Project COB
COB is an internal Terraform-based infrastructure provisioning platform for Beejan Technologies. It provides reusable AWS infrastructure capabilities that engineering teams can consume instead of repeatedly designing and provisioning the same infrastructure from scratch.

## The Problem

As Beejan Technologies has grown, more engineering teams have started running workloads on AWS. This has increased the workload on the Platform Engineering team. When a team needs infrastructure, they may currently need to submit a request to Platform Engineering or implement the infrastructure themselves.

A typical request may require:

- A VPC and subnets
- Security groups
- IAM roles and policies
- S3 storage
- EC2 instances
- ECS infrastructure
- RDS databases
- Supporting AWS services

As more teams implement infrastructure independently, inconsistencies can develop.

For example:

- S3 buckets may use different security configurations.
- IAM policies may be inconsistent.
- Resource naming and tagging may vary.
- Network configurations may differ between projects.
- Similar infrastructure may be repeatedly implemented.
- Platform Engineering can become a bottleneck for infrastructure requests.

COB was created to address this problem.

---

# The Solution

COB provides reusable Terraform capabilities for common AWS infrastructure requirements. Instead of asking each engineering team to implement individual AWS resources from scratch, COB provides standardised infrastructure capabilities that can be composed according to the workload.

The platform is designed around three principles:

1. **Reusability** — infrastructure capabilities can be consumed across projects and environments.
2. **Standardisation** — common security, naming, tagging and configuration practices are implemented centrally.
3. **Flexibility** — consumers can provide workload-specific configuration where the decision legitimately belongs to them.

---

# Platform Capabilities

The first version of COB provides the following capabilities.

## Networking

Provides a standard AWS network foundation for workloads, including:

- VPC
- Public subnets
- Private subnets
- Database subnets
- Routing
- Internet connectivity
- NAT Gateway configuration
- Network security boundaries

The networking capability is designed to be reusable across environments while allowing consumers to provide appropriate environment-specific configuration.

---

## Identity and Access

Provides reusable IAM patterns for workloads that require AWS permissions.

The capability supports workload-specific roles and policies while maintaining standard trust relationships and access patterns.

Examples include:

- EC2 instance roles
- EC2 instance profiles
- ECS task execution roles
- ECS task roles
- S3 access policies

Compute-specific IAM resources are optional so that consumers are not forced to create IAM resources for workloads they do not use.

---

## Object Storage

Provides a standardised S3 storage capability.

The storage capability includes security and operational defaults such as:

- Server-side encryption
- Versioning
- Public access blocking
- Standard naming
- Resource tagging

The purpose is to make secure and consistent storage the default rather than requiring every consumer to implement the same controls independently.

---

## Compute

COB supports two compute capabilities:

- EC2
- ECS

### EC2

Provides reusable infrastructure for workloads that require virtual machines.

Consumers can provide workload-specific configuration such as:

- AMI ID
- Instance type
- Networking configuration
- IAM configuration

### ECS

Provides reusable infrastructure for containerised workloads.

Consumers can provide workload-specific configuration such as:

- Container image
- Service configuration
- Networking
- IAM configuration

---

## Relational Database

COB provides an RDS capability for workloads requiring a managed relational database. The capability is designed to work with COB's networking and security foundations rather than requiring each consumer to independently implement those relationships.

---

## Data Platform

COB provides capabilities for teams that need to make data stored in S3 available for analytics.

The capability integrates:

- S3
- AWS Glue Data Catalog
- Glue tables
- Amazon Athena

This allows a data workload to compose the infrastructure required for analytics without independently implementing each AWS service integration.

---

# Architecture

The architecture diagram shows how engineering teams consume COB capabilities and how those capabilities provision AWS infrastructure.

![COB Architecture Diagram](docs/architecture.png)

---

# How COB Is Consumed

COB is designed so that consumers interact with a clean Terraform interface rather than needing to understand every implementation detail inside the platform.

The general workflow is:

```text
Engineering Team
       │
       ▼
Identify workload requirements
       │
       ▼
Select COB capabilities
       │
       ▼
Configure inputs
       │
       ▼
Compose capabilities
       │
       ▼
terraform plan
       │
       ▼
terraform apply
       │
       ▼
AWS Infrastructure
```

For example, a workload may require:

```
Networking
     +
IAM
     +
Storage
     +
Compute
```

Another workload may require:

```
Networking
     +
Storage
     +
Data Platform
```

The consumer chooses the capabilities it needs. COB handles the implementation of the underlying AWS resources.

## Inputs and Outputs

COB exposes configuration through Terraform input variables and outputs.

### Inputs

Consumers provide values that vary between workloads or environments.

Examples include:

- AWS region
- Environment
- Availability Zones
- VPC CIDR
- NAT Gateway strategy
- AMI ID
- EC2 instance type
- Container image
- Workload-specific configuration

The values are not hardcoded into the modules. This allows the same COB capability to be used by different teams with different requirements.

### Outputs

COB exposes useful values from provisioned infrastructure so that consumers can reference them from other parts of their Terraform configuration.

Examples include:

- `vpc_id`
- `data_bucket_name`
- `data_bucket_arn`
- `ecs_cluster_id`
- `ecs_service_id`

Capability-specific outputs are exposed where required. The purpose of outputs is to give consumers the information they need without requiring them to understand how the underlying resources were implemented.

## Getting Started (How to Use COB)

This section describes how you as a new engineer can clone the repository and work with COB.

### Prerequisites

Before using COB, install and configure:
- Git
- Terraform
- AWS CLI
- AWS credentials with the permissions required for the resources being provisioned.

Verify Terraform is installed:

```
terraform version
```

Verify AWS CLI access:

```
aws sts get-caller-identity
```

The AWS command should return information about the authenticated AWS identity.

### 1. Clone the Repository

Clone the repository and move into the project directory:

```
git clone https://github.com/adetanchelsea/project-cob.git
cd project-cob
```

### 2. Understand the Repository

The repository is organised as follows:

```
project-cob/
│
├── modules/
│   └── Reusable COB infrastructure capabilities
│
├── environments/
│   ├── dev/
│   └── prod/
│
├── consumer_examples/
│   ├── dataengineer/
│   └── backendengineer/
│
├── terraformstate/
│
├── providers.tf
├── versions.tf
├── .gitignore
└── README.md
```

**modules/**

Contains the reusable infrastructure capabilities that make up COB.

**environments/**

Contains the Dev and Prod configurations used to test and deploy COB itself. These are not the primary consumer examples.

**consumer_examples/**

Contains realistic examples demonstrating how engineering teams can consume COB. The examples are demonstrations of the platform rather than special implementations required by COB.

**terraformstate/**

Contains the configuration used to provision the S3 bucket that stores Terraform remote state.

**providers.tf**

Contains Terraform provider configuration.

**versions.tf**

Defines Terraform and provider version requirements.

### 3. Terraform Workflow

The standard Terraform workflow used throughout COB is:

```
terraform init
       ↓
terraform fmt
       ↓
terraform validate
       ↓
terraform plan
       ↓
terraform apply
```

`terraform init` prepares the working directory, installs required providers and modules, and initializes the configured backend.

`terraform validate` checks that the Terraform configuration is valid and internally consistent.

`terraform plan` shows the infrastructure changes Terraform intends to make without applying them.

`terraform apply` executes the proposed infrastructure changes after approval.

### 4. Working with COB Environments

The repository contains:

```
environments/
├── dev/
└── prod/
```

These directories are used for testing and deploying COB itself.

For example:

```
cd environments/dev
```

Then initialise Terraform:

```
terraform init
```

Format the configuration:

```
terraform fmt
```

Validate the configuration:

```
terraform validate
```

Review the proposed infrastructure:

```
terraform plan
```

If the plan is correct:

```
terraform apply
```

Always review the Terraform plan before applying infrastructure changes.

### 5. Working with Consumer Examples

The repository contains example consumers under:

```
consumer_examples/
```

For example:

```
consumer_examples/
├── dataengineer/
└── backendengineer/
```

These examples demonstrate how different workloads can compose COB capabilities.

To work with an example:

```
cd consumer_examples/<example>
```

Then:

```
terraform init
terraform fmt
terraform validate
terraform plan
```

If you intend to provision the example infrastructure and have the required AWS permissions:

```
terraform apply
```

The examples should be treated as demonstrations of how COB can be consumed, rather than as special requirements of the platform.

### 6. Configuring Consumer Inputs

Consumer-specific values are supplied through Terraform variables.

The general pattern is:

```
variables.tf
      │
      ▼
Defines available inputs
      │
      ▼
terraform.tfvars
      │
      ▼
Provides values for a specific environment/workload
```

For example:

```
environment  = "dev"
aws_region   = "eu-west-2"
vpc_cidr     = "10.0.0.0/16"
```

Workload-specific values such as:

```
ami_id        = "..."
instance_type = "t3.micro"
container_image = "..."
```

are supplied by the consumer rather than hardcoded into reusable COB modules.

## Remote Terraform State

COB uses remote Terraform state stored in Amazon S3.

A dedicated configuration under:

```
terraformstate/
```

creates the state bucket before the environment configurations use it.

The state bucket is:

```
project-cob-terra-state
```

The state bucket has:

- Versioning enabled
- Server-side encryption
- Public access blocked

The environment state is separated so that Dev and Prod do not share the same Terraform state. The state infrastructure is intentionally separated from the environment configurations because the backend must exist before it can be used to manage the environment infrastructure.

### State Infrastructure

The state bucket can be managed from:

```
cd terraformstate
```

Then:

```
terraform init
terraform validate
terraform plan
```

If changes are required:

```
terraform apply
```

The resulting state bucket is then used as the remote state backend for the Terraform configurations.

## NAT Gateway Strategy

The networking capability deliberately keeps the NAT Gateway strategy configurable. COB does not force every consumer into one fixed NAT Gateway implementation. This is intentional because the appropriate network configuration can depend on the environment and workload.

For example, a development environment may have different cost and availability requirements from a production environment. The platform therefore provides the networking capability and its standards while allowing the consumer to provide the appropriate NAT Gateway strategy.

## Security Standards

COB is designed to establish sensible security defaults through its infrastructure capabilities.

### S3

The storage capability includes:

- Server-side encryption
- Versioning
- Public access blocking

### IAM

COB provides reusable IAM patterns and separates workload roles according to their purpose. The design supports least-privilege access rather than requiring consumers to create broad permissions independently.

### Networking

The networking capability provides separation between network tiers and supports controlled routing between them.

### Environment Separation

Dev and Prod are maintained as separate Terraform configurations and use separate remote state locations.

### Secrets

Terraform variable files are excluded from version control. Secrets should not be committed to the repository.

## Design Decisions

COB is intended to be a platform rather than simply a collection of Terraform resources. The following decisions are therefore important to the design.

### 1. Capability-Based Modules

COB modules represent meaningful infrastructure capabilities rather than thin wrappers around individual AWS resources. For example, the storage capability does more than create:

```
aws_s3_bucket
```

It also establishes related configuration such as:

```
S3 Bucket
├── Encryption
├── Versioning
├── Public Access Controls
├── Naming
└── Tagging
```

This makes the module useful as a platform capability rather than simply adding another abstraction layer around an AWS resource.

### 2. Consumer Inputs

COB establishes standards centrally, but it does not hardcode every possible workload decision.

Values such as:

- AMI ID
- EC2 instance type
- Container image
- NAT Gateway strategy
- Environment-specific networking values

can be supplied by consumers.

This allows COB to remain reusable across different workloads.

### 3. Configurable NAT Gateway Strategy

The networking capability intentionally leaves the NAT Gateway strategy open to configuration. This prevents COB from making a single cost or availability decision for every workload. The platform establishes the networking structure while the consumer provides the strategy appropriate to the environment.

### 4. Independent EC2 and ECS Capabilities

COB supports both EC2 and ECS, but consumers should not be forced to provision both. The compute capabilities can be composed according to workload requirements. The same principle applies to the related IAM resources.
For example, ECS roles are not required for a workload that only uses EC2.

### 5. Consumer Examples and Environments Are Separate

The repository separates:

```
consumer_examples/
```

from:

```
environments/
```

Consumer examples demonstrate how engineering teams consume COB. Dev and Prod are used to test and deploy COB itself.This distinction prevents the platform's own deployment configuration from being confused with an actual consumer implementation.

### 6. Remote State

Terraform state is stored remotely in S3 rather than relying on local state for the environment configurations. Dev and Prod have separate state locations. This provides a more appropriate foundation for a shared infrastructure platform and prevents state files from being stored in the Git repository.

## Consumer Examples

The repository contains two example consumers. They exist to demonstrate that the COB abstractions can be reused for different workloads.

### Data Engineering

The Data Engineering example demonstrates a workload requiring:

- Networking
- S3
- Glue
- Athena

The example shows how multiple COB capabilities can be composed into a realistic data environment.
See:

```
consumer_examples/dataengineer/
```

for the implementation and documentation.

### Backend Engineering

The Backend Engineering example demonstrates a workload requiring a standard application environment using COB's networking, IAM and compute capabilities. The example demonstrates that another engineering team can consume COB without rebuilding the underlying AWS infrastructure independently.

See:

```
consumer_examples/backendengineer/
```

for the implementation and accompanying documentation.

## Assumptions

The current version of COB makes the following assumptions:

- AWS is the target cloud platform.
- Terraform is used as the infrastructure provisioning tool.
- Consumers have appropriate AWS permissions for the infrastructure they are provisioning.
- Workload-specific configuration is provided by the consumer.
- COB establishes standard infrastructure patterns but does not attempt to solve every possible AWS infrastructure requirement.
- Dev and Prod are used as COB testing/deployment environments.
- The consumer examples demonstrate platform usage rather than representing application architectures.

## Limitations

COB is the first version of the internal infrastructure platform and does not yet cover every requirement that would exist in a mature enterprise platform.

Current limitations include:
- The number of supported AWS capabilities is limited.
- Consumer onboarding is currently Terraform-based.
- CI/CD automation for infrastructure changes is not yet implemented as part of COB.
- Centralised infrastructure monitoring and observability are not yet provided as COB capabilities.

These limitations do not prevent COB from demonstrating the core platform model required for the first version.

## Project Outcome

COB provides a foundation for standardised AWS infrastructure provisioning across Beejan Technologies.

The platform demonstrates how reusable Terraform capabilities can:

- Reduce repeated infrastructure implementation
- Establish consistent infrastructure standards
- Encourage secure-by-default configurations
- Allow infrastructure to be reused across workloads and environments
- Give engineering teams a simpler interface for provisioning infrastructure
- Allow Platform Engineering to improve infrastructure standards centrally

The objective is to demonstrate that infrastructure can be designed as a reusable internal platform that other engineers can confidently consume.

## Useful Resources

The following resources were useful for understanding Terraform, AWS provider configuration, modules, state management and the Terraform workflow used in COB.

### Terraform

- Terraform Documentation — General Terraform documentation and language reference.
- Terraform CLI Documentation — Reference for Terraform CLI commands.
- Terraform Init — Initialising Terraform working directories, providers, modules and backends.
- Terraform Validate — Validating Terraform configuration.
- Terraform Plan — Reviewing proposed infrastructure changes.
- Terraform Apply — Applying infrastructure changes.
- Terraform Modules — Understanding reusable Terraform modules.
- Terraform Module Tutorials — Practical examples of building and consuming modules.
- Terraform Input Variables — Defining and using configurable inputs.
- Terraform Outputs — Exposing values from Terraform configurations.
- Terraform State — Understanding Terraform state.
- Terraform S3 Backend — Configuring Amazon S3 for Terraform remote state.

### AWS Provider

- Terraform AWS Provider — Official Terraform provider for AWS resources.
- AWS Provider Documentation — Resource and data source reference for AWS infrastructure.

### AWS Services

- Amazon VPC Documentation — AWS networking and VPC concepts.
- Amazon S3 Documentation — Object storage, encryption, versioning and bucket security.
- Amazon EC2 Documentation — AWS virtual machine infrastructure.
- Amazon ECS Documentation — Containerised workloads on AWS.
- Amazon RDS Documentation — Managed relational databases.
- AWS Glue Documentation — AWS Glue and the Data Catalog.
- Amazon Athena Documentation — Querying data in Amazon S3 using SQL.