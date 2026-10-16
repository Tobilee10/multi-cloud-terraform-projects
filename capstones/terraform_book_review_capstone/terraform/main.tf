locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
  az_count            = var.az_count
  single_nat_gateway  = var.single_nat_gateway
  tags                = local.common_tags
}

module "security" {
  source = "./modules/security"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  ssh_ingress_cidr = var.ssh_ingress_cidr
  web_app_port     = var.web_app_port
  backend_port     = var.backend_port
  mysql_port       = var.mysql_port
  tags             = local.common_tags
}

module "load_balancer" {
  source = "./modules/load-balancer"

  project_name       = var.project_name
  environment        = var.environment
  tags               = local.common_tags
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  app_subnet_ids     = module.network.app_subnet_ids
  public_alb_sg_id   = module.security.public_alb_sg_id
  internal_alb_sg_id = module.security.internal_alb_sg_id
  web_app_port       = var.web_app_port
  backend_port       = var.backend_port
  certificate_arn    = var.certificate_arn

  web_health_check_path     = var.web_health_check_path
  backend_health_check_path = var.backend_health_check_path
}

module "database" {
  source = "./modules/database"

  project_name       = var.project_name
  environment        = var.environment
  tags               = local.common_tags
  vpc_id             = module.network.vpc_id
  db_subnet_ids      = module.network.db_subnet_ids
  db_sg_id           = module.security.db_sg_id
  availability_zones = module.network.availability_zones

  db_instance_class       = var.db_instance_class
  db_name                 = var.db_name
  db_master_username      = var.db_master_username
  mysql_port              = var.mysql_port
  engine_version          = var.engine_version
  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
}
