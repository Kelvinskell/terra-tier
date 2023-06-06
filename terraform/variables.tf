variable "private_subnets" {
  type    = list(any)
  default = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
}

variable "public_subnets" {
  type    = list(any)
  default = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "image_id" {
  type    = string
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "bastion_host_az" {
  type    = string
  default = "us-east-1a"
}

variable "bastion_cidr" {
  type        = string
  description = "CIDR block for the bastion host's public subnet"
  default     = "10.0.48.0/20"
  sensitive   = false
}

variable "bastion_instance_type" {
  type        = string
  description = "Image id of the bastion host"
  default     = "t2.micro"
}