resource "aws_vpc" "revanth_vpc" {
    cidr_block = "10.0.0.0/16"
  
}
resource "aws_subnet" "revanth-sub-1" {
    vpc_id = aws_vpc.revanth_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-2c"
    tags = {
      "Name" = "revanth-sub-1"
    }
  
}

output "revanth_vpc_id" {
    value = aws_vpc.revanth_vpc.id
  
}

output "revanth-sub-id" {
    value = aws_subnet.revanth-sub-1.id
  
}