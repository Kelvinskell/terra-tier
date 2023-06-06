# Create Public subnet for bastion host
resource "aws_subnet" "bastion_sub" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.bastion_cidr
  availability_zone       = var.bastion_host_az
  map_public_ip_on_launch = true

  tags = {
    Name        = "project-x-bastion-host-public-subnet"
    Environment = "prod"
  }
}

# Create route table for bastion_sub
resource "aws_route_table" "bastion_rt" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }

  tags = {
    Name = "project-x-bastion-host-rt"
  }
}

# Create route table association
resource "aws_route_table_association" "rt-a" {
  subnet_id      = aws_subnet.bastion_sub.id
  route_table_id = aws_route_table.bastion_rt.id
}


# Create bastion host
resource "aws_instance" "bastion" {
  ami                    = var.image_id
  instance_type          = var.bastion_instance_type
  key_name               = aws_key_pair.security_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              = aws_subnet.bastion_sub.id
  user_data              = data.template_file.user_data.rendered
  tags = {
    Name        = "project-x-Bastion-Host"
    Environment = "prod"
  }
}

# Use external data source to invoke user data
data "template_file" "user_data" {
  template = file("./bastion_userdata.yaml")
}

# Print Public IP address of bastion host
output "bastion_host_public_ip" {
  value = aws_instance.bastion.public_ip
}
