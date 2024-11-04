variable "project_prefix" {
  description = "Prefix for naming resources in the project"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for the public subnet in availability zone a"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for the public subnet in availability zone b"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for the private subnet in availability zone a"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for the private subnet in availability zone b"
  type        = string
}
