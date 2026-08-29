# COB Naming Module

The Naming module provides a consistent naming and tagging standard for resources provisioned through COB.

## Purpose

COB uses this module to ensure resources across projects and environments follow a consistent naming convention and receive common tags.

## Naming Convention

Resource names are generated using:

`company-team-project-environment`

For example:

`beejan-platform-cob-dev`

Underscores are replaced with hyphens and the resulting name is converted to lowercase.

## Common Tags

The module generates the following tags:

| Tag | Description |
|---|---|
| Team | Team responsible |
| Project | Project identifier |
| Environment | Deployment environment |
| ManagedBy | Identifies COB-managed infrastructure |
| Platform | Identifies the COB platform |

## Inputs

| Name | Description |
|---|---|
| company | Company name |
| team | Team name |
| project | Project name |
| environment  | Deployment environment (`dev` or `prod`) |

## Outputs

| Name | Description |
|---|---|
| standard_name | Standardised resource name |
| common_tags | Common tags applied to COB resources |

## Example

```hcl
module "naming" {
  source = "../../modules/naming"
  company     = "beejan"
  team        = "platform"
  project     = "cob"
  environment = "dev"
}