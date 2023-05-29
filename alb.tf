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
  elb                    = aws_lb.alb

  depends_on = [ aws_autoscaling_group.asg ]
}

# Create target group
resource "aws_lb_target_group" "tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# create target group attachment
resource "aws_lb_target_group_attachment" "tg" {
  target_group_arn = aws_lb_target_group.tg
  target_id        = aws_lb.alb.arn
  port             = 80
}