# create Application Load Balancer
resource "aws_lb" "alb" {
  name               = "project-x-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg]
  subnets            = [for subnet in module.vpc.public_subnets : subnet.id]

  enable_deletion_protection = true

  tags = {
    Environment = "prod"
  }
}