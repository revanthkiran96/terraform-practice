data "aws_vpc" "default" {
    default = true
  
}
resource "aws_subnet" "revanth-sub" {
    vpc_id = data.aws_vpc.default.id
    cidr_block = "172.31.48.0/20"
    availability_zone =  "ap-south-2c"
    tags = {
        Name = "revanth-sub"
    }
}