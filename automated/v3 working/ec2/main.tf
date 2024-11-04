resource "aws_instance" "vectortask_db" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.mongo_security_group.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt upgrade -y
              
              wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
              echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
              sudo apt update -y
              sudo apt install -y mongodb-org
              sudo systemctl enable mongod
              
              sudo sed -i 's/^  bindIp: 127.0.0.1/  bindIp: 0.0.0.0/' /etc/mongod.conf
              sudo systemctl restart mongod

              mongo <<EOF2
              use admin
              db.createUser({
                user: "${var.admin_user}",
                pwd: "${var.admin_password}",
                roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
              })
              exit
              EOF2
              EOF

  tags = {
    Name = "${var.project_prefix}-mongodb-ec2"
  }
}

resource "aws_instance" "vectortask_jump" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.jump_security_group.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_prefix}-jump-server"
  }
}

resource "aws_security_group" "mongo_security_group" {
  name        = "${var.project_prefix}-mongo-sg"
  description = "Allow SSH and MongoDB access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr_a, var.public_subnet_cidr_b]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr_a, var.public_subnet_cidr_b]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-mongo-sg"
  }
}

resource "aws_security_group" "jump_security_group" {
  name        = "${var.project_prefix}-jump-sg"
  description = "Allow SSH from anywhere to jump server"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-jump-sg"
  }
}

output "instance_id" {
  value = aws_instance.vectortask_db.id
}

output "private_ip" {
  value = aws_instance.vectortask_db.private_ip
}

output "jump_server_id" {
  value = aws_instance.vectortask_jump.id
}

output "jump_server_public_ip" {
  value = aws_instance.vectortask_jump.public_ip
}
