resource "aws_route53_zone" "devopslink_public_zone" {
  name     = var.domain_mydevops_link
  comment  = "${var.domain_mydevops_link} public zone"
  provider = aws
}

resource "aws_route53_record" "server1_record" {
  zone_id = aws_route53_zone.devopslink_public_zone.zone_id
  name    = "server1.codeaprendiz.tk"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web_ec2.public_ip]
}

output "devopslink_public_zone_id" {
  value = aws_route53_zone.devopslink_public_zone.zone_id
}

output "devopslink_name_servers" {
  value = aws_route53_zone.devopslink_public_zone.name_servers
}




