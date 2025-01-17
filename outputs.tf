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
# output "argocd_initial_admin_secret" {
#   value =
# }

# argocd_initial_admin_secret = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
# argocd_server_load_balancer = "a53a6bf4abebe46f79da6179425ca5f4-7d359c1121a50305.elb.eu-west-1.amazonaws.com"
# eks_connect = "aws eks --region eu-west-1 update-kubeconfig --name main-eks-cluster"