resource "aws_db_instance" "mysql_project_instance" {
  allocated_storage    = 10
  max_allocated_storage =  20
  identifier          = "mysql-project"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  username             = "proyecto"
  password             = "proyecto1234"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.subnet_rds.name
  multi_az = false
  skip_final_snapshot  = true
  publicly_accessible  = true
  apply_immediately    = true

  tags = {
    Name = "mysql_project_instance"
  }
}


resource "aws_security_group" "rds_sg" {

  vpc_id = 	aws_vpc.vpc_project.id

  name        = "rds_project_sg"
  description = "Allow traffic to RDS instance"
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_web_server_project.id]
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
  subnet_ids = [aws_subnet.subnet_private_vpc_project.id,
    aws_subnet.subnet_private_vpc_project_az1.id
  ] 
  tags = {
    Name = "subnet_rds"
  }
}