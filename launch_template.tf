resource "aws_launch_template" "foo" {
  name = "foo"

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
    associate_public_ip_address = false
  }

 vpc_security_group_ids = [aws_security_group.Allow_ALB.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "project-x-logic-tier-template"
    }
  }

  user_data = file("./user_data.sh")
}