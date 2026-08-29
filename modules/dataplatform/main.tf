resource "aws_glue_catalog_database" "data_catalog" {
  name = "${var.standard_name}-catalog"
}

resource "aws_glue_catalog_table" "s3_data" {
  name          = "${var.standard_name}-data"
  database_name = aws_glue_catalog_database.data_catalog.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${var.s3_bucket_name}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    }
  }
}

resource "aws_athena_workgroup" "analytics" {
  name = "${var.standard_name}-athena"

  configuration {
    enforce_workgroup_configuration = true
  }

  tags = var.tags
}
