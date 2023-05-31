# create Application Load Balancer
resource "aws_lb" "alb" {
  name               = "project-x-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = flatten([module.vpc.public_subnets[*]])
  enable_deletion_protection = false

  tags = {
    Environment = "prod"
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn                      = aws_lb_target_group.tg.arn

  depends_on = [ aws_lb.alb ]
}

# Create target group
resource "aws_lb_target_group" "tg" {
  name     = "tf-example-lb-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    enabled = true
    healthy_threshold = 2
    interval = 120
    matcher = "200-299"
    path = "/"
    port = 5000
    protocol = "HTTP"
    timeout = 20
    unhealthy_threshold = 4
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.tg.arn
      }
      stickiness {
        enabled  = true
        duration = 120
      }
    }
  }
  tags = {
    Name = "project-x-alb-listener"
    Environment = "prod"
  }
}