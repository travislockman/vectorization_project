variable "region" {
  description = "AWS Region to deploy resources"
  default     = "us-east-1"
}

variable "key_pair_name" {
  description = "Main Key Pair"
  default     = "ANTAEUS MAIN KEY PAIR"  # Replace with your actual key pair name
}

variable "public_subnet_id" {
  description = "The ID of the public subnet where the instance will be deployed"
  default     = "subnet-03abeeebaac7a5397"  # Public subnet from JSON
}

variable "security_group_id" {
  description = "The ID of the security group that allows SSH and MongoDB access"
  default     = "sg-08321e3c3a8c7721b"  # Security group with public access
}
