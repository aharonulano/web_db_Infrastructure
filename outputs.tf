output "public_ec2_instance" {
  value       = aws_instance.web_ec2.public_ip
  description = "The public ip of the EC2 to connect from anywhere to the EC2"
}

output "db_rds_endpoint" {
  value       = aws_db_instance.private_db.endpoint
  description = "DB endpoint to connect from the EC2 instance"
}

output "ec2_endpoint" {
  value       = aws_vpc_endpoint.ec2.id
  description = "vpc endpoint endpoint for ec2"
}

output "dns_entry" {
  value       = aws_vpc_endpoint.ec2.dns_entry
  description = "dns a domain name system to entry ec2 via private endpoint via link"
}
