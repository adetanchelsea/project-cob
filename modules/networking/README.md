# COB Networking Module

The Networking module provides the standard network foundation for workloads provisioned through COB.

## Purpose

This module creates an isolated AWS VPC with separate subnet tiers for public-facing resources, application workloads, and database services. The module is designed to be reusable across COB environments that is, development and production.

## Capabilities

The module provisions:

- VPC
- Internet Gateway
- Public subnets
- Private subnets
- Database subnets
- Public route table
- Private route tables
- Database route tables
- NAT Gateway infrastructure
- Elastic IPs for NAT Gateways
- Route table associations

## Subnet Tiers

### Public Subnets

Public subnets have a default route to the Internet Gateway. They are intended for resources that require direct internet connectivity.

### Private Subnets

Private subnets are intended for application workloads such as ECS tasks and EC2 instances. They do not receive public IP addresses. Outbound internet access is provided through NAT Gateway infrastructure.

### Database Subnets

Database subnets are intended for managed database services such as Amazon RDS. They do not have a default route to the internet, providing an additional layer of network isolation.

## NAT Gateway Strategy

The module supports two NAT Gateway strategies:

| Strategy | Description |
|---|---|
| `single` | Creates one NAT Gateway shared by private subnets |
| `one_per_az` | Creates one NAT Gateway in each configured Availability Zone |

`single` is appropriate for cost-conscious environments such as development.

`one_per_az` provides improved availability by reducing dependency on a single NAT Gateway and is appropriate where higher availability is required.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `standard_name` | string | — | Standardised name for networking resources |
| `tags` | map(string) | — | Tags applied to networking resources |
| `vpc_cidr` | string | — | CIDR block for the VPC |
| `azs` | list(string) | — | Availability Zones used by the network |
| `nat_gateway_strategy` | string | `single` | NAT strategy: `single` or `one_per_az` |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | ID of the VPC |
| `public_subnet_ids` | IDs of the public subnets |
| `private_subnet_ids` | IDs of the private subnets |
| `database_subnet_ids` | IDs of the database subnets |

## Security Considerations

- The network is divided into three tiers to separate different workload types.
- Private application workloads are not directly exposed to the internet.
- Database subnets do not have a default internet route.
- The NAT Gateway provides outbound connectivity for private workloads without providing unsolicited inbound connectivity.

## Example

```hcl
module "networking" {
  source = "../../modules/networking"

  standard_name        = module.naming.standard_name
  tags                 = module.naming.common_tags
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["eu-west-2a", "eu-west-2b"]
  nat_gateway_strategy = "single"
}