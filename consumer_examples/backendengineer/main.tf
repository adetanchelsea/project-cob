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

module "iam" {
  source                  = "../../modules/iam"
  create_s3_access_policy = true
  create_ecs_roles = true
  standard_name           = module.naming.standard_name
  tags                    = module.naming.common_tags
  s3_bucket_arn           = module.storage.bucket_arn
}

module "ecs" {
  source             = "../../modules/compute/ecs"
  standard_name      = module.naming.standard_name
  tags               = module.naming.common_tags
  private_subnet_ids = module.networking.private_subnet_ids
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  container_image    = var.container_image
  container_port     = var.container_port
  cpu                = var.cpu
  memory             = var.memory
  desired_count      = var.desired_count
}