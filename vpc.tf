module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "project-x-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/24", "10.0.32.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway = false
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Terraform = "true"
    Environment = "prod"
  }
}
