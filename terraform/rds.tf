# create a RDS Database Instance
resource "aws_db_instance" "mysql_instance" {
  db_name                     = "newsreadb"
  engine                      = "mysql"
  identifier                  = "database-1"
  allocated_storage           = 20
  max_allocated_storage       = 50
  engine_version              = "8.0.32"
  instance_class              = "db.m5d.xlarge"
  username                    = "project_x_user"
  manage_master_user_password = true
  parameter_group_name        = "default.mysql8.0"
  vpc_security_group_ids      = [aws_security_group.mysql_sg.id]
  allow_major_version_upgrade = true
  skip_final_snapshot         = true
  publicly_accessible         = false
  backup_retention_period     = 14
  db_subnet_group_name        = aws_db_subnet_group.db_group.name

  tags = {
    Name        = "project-x-rds-mysqldb-instance"
    Environment = "prod"
  }
}

# Create db subnet group
resource "aws_db_subnet_group" "db_group" {
  name       = "project-x-rds-subnet-group"
  subnet_ids = flatten([module.vpc.private_subnets])

  tags = {
    Environment = "prod"
  }
}