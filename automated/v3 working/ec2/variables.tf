variable "vpc_id" {
  description = "ID of the VPC where the instances are deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet for the jump server"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet for the MongoDB instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "vectortask"
}

variable "project_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "vectortask"
}

variable "admin_user" {
  description = "MongoDB admin username"
  type        = string
  default     = "vectortask"
}

variable "admin_password" {
  description = "MongoDB admin password"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for the second public subnet"
  type        = string
}
