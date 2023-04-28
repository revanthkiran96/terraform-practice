resource "aws_vpc" "main" { #this name is belongs to terraform only
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
      Name = "automated_vpc" #this name is belongs to aws
}
}
resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "public_subnet_automated_vpc"
    }
  
}
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"

    tags = {
      Name = "private_subnet_automated_vpc"
    }
  
}
resource "aws_internet_gateway" "automated_igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name  = "automated_igw"
    }
  
}
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.automated_igw.id
    }
    tags = {
      Name  = "public_rt"
    }
  
}
resource "aws_eip" "auto_elp" {
  
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.auto_elp.id
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
 # depends_on = [aws_internet_gateway.example]
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.example.id

    }

    tags = {
      Name = "private_rt"
    }
  
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
