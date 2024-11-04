output "ec2_public_ip" {
  description = "Public IP address of the MongoDB EC2 instance"
  value       = aws_instance.mongo.public_ip
}

output "ec2_instance_id" {
  description = "ID of the MongoDB EC2 instance"
  value       = aws_instance.mongo.id
}
