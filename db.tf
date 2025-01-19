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
