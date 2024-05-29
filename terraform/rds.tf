resource "aws_db_instance" "mysql_project_instance" {
  allocated_storage    = 10
  max_allocated_storage =  20
  db_name              = "mydb_project"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  username             = "proyecto"
  password             = "proyecto1234"
  parameter_group_name = "mysql_project_instance.mysql8.0.35"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.subnet_rds.name
  multi_az = false
  skip_final_snapshot  = true
  publicly_accessible  = true
  tags = {
    Name = "mysql_project_instance"
  }
}


resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic to RDS instance"
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group"
  }
}

resource "aws_db_subnet_group" "subnet_rds" {
  name       = "subnet_rds"
  subnet_ids = [aws_subnet.subnet_private_vpc_project.id] # Reemplaza con tus subnet
  tags = {
    Name = "subnet_rds"
  }
}