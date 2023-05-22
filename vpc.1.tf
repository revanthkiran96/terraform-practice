resource "aws_vpc" "main" { #this name belongs to only terraform reference

    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "automated-vpc" #this name belongs to AWS
    }
}

resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    #availability_zone ="us-east-1a"
    
    
    
    tags = {
      Name = "public-subnet-automatedvpc"
    }
  
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"

    tags = {
        Name = "private-subnet-automtedvpc"
    }
  
}

resource "aws_internet_gateway" "automated-igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "automated-igw"
    }
  
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.automated-igw.id
    }

    tags = {
      Name = "public-rt"
    }
  
}

resource "aws_eip" "auto-eip" {
    tags = {
      Name = "auto-eip"
    }
  
}

resource "aws_nat_gateway" "auto-nat" {
    allocation_id = aws_eip.auto-eip.id
    subnet_id = aws_subnet.main.id

    tags = {
      Name = "auto-nat"
    }

    depends_on = [ aws_internet_gateway.automated-igw ]
  
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.auto-nat.id
    }

    tags = {
      Name = "private-rt"
    }
  
}

resource "aws_route_table_association" "public-subnet" {
    subnet_id = aws_subnet.main.id
    route_table_id = aws_route_table.public-rt.id
  
}

resource "aws_route_table_association" "private-subnet" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private-rt.id
  
}
