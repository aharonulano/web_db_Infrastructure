# key foe secure connect to ec2
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = file(var.ec2_key)
}
# ec2 instance
resource "aws_instance" "web_ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.ec2_key.key_name
  associate_public_ip_address = true
  availability_zone           = "${var.aws_region}a"
  security_groups             = [aws_security_group.public_sg.id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 5
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update
              yum install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World" > /var/www/html/index.html
              systemctl restart apache2
              yum install -y nginx
              EOF
  tags = {
    Name = "public EC2"
  }
}
