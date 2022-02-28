
variable "region" {
description = "Enter region"
default = "eu-cental-1"
}

variable "access_key" {
description = "Enter access_key"
}

variable "secret_key" {
description = "Enter secret_key"
}

variable "instance_type" {
description = "Enter instance type"
default = "t2.micro"
}

variable "vpc_cidr" {
description = "Enter vpc_cidr"
default = "10.0.0.0/16"
}