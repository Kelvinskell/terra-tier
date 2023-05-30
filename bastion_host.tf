# Create bastion host
resource "aws_instance" "bastion" {
  ami           = var.image_id
  instance_type = var.instance_type
  # key_name = "${aws_key_pair.ec2_key.key_name}"
  vpc_security_group_ids = [ aws_security_group.bastion-sg.id ]
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


/*# Create an EC2 key-pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "my-tf-ec2-key"
  public_key = "YOUR-SSH-PUBLIC-KEY"

  depends_on = [
    aws_instance.bastion
  ]
}*/
 # UNCOMMENT THE ABOVE IF YOU WANT TO HAVE SSH aCCESS TO YOUR BASTION HOST. 
 # YOU MUST USE THE SSH-KEYGEN COMMAND TO GENERATE A PUBLIC AND PRIVATE KEY. 
 # REPLACE THE VALUE OF 'PUBLIC_KEY' WITH THE VALUE OF YOUR GENERATED PUBLIC KEY.
 # IF NOT, CONNECT TO YOUR BASTION HOST USING EC2-CONNECT.



