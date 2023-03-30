variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    type = string
    default = "10.0.3.0/24"
}

variable "private_subnet_1_cidr" {
    default = "10.0.1.0/24"
}

variable "private_subnet_2_cidr" {
   default =  "10.0.2.0/24"
}

variable "availability_zone_1" {
    default = "us-west-2a"
}

variable "availability_zone_2" {
    default = "us-west-2b"
}

variable "region"{
    type = string
    default = "us-west-2"
}