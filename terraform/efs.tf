# Create Elastic Filesystem for Logic Layer Servers
resource "aws_efs_file_system" "efs" {
  creation_token = "project-x"
  encrypted      = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name        = "project-x-efs",
    Environment = "prod"
  }
}

# Create EFS mount target for az1
resource "aws_efs_mount_target" "mount1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnets[0]
  security_groups = [aws_security_group.Allow_NFS.id]
}

# Create EFS mount target for az2
resource "aws_efs_mount_target" "mount2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnets[1]
  security_groups = [aws_security_group.Allow_NFS.id]
}

# Create EFS mount target for az3
resource "aws_efs_mount_target" "mount3" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnets[2]
  security_groups = [aws_security_group.Allow_NFS.id]
}

# Create EFS Access Point
resource "aws_efs_access_point" "point" {
  file_system_id = aws_efs_file_system.efs.id
}