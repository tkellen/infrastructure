variable "name" {
  default = "truckwriters"
}

variable "vpc_cidr_block" {
  default = "10.100.0.0/24"
}

data "aws_availability_zones" "available" {

}

data "aws_ami" "ubuntu" {
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170221"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
