# main public sg
resource "aws_security_group" "public_sg" {
  name        = "public sg"
  vpc_id      = aws_vpc.main.id
  description = "allow http in from internet"

  tags = {
    Name = "allow HTTP in from anywhere"
  }
}
# allowing port 80
resource "aws_security_group_rule" "allow_http" {
  description       = "allow port 80 to ingress the ec2 protocol name HTTP"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.my_local_ip]
  security_group_id = aws_security_group.public_sg.id
}
# allowing port 22
resource "aws_security_group_rule" "allow_ssh" {
  description       = "allow ssh port 22"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_local_ip]
  security_group_id = aws_security_group.public_sg.id
}
# allow all outbounds
resource "aws_security_group_rule" "allow_all_outbound" {
  description       = "allow ingress all"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.cidr_allow_all]
  security_group_id = aws_security_group.public_sg.id
}
# private sg for my rds allowing 3306 and all outbound
resource "aws_security_group" "private_sg" {
  name        = "private sg"
  vpc_id      = aws_vpc.main.id
  description = "allow communication from the public instance to the db via ssh, https,http"

  ingress {
    description = "allow traffic to the rds mysql database"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description = "allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}