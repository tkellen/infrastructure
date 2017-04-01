variable "name" {
  default = "board"
}

variable "domain" {
  default = "boardcrewcial.org"
}

variable "vpc_cidr_block" {
  default = "10.100.0.0/16"
}

variable "subnet_cidr_blocks" {
  default = [
    "10.100.0.0/24",
    "10.100.1.0/24",
    "10.100.2.0/24"
  ]
}

data "aws_availability_zones" "available" {

}

data "aws_ami" "ubuntu" {
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20150325"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
