resource "aws_security_group" "dentist_database_sg" {
  name        = "dentist-database-sg"
  vpc_id      = local.dentist_vpc_id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dentist-database-sg"
  }
}

resource "aws_db_subnet_group" "dentist_db_subnet_group" {
  name       = "dentist-db-subnet-group"
  subnet_ids = local.dentist_vpc_db_subnets

  tags = {
    Name = "Dentist Database subnet group"
  }
}

resource "aws_db_instance" "dentist_database" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = local.db_username
  password             = local.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  
  db_name               = local.db_name
  apply_immediately     = true
  port                  = 3306
  vpc_security_group_ids = [aws_security_group.dentist_database_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.dentist_db_subnet_group.id
}

# Parameter store --------------------------------------------------------------

resource "aws_ssm_parameter" "dentist_db_name" {
  name  = "/dentist_db/dbName"
  type  = "String"
  value = local.db_password
}

resource "aws_ssm_parameter" "dentist_db_address" {
  name  = "/dentist_db/address"
  type  = "String"
  value = aws_db_instance.dentist_database.address
}

resource "aws_ssm_parameter" "dentist_db_username" {
  name  = "/dentist_db/username"
  type  = "String"
  value = local.db_username
}

resource "aws_ssm_parameter" "dentist_db_password" {
  name  = "/dentist_db/password"
  type  = "SecureString"
  value = local.db_password
}