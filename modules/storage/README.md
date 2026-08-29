# COB Storage Module

The Storage module provides a standard S3 bucket for COB-managed data storage.

## Purpose

This module creates an S3 bucket with security and lifecycle controls enabled by default. The module is reusable across COB environments and generates a globally unique bucket name.

## Features

- Globally unique S3 bucket naming
- S3 object versioning
- Server-side encryption
- Public access blocking
- Old object version lifecycle management

## Security

Public access is blocked using all four S3 public access block settings. Objects are encrypted at rest using S3 server-side encryption with AES256.

## Versioning

Versioning is enabled by default and can be controlled through the `versioning_enabled` variable. Versioning helps us recover from accidental object deletion or overwriting.

## Lifecycle Management

Old object versions are automatically expired after the configured number of days. The default retention period is 90 days.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `standard_name` | string | — | Standardised name for the S3 bucket |
| `tags` | map(string) | — | Tags applied to the S3 bucket |
| `versioning_enabled` | bool | `true` | Whether S3 versioning is enabled |
| `lifecycle_expiration_days` | number | `90` | Number of days before old object versions expire |

## Outputs

| Name | Description |
|---|---|
| `bucket_id` | ID of the S3 bucket |
| `bucket_name` | Name of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |

## Example

```hcl
module "storage" {
  source = "../../modules/storage"
  standard_name = module.naming.standard_name
  tags          = module.naming.common_tags
  versioning_enabled         = true
  lifecycle_expiration_days = 90
}