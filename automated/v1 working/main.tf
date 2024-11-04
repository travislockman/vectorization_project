provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

module "vectortask_vpc" {
  source               = "./vpc"
  project_prefix       = "vectortask"
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidr_a = "10.0.1.0/24"
  public_subnet_cidr_b = "10.0.3.0/24"
  private_subnet_cidr_a = "10.0.2.0/24"
  private_subnet_cidr_b = "10.0.4.0/24"
}

module "vectortask_ec2" {
  source         = "./ec2"
  vpc_id         = module.vectortask_vpc.vpc_id
  subnet_id      = module.vectortask_vpc.private_subnet_ids[0]  # Deploy EC2 in Private Subnet A
  instance_type  = "t2.micro"
  ami_id         = data.aws_ami.ubuntu.id
  project_prefix = "vectortask"
  key_name       = "vectortask"
  admin_user     = "vectortask"
  admin_password = var.mongo_admin_password
}

output "vpc_id" {
  value = module.vectortask_vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vectortask_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vectortask_vpc.private_subnet_ids
}

output "ec2_instance_id" {
  value = module.vectortask_ec2.instance_id
}

output "ec2_instance_private_ip" {
  value = module.vectortask_ec2.private_ip
}
