# resource "aws_route53_zone" "devopslink_public_zone" {
#   name     = var.domain_mydevops_link
#   comment  = "${var.domain_mydevops_link} public zone"
#   provider = aws
# }
#
# resource "aws_route53_record" "server1_record" {
#   zone_id = aws_route53_zone.devopslink_public_zone.zone_id
#   name    = "server1.codeaprendiz.tk"
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.web_ec2.public_ip]
# }
#
# output "devopslink_public_zone_id" {
#   value = aws_route53_zone.devopslink_public_zone.zone_id
# }
#
# resource "aws_vpc_endpoint" "ec2" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.eu-west-1.ec2"
#   vpc_endpoint_type = "Interface"
#
#   security_group_ids = [
#     aws_security_group.public_sg.id,
#   ]
#
#   private_dns_enabled = true
# }
#
# output "devopslink_name_servers" {
#   value = aws_route53_zone.devopslink_public_zone.name_servers
# }
#
#
# output "ec2_endpoint" {
#   value       = aws_vpc_endpoint.ec2.id
#   description = "vpc endpoint endpoint for ec2"
# }
#
# output "dns_entry" {
#   value       = aws_vpc_endpoint.ec2.dns_entry
#   description = "dns a domain name system to entry ec2 via private endpoint via link"
# }
#
#
#
#
