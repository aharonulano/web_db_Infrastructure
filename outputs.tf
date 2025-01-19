output "public_ec2_instance" {
  value       = aws_instance.web_ec2.public_ip
  description = "The public ip of the EC2 to connect from anywhere to the EC2"
}

output "db_rds_endpoint" {
  value       = aws_db_instance.private_db.endpoint
  description = "DB endpoint to connect from the EC2 instance"
}

