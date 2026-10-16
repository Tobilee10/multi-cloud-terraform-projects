resource "aws_db_subnet_group" "db_subnet-group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = var.db_subnet_group_name
  }
}

resource "aws_db_instance" "db_instance" {
    identifier             = var.db_identifier

    engine                 = "mysql"
    engine_version         = var.engine_version

    instance_class        = var.instance_class
    allocated_storage      = var.allocated_storage
    max_allocated_storage = var.max_allocated_storage
    storage_type           = var.storage_type
    storage_encrypted      = true

    db_name               = var.db_name
    username              = var.db_username
    password              = var.db_password
    port                 = var.db_port

    db_subnet_group_name  = aws_db_subnet_group.db_subnet-group.name
    vpc_security_group_ids = var.security_group_ids

    publicly_accessible    = false

    multi_az               = var.multi_az

    backup_retention_period = var.backup_retention_period
    backup_window           = var.backup_window
    maintenance_window = var.maintenance_window

    deletion_protection = var.deletion_protection
    skip_final_snapshot = var.skip_final_snapshot

    auto_minor_version_upgrade = true


    tags = {
        Name = var.db_identifier
    }
}