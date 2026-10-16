
module "networking" {
    source = "./modules/networking"

    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_db_subnetA_cidr = var.private_db_subnetA_cidr
    private_db_subnetB_cidr = var.private_db_subnetB_cidr
    availability_zones = var.availability_zones
}


module "compute" {
    source = "./modules/compute"

    ami_id = var.ami_id
    instance_type = var.instance_type
    public_subnet_id = module.networking.public_subnet_id
    security_group_id = module.networking.security_group_id["web"]
    public_key_path = var.public_key_path
    key_name = var.key_name
    
    #Pass outputs from the database module directly into EC2 module
    db_address  = module.database.db_address
    db_name     = module.database.db_name
    db_username = module.database.db_username
    db_password = var.db_password


  # Implicit dependency ensures DB is created before EC2 user_data renders
    depends_on  = [module.database]
}

module "database" {
    source = "./modules/database"

    db_subnet_group_name = var.db_subnet_group_name
    private_db_subnet_ids = [ module.networking.private_db_subnetA_id,
    module.networking.private_db_subnetB_id ]

    db_identifier = var.db_identifier
    security_group_ids = [module.networking.security_group_id["db"]]
    engine_version = var.engine_version
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    max_allocated_storage = var.max_allocated_storage
    storage_type = var.storage_type
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_port = var.db_port
    multi_az = var.multi_az
    backup_retention_period = var.backup_retention_period
    backup_window = var.backup_window
    maintenance_window = var.maintenance_window
    deletion_protection = var.deletion_protection
    skip_final_snapshot = var.skip_final_snapshot
}