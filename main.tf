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
  allocated_storage       = 10
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "aumichome"
  password                = "assignment"
  storage_encrypted       = true
  backup_retention_period = 5
  deletion_protection     = true
  skip_final_snapshot     = true
  parameter_group_name    = aws_db_parameter_group.custom_mysql.name
  vpc_security_group_ids  = [aws_security_group.private_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.sub_group.name
}

resource "aws_db_subnet_group" "sub_group" {
  subnet_ids = [aws_subnet.private_db_sub_1.id, aws_subnet.private_db_sub_2.id]
}
