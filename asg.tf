# Create an AutoScaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "project-x-asg"
  max_size                  = 6
  min_size                  = 2
  desired_capacity          = 4
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  launch_template {
    id = aws_launch_template.project-x-template.id
    version = "$LATEST"
  }
  vpc_zone_identifier       = [module.vpc.aws_subnet.private[*]]
}