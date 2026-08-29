# COB Database Module

The Database module provides a reusable capability for provisioning a managed relational database for COB workloads using Amazon RDS. The module combines the database instance with the networking and security resources required to place and control access to the database.

---

## Resources

The Database module provisions three related resources:

- RDS DB subnet group
- Database security group
- RDS database instance

These resources work together to provide a reusable managed database capability rather than exposing the RDS instance as an isolated resource.

---

## RDS DB Subnet Group

The module creates a dedicated DB subnet group using the database subnet IDs supplied by the Networking module. The database is therefore placed within the dedicated database subnets created for the environment. The module does not create the VPC or subnets itself.

---

## Database Security Group

The module creates a security group specifically for the database. Database access is controlled through security-group IDs supplied through the `allowed_security_group_ids` variable. This allows access to be granted to specific workloads without requiring broad CIDR-based access to the database. The database security group allows traffic on the configured database port from the approved security groups.

---

## RDS Instance

The module provisions a managed RDS database instance. The database engine, engine version, instance class, storage allocation, port, and Multi-AZ configuration can be configured through Terraform variables. The current default database engine is PostgreSQL. The RDS instance uses the DB subnet group and database security group created by the module.
The master user password is managed through AWS Secrets Manager using the RDS-managed password feature.

---

## Security

The Database module is designed to support secure-by-default database infrastructure.

Current security measures include:

- Database instances are placed in dedicated database subnets.
- Database access is controlled through security groups.
- Access is granted using approved security-group IDs.
- The database is not exposed through broad CIDR-based ingress rules.
- Master user credentials are managed by AWS rather than being stored directly in Terraform configuration.
- Resource names and tags are provided through the COB Naming capability.

---

## Networking

The Database module consumes networking resources created by the Networking capability. The environment provides:

- VPC ID
- Database subnet IDs

The Database module then uses these values to create the DB subnet group and database security group. This keeps ownership of the network foundation within the Networking capability.

---

## IAM

The Database module does not create IAM roles or policies. IAM responsibilities remain within the COB IAM capability. The RDS instance uses AWS-managed mechanisms for handling the master user credentials.

---

## Configuration

The module supports configuration for:

- Standardised resource naming
- Resource tags
- VPC placement
- Database subnets
- Allowed security groups
- Database engine
- Database engine version
- Instance class
- Allocated storage
- Database port
- Multi-AZ deployment

---

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `standard_name` | `string` | — | Standardised name for database resources |
| `tags` | `map(string)` | — | Tags applied to database resources |
| `vpc_id` | `string` | — | VPC where the database security group is created |
| `database_subnet_ids` | `list(string)` | — | Database subnets used by the RDS instance |
| `allowed_security_group_ids` | `list(string)` | — | Security groups allowed to access the database |
| `engine` | `string` | `postgres` | RDS database engine |
| `engine_version` | `string` | `16` | RDS database engine version |
| `instance_class` | `string` | `db.t3.micro` | RDS instance class |
| `allocated_storage` | `number` | `20` | Allocated database storage in GB |
| `port` | `number` | `5432` | Database port |
| `multi_az` | `bool` | `false` | Whether the RDS instance uses Multi-AZ deployment |

---

## Outputs

The Database module exposes:

| Name | Description |
|---|---|
| `db_instance_id` | ID of the RDS database instance |
| `db_endpoint` | Endpoint of the RDS database |
| `security_group_id` | ID of the database security group |

These outputs allow other parts of the platform or consuming environments to reference the database without needing to know how the database resources are implemented internally.

---

## Environment Reuse

The Database module is reusable across COB environments. Dev and Prod consume the same Database module while supplying their own environment-specific configuration. 

The environment determines values such as:

- Database subnet IDs
- Allowed security groups
- Instance configuration
- Multi-AZ configuration
- Standardised resource names
- Resource tags

The module defines how the database infrastructure is constructed.

---

## Module Responsibilities

The Database module is responsible for the managed relational database capability.

It is responsible for:

- RDS database instance
- Database subnet group
- Database security group

---

## Design Principles

### Reusability

The same Database module can be consumed across Dev and Prod without duplicating the underlying infrastructure implementation.

### Separation of Responsibilities

Database resources are separated from Networking, IAM, Compute, Storage, and Data Platform resources.

### Secure Access

Database access is controlled through security-group relationships rather than broad network access.

### Secure Credentials

The RDS master user password is managed by AWS rather than being provided directly through Terraform variables.

### Configurability

Environment-specific database settings are exposed through Terraform variables while the module maintains the standard infrastructure pattern.

### Consistent Naming and Tagging

Database resources receive the standardised name and common tags supplied by the COB Naming capability.

---

## Example Usage

    module "database" {
      source = "../../modules/database"

      standard_name              = module.naming.standard_name
      tags                       = module.naming.common_tags
      vpc_id                     = module.networking.vpc_id
      database_subnet_ids        = module.networking.database_subnet_ids
      allowed_security_group_ids = [module.ec2.security_group_id]
    }