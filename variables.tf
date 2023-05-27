variable "private_subnets" {
    type = list
    default = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
}

variable "public_subnets" {
    type = list
    default = ["10.0.0.0/20", "10.0.16.0/24", "10.0.32.0/24"]
}

variable "image_id" {
    type = string
    default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type = string
  default = "t3.xlarge"
}