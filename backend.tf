terraform {
  cloud {
    organization = "Org101"

    workspaces {
      name = "terra-tier"
    }
  }
required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.0.1"
    }
  }
}
