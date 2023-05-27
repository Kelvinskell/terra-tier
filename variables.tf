variable "private_subnets" {
    type = list
    default = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
}

variable "public_subnets" {
    type = list
    default = ["10.0.0.0/20", "10.0.16.0/24", "10.0.32.0/24"]
}