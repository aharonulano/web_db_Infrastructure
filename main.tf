resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false #true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_db_sub_1" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "private-db-subnet_1"
  }
}

resource "aws_subnet" "private_db_sub_2" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}c"
  tags = {
    Name = "private-db-subnet_2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-for-main-vpc"
  }
}

resource "aws_nat_gateway" "mor_secure" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.for_ngw.id

  tags = {
    Name = "gw nat"
  }

  depends_on = [aws_eip.for_ngw]
}

resource "aws_eip" "for_ngw" {
  domain = "vpc"

  tags = {
    Name = "static-ip-for-nat"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "public-rt"
    Description = "routing traffic from public subnet to igw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mor_secure.id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route_table_association" "private_rt_association_1" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_db_sub_1.id
}

resource "aws_route_table_association" "private_rt_association_2" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_db_sub_2.id
}

resource "aws_security_group" "public_sg" {
  name        = "public sg"
  vpc_id      = aws_vpc.main.id
  description = "allow http in from internet"

  tags = {
    Name = "allow HTTP in from anywhere"
  }
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.my_local_ip]
  security_group_id = aws_security_group.public_sg.id
}


resource "aws_security_group_rule" "allow_http_via_web" {
  type              = "ingress"
  from_port         = 7104
  to_port           = 7104
  protocol          = "tcp"
  cidr_blocks       = [var.my_local_ip]
  security_group_id = aws_security_group.public_sg.id
}

# resource "aws_security_group_rule" "allow_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.public_sg.id
# }

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_local_ip]
  security_group_id = aws_security_group.public_sg.id
}

# resource "aws_security_group_rule" "allow_db_ingress" {
#   type              = "ingress"
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.public_sg.id
# }

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.cidr_allow_all]
  security_group_id = aws_security_group.public_sg.id
}

# resource "aws_network_acl" "" {
#   vpc_id = aws_vpc.main.id
# }

resource "aws_security_group" "private_sg" {
  name        = "private sg"
  vpc_id      = aws_vpc.main.id
  description = "allow communication from the public instance to the db via ssh, https,http"

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [aws_vpc.main.cidr_block] # maybe i'll need to add the public instance private/public ip
  #   description = "allow ssh to db"
  # }

  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = [aws_vpc.main.cidr_block]
  #   description = "allow https"
  # }

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = [aws_vpc.main.cidr_block]
  #   description = "allow http"
  # }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  # egress {
  #   description = "allow all outbound"
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = var.ec2_key
}

# resource "aws_elb" "" {}
resource "aws_instance" "web_ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.ec2_key.key_name
  associate_public_ip_address = true
  availability_zone           = "${var.aws_region}a"
  security_groups             = [aws_security_group.public_sg.id]
  # private_dns_name_options {
  #   enable_resource_name_dns_a_record = true
  #
  # }
  # network_interface {
  #   device_index         = 0
  #   network_interface_id = ""
  # }
    metadata_options {
     http_tokens = "required"
     }

    root_block_device {
      encrypted = true
  }


    ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
    encrypted = true
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

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-1.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.public_sg.id,
  ]

  private_dns_enabled = true
}
resource "aws_db_parameter_group" "custom_mysql" {
  name        = "custom-mysql8-parameter-group"
  family      = "mysql8.0"
  description = "Custom parameter group for MySQL 8.0"

  # Example of a custom parameter
  parameter {
    name  = "max_connections"
    value = "200"
  }
}


resource "aws_db_instance" "private_db" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "aumichome"
  password             = "assignment"
  parameter_group_name = aws_db_parameter_group.custom_mysql.name
  storage_encrypted  = true
   backup_retention_period = 5
  deletion_protection = true
  # multi_az               = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.sub_group.name
}

resource "aws_db_subnet_group" "sub_group" {
  subnet_ids = [aws_subnet.private_db_sub_1.id, aws_subnet.private_db_sub_2.id]
}
#
# resource "aws_network_acl" "main" {
#   vpc_id = aws_vpc.main.id
#
#   egress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 443
#     to_port    = 443
#   }
#
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }
#
#
#   tags = {
#     Name = "main"
#   }
# }
#
# resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.public_sg.id]
#   subnets            = [aws_subnet.public.id, aws_subnet.private.id]
#
#   # enable_deletion_protection = true
#
#   # access_logs {
#   #   bucket  = aws_s3_bucket
#   #   prefix  = "test-lb"
#   #   enabled = true
#   # }
#
#   tags = {
#     Environment = "production"
#   }
# }

# Create a new load balancer
# resource "aws_elb" "bar" {
#   name               = "foobar-terraform-elb"
#   availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
#   subnets            = [aws_subnet.public.id]
#
#   # access_logs {
#   #   bucket        = "foo"
#   #   bucket_prefix = "bar"
#   #   interval      = 60
#   # }
#
#   listener {
#     instance_port     = 8000
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
#
#   # listener {
#   #   instance_port      = 8000
#   #   instance_protocol  = "http"
#   #   lb_port            = 443
#   #   lb_protocol        = "https"
#   #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
#   # }
#
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 30
#   }
#
#   instances                   = [aws_instance.web_ec2.id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400
#
#   tags = {
#     Name = "foobar-terraform-elb"
#   }
# }


# resource "aws_rds_cluster" "rds_c" {
#   engine = ""
# }
#-----------------
# second step eks or minikube
# an hello world app to expose

