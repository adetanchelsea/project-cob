# Chelsea - The Data Engineer at Beejan Technologies

## The Scenario

Chelsea is a Data Engineer at Beejan Technologies. Her team is responsible for building data pipelines that collect data from different business systems and make it available for analytics.

For a new project, Chelsea needs an AWS environment where her team can:

* Store incoming and processed data in S3
* Catalogue the data using AWS Glue
* Allow analysts to query the data using Athena
* Have a properly isolated network foundation for the workload
* Follow Beejan's standard naming, tagging, and security practices

Previously, Chelsea would have to request these resources from the Platform Engineering team or create the Terraform herself. With COB, she can consume the company's standard infrastructure capabilities instead.

## How Chelsea Uses COB

Chelsea does not need to know how COB creates the underlying AWS resources. She simply composes the capabilities required for her workload:

| Step | Component |
|------|-----------|
| 1 | Chelsea → "I need a standard data environment" |
| 2 | COB |
| 2a | ├── Naming |
| 2b | ├── Networking |
| 2c | ├── Storage |
| 2d | └── Data Platform |
| 3 | → AWS Data Environment |

Her consumer configuration tells COB what she needs for her environment. For example, her inputs include:

\`\`\`
Environment: dev
AWS Region: eu-west-2
Availability Zones:
  - eu-west-2a
  - eu-west-2b
VPC CIDR: <configured CIDR>
NAT Gateway Strategy: <configured strategy>
\`\`\`

She then connects the capabilities together so that the Data Platform capability can use the S3 storage provisioned for her environment.

## What Chelsea Gets

After provisioning, COB gives Chelsea the infrastructure she needs without her having to manually define every underlying AWS resource. The resulting environment includes:

**Networking:**
 
| Component | Detail |
|-----------|--------|
| VPC | |
| ├── Public Subnets | |
| ├── Private Subnets | |
| └── Database Subnets | |
 
**Data pipeline flow:**
 
| Order | Resource |
|-------|----------|
| 1 | S3 Data Bucket |
| 2 | Glue Data Catalog |
| 3 | Glue Table |
| 4 | Athena Workgroup |
 
COB also exposes these outputs to Chelsea:
 
| Output |
|--------|
| `vpc_id` |
| `data_bucket_name` |
| `data_bucket_arn` |
| `glue_database_name` |
| `glue_table_name` |
| `athena_workgroup_name` |
 

These outputs give Chelsea the information she needs to reference the infrastructure from other parts of her data platform.

[Screenshots]

## What This Solves for Chelsea

Before COB, Chelsea would need to spend time designing and provisioning the infrastructure herself or wait for Platform Engineering to do it.

With COB, she provisions faster because the infrastructure capabilities already exist. In short, Chelsea doesn't have to ask:

"How do I build all of this AWS infrastructure?"

She can focus on:

"What infrastructure does my data workload need?"

and let COB handle the standardised implementation.