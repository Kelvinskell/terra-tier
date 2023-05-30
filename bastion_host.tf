# Create Public subnet for bastion host
resource "aws_subnet" "bastion_sub" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.48.0/20"
  availability_zone = var.bastion_host_az
  map_public_ip_on_launch = true

  tags = {
    Name = "project-x-bastion-host-public-subnet"
    Environment = "prod"
  }
}


# Create bastion host
resource "aws_instance" "bastion" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name = "${aws_key_pair.bastion_key.key_name}"
  vpc_security_group_ids = [ aws_security_group.bastion-sg.id ]
  subnet_id = aws_subnet.bastion_sub.id
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = "project-x-Bastion-Host"
    Environment = "prod"
  }
}

# Use external data source to invoke user data
data "template_file" "user_data" {
    template = file("./bastion_userdata.yaml")
}

# Create an EC2 key-pair
resource "aws_key_pair" "bastion_key" {
  key_name   = "project-x-bastion-host-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPkg1tT/LMdH6zshshZ1bhCjSLEFmuPwFEK6ufSAU5Tyc41bwoijn7JdfX1shyIE6Lacfy+cej/q+weVTzSJE82JcKOIGQR/dHC+QPv8BS8zoKhKqqoMp4nlX+Gin5Kvjjjru8d9KHyYIVgCL/IdW+abLHqigW0XPcScUbk8uPJRHne5wEjPzzR++B0bcyaVGBTOPDAi2e3lyLWhAk9tAy6S7Xcf567GJyMiksvkyzpST9GQMJP5g607xGJtnPpUOU0Cs6SWh2jik2jNGzvyguIOWVjXgCPkDwm7vhxpjgYRh4GCx54LPJIB7v0rgqrybIAbJqBQlDBpj2jdKY9Z1dv7hq1XmRJmXdZVDngkwOuXpizC9OGPXJ5sKWICrAEAzCl1NX95NcKO4zPdVNhkkggTrU1My02jlMeS1O4ixZTVr1qU6OTk/dHkJ0MPBcopF8HFnUsQgnd8kixizLE2i5KUAd8sdkHg+mMGp4Nmql0ytbtMX0khB5MaVw2p8zDY8= kelvin-tech@kelvintech-IdeaPad-3-15IGL05"
}
 # YOU MUST REPLACE THE VALUE OF THE PUBLIC_KEY ABOVE WITH YOUR OWN GENERATED PUBLIC_KEY
 # YOU MUST USE THE SSH-KEYGEN COMMAND TO GENERATE A PUBLIC AND PRIVATE KEY. 
 # IF YOU DON'T DO THIS, YOU WILL NOT BE ABLE TO HAVE SSH ACCESS TO YOUR INSTANCE