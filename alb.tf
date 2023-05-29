# create Application Load Balancer
resource "aws_lb" "alb" {
  name               = "project-x-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = flatten([module.vpc.public_subnets[*]])

  enable_deletion_protection = true

  tags = {
    Environment = "prod"
  }
}