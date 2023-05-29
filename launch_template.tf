resource "aws_launch_template" "project-x-template" {
  name = "project-x-logic-tier-template"

block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 20
    }
}
  ebs_optimized = true
  image_id = var.image_id
  instance_type = var.instance_type

   network_interfaces {
    security_groups = [aws_security_group.Allow_ALB.id]
    associate_public_ip_address = false
    delete_on_termination = true
  }

 user_data = filebase64("./user_data.sh")
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "project-x-logic-tier-template",
      Environment = "prod"
    }
  }
}