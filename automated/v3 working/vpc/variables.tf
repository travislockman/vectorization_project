variable "region" {
  description = "AWS region for availability zones"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for the second private subnet"
  type        = string
}
