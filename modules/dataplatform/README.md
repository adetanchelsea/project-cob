# COB Data Platform Module

The Data Platform module provides reusable infrastructure for exposing data stored in Amazon S3 to analytics users. The capability integrates Amazon S3 with:

- AWS Glue Data Catalog
- Amazon Athena

This allows data stored in an S3 bucket to be registered in the Glue Data Catalog and queried through Athena.

---

## Resources

The Data Platform module provisions three related resources:

- AWS Glue Data Catalog database
- AWS Glue Data Catalog table
- Amazon Athena workgroup

These resources provide the cataloguing and query infrastructure required to expose S3 data to analytics users.

---

## Glue Data Catalog Database

The module creates a Glue Data Catalog database using the standard COB resource name. The catalog database provides the namespace used to organise metadata for the data exposed through the platform.

---

## Glue Data Catalog Table

The module creates an external Glue Catalog table representing data stored in the COB S3 bucket. The table points to the S3 bucket supplied through the `s3_bucket_name` variable. Because the table is configured as an external table, the data remains in S3 while Glue maintains the metadata required for analytics services to discover and query it.
The exact table schema and data format can be expanded as the platform's data requirements evolve.

---

## Athena Workgroup

The module creates a dedicated Athena workgroup for analytics queries. The workgroup has workgroup-level configuration enforcement enabled so that the configuration defined by COB is applied to queries executed through the workgroup.

---

## S3 Integration

The Data Platform module does not create the S3 bucket itself. Instead, it receives the S3 bucket name from the Storage capability.

---

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `standard_name` | `string` | — | Standardised name used for Data Platform resources |
| `tags` | `map(string)` | — | Tags applied to supported resources |
| `s3_bucket_name` | `string` | — | Name of the S3 bucket containing the data |

---

## Outputs

The Data Platform module exposes:

| Name | Description |
|---|---|
| `glue_database_name` | Name of the Glue Data Catalog database |
| `glue_table_name` | Name of the Glue Data Catalog table |
| `athena_workgroup_name` | Name of the Athena workgroup |

These outputs allow consuming environments and other platform components to reference the data-platform resources without needing to know how they are implemented internally.

---

## Environment Reuse

The Data Platform module is designed to be reused across COB environments. Dev and Prod consume the same Data Platform module while providing their own environment-specific configuration.

The environment supplies values such as:

- Standardised resource names
- Resource tags
- S3 bucket name

The module defines how the Glue and Athena infrastructure is constructed.

---

## Module Responsibilities

The Data Platform module is responsible for:

- Glue Data Catalog database
- Glue Data Catalog table
- Athena workgroup
- Integration between the Glue table and the supplied S3 data location.

---

## Design Principles

### Reusability

The same Data Platform module can be consumed across Dev and Prod without duplicating the underlying infrastructure implementation.

### Separation of Responsibilities

Data Platform resources are separated from Storage, Networking, IAM, Compute, and Database capabilities.

### Meaningful Abstraction

The module does not simply wrap an individual AWS resource.

It combines the Glue catalog database, Glue table, and Athena workgroup required to expose S3 data to analytics users.

### Configurability

Environment-specific values are supplied through Terraform variables while the module maintains the standard infrastructure pattern.

### Consistent Naming

Resources receive the standardised name supplied by the COB Naming capability.

### Consistent Tagging

Supported resources receive the common tags supplied by the COB Naming capability.

---

## Example Usage

    module "data_platform" {
      source = "../../modules/dataplatform"
      standard_name  = module.naming.standard_name
      tags           = module.naming.common_tags
      s3_bucket_name = module.storage.bucket_name
    }

The consuming environment provides the S3 bucket created by the Storage capability. The Data Platform module then creates the Glue and Athena resources required to expose the data for analytics.