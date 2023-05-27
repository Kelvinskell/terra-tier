# Create locals
locals {
    ingress =[{
        port = 5000
        description = "Flask port"
        protocol = "tcp"
    }
    ]
}

# Security group for application layer
resource "aws_security_group" "Allow_ALB" {
  name = "project-x-logic-tier-sg"
  description        = "Allow only authorized access to logic layer"
  vpc_id   = module.vpc.vpc_id

# Create a dynamic block
  dynamic "ingress" {
    for_each = local.ingress
    content {
    description      = ingress.value.description
    from_port        = ingress.value.port
    to_port          = ingress.value.port
    protocol         = ingress.value.protocol
    cidr_blocks      = [module.vpc.vpc_cidr_block]
    }
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = "prod"
    Name = "project-x-logic-tier-sg"
  }
}