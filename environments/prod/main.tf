module "naming" {
  source = "../../modules/naming"

  company     = "beejan"
  team        = "platform"
  project     = "cob"
  environment = var.environment
}

module "networking" {
  source = "../../modules/networking"

  standard_name        = module.naming.standard_name
  tags                 = module.naming.common_tags
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  nat_gateway_strategy = var.nat_gateway_strategy
}

module "iam" {
  source = "../../modules/iam"

  standard_name = module.naming.standard_name
  tags          = module.naming.common_tags
}

module "storage" {
  source = "../../modules/storage"

  standard_name = module.naming.standard_name
  tags          = module.naming.common_tags
}

module "ec2" {
  source = "../../modules/compute/ec2"

  standard_name        = module.naming.standard_name
  tags                 = module.naming.common_tags
  ami_id               = var.ami_id
  subnet_id            = module.networking.private_subnet_ids[0]
  vpc_id               = module.networking.vpc_id
  iam_instance_profile = module.iam.ec2_instance_profile_name
}

module "ecs" {
  source = "../../modules/compute/ecs"

  standard_name      = module.naming.standard_name
  tags               = module.naming.common_tags
  private_subnet_ids = module.networking.private_subnet_ids
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  container_image    = var.container_image
}

module "database" {
  source = "../../modules/database"

  standard_name              = module.naming.standard_name
  tags                       = module.naming.common_tags
  vpc_id                     = module.networking.vpc_id
  database_subnet_ids        = module.networking.database_subnet_ids
  allowed_security_group_ids = [module.ec2.security_group_id]
}

module "data_platform" {
  source = "../../modules/dataplatform"

  standard_name  = module.naming.standard_name
  tags           = module.naming.common_tags
  s3_bucket_name = module.storage.bucket_name
}