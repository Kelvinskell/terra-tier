# Security group for application layer
resource "aws_security_group" "allow_tls" {
  name = "project-x-logic-tier-sg"
  description        = "Allow only authorized access to logic layer"
  vpc_id   = module.vpc.main.vpc_id

# Create locals
locals {
    ingress = [{
        port = 443
        description = "Port 443"
        protocol = "tcp"
    },
    {
        port = 80
        description = "Port 80"
        protocol = "tcp"
    }
    ]
}

# Create a dynamic block
  dynamic "ingress" {
    for_each = local.ingress
    content {
    description      = ingress.value.description
    from_port        = ingress.value.port
    to_port          = ingress.value.port
    protocol         = ingress.value.protocol
    cidr_blocks      = [data.aws_vpc.main.cidr_block]
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
  }
}