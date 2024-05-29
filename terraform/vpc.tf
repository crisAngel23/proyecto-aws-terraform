resource "aws_vpc" "vpc_project" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = {
      Name = "vpc_project"
    }
}

# Subred pública
resource "aws_subnet" "subnet_public_vpc_project" {
    vpc_id = aws_vpc.vpc_project.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1c"

    tags = {
      Name = "subnet_public_vpc_project"
    }
}

# Subred privada
resource "aws_subnet" "subnet_private_vpc_project" {
  vpc_id            = aws_vpc.vpc_project.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "subnet_private_vpc_project"
  }
}

# Internet Gateway para la subred pública
resource "aws_internet_gateway" "gw_project" {
    vpc_id = aws_vpc.vpc_project.id

    tags = {
      Name = "gw_project"
    }
}

# Tabla de rutas para la subred pública
resource "aws_route_table" "rt_public" {
    vpc_id = aws_vpc.vpc_project.id

    route{
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw_project.id
    }

    tags ={
      Name= "rt_public"
    }  
}

# Asociación de la tabla de rutas pública con la subred pública
resource "aws_route_table_association" "a_rt_project_subnet_public" {
  subnet_id = aws_subnet.subnet_public_vpc_project.id
  route_table_id = aws_route_table.rt_public.id
}


# Tabla de rutas para la subred privada
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_project.id

  tags = {
    Name = "rt_private"
  }
}

# Asociación de la tabla de rutas privada con la subred privada
resource "aws_route_table_association" "a_rt_project_subnet_private" {
  subnet_id      = aws_subnet.subnet_private_vpc_project.id
  route_table_id = aws_route_table.rt_private.id
}

# Crear un Elastic IP para el NAT Gateway / NO ESTOY SEGURO AUN
resource "aws_eip" "nat_eip" {
  domain = "vpc"
   tags = {
    Name = "eip_nat_gw"
  }
}


# Crear el NAT Gateway en la subred pública
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public_vpc_project.id

  tags = {
    Name = "nat_gw"
  }
}


# Ruta en la tabla de rutas privada para redirigir el tráfico de Internet a través del NAT Gateway
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}