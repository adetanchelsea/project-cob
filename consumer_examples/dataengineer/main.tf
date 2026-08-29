module "naming" {
  source      = "../../modules/naming"
  company     = "beejan"
  team        = var.team
  project     = var.project
  environment = var.environment
}

module "networking" {
  source               = "../../modules/networking"
  standard_name        = module.naming.standard_name
  tags                 = module.naming.common_tags
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  nat_gateway_strategy = var.nat_gateway_strategy
}

module "storage" {
  source        = "../../modules/storage"
  standard_name = module.naming.standard_name
  tags          = module.naming.common_tags
}

module "data_platform" {
  source         = "../../modules/dataplatform"
  standard_name  = module.naming.standard_name
  tags           = module.naming.common_tags
  s3_bucket_name = module.storage.bucket_name
}