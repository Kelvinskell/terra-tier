# Create scaling policy
resource "aws_autoscaling_policy" "asg-policy" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "project-x-asg-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }

  depends_on = [
    aws_autoscaling_group.asg
  ]
}

# Create an AutoScaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "project-x-asg"
  max_size                  = 6
  min_size                  = 2
  desired_capacity          = 4
  health_check_grace_period = 480
  health_check_type         = "ELB"
  force_delete              = false
  termination_policies      = ["ClosestToNextInstanceHour", "Default"]
  launch_template {
    id      = aws_launch_template.project-x-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = flatten([module.vpc.private_subnets[*]])

  # Refresh instances if ASG is updated
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Environment"
    value               = "prod"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes       = [load_balancers, target_group_arns]
    replace_triggered_by = [aws_db_instance.mysql_instance]
  }
  depends_on = [
    aws_efs_file_system.efs,
    aws_db_instance.mysql_instance
  ]
}