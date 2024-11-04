resource "aws_instance" "vectortask_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  associate_public_ip_address = false  # Prevent Public IP assignment
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
              sudo systemctl start mongod
              
              mongo <<EOF2
              use admin
              db.createUser({
                user: "${var.admin_user}",
                pwd: "${var.admin_password}",
                roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
              })
              use vector_db
              db.createCollection("documents")
              db.documents.insertOne({ text: "sample text", vector: [1, 0, 0] })
              exit
              EOF2

              sudo sed -i '/#security:/a security:\\n  authorization: enabled' /etc/mongod.conf
              sudo systemctl restart mongod
              EOF

  tags = {
    Name = "${var.project_prefix}-mongodb-ec2"
  }
}

resource "aws_security_group" "mongo_security_group" {
  name        = "${var.project_prefix}-mongo-sg"
  description = "Allow SSH and MongoDB access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
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

output "instance_id" {
  value = aws_instance.vectortask_ec2.id
}

output "private_ip" {
  value = aws_instance.vectortask_ec2.private_ip
}
