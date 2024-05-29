resource "aws_instance" "web_server_project" {
    ami = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet_public_vpc_project.id
    key_name = "server-taller-1-key-pair"
    associate_public_ip_address = true

    security_groups = [aws_security_group.sg_web_server_project.id]


     tags = {
      Name = "web_server_project"
    }
  
}

resource "aws_eip" "eip_web_server_project" {
    domain = "vpc"

    instance = aws_instance.web_server_project.id
    depends_on = [ aws_internet_gateway.gw_project ]


    tags = {
      Name="eip_web_server_project"
    }
}



resource "aws_security_group" "sg_web_server_project" {
    vpc_id = 	aws_vpc.vpc_project.id

    name        = "web_server_project_sg"
    description = "allow SSH, HTTP, inbound traffic"


    egress{
        from_port  = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow Outbound traffic"
    }  

    ingress{
        from_port  = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH"
    } 

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = [aws_subnet.subnet_private_vpc_project.cidr_block]
    }

        ingress{
        from_port  = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP"
    } 


    tags = {
        Name="sg_web_server_project"
    }

}