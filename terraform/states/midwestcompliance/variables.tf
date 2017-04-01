variable "name" {
  default = "midwestcompliance"
}

variable "domain" {
  default = "midwestcompliance.com"
}

variable "vpc_cidr_block" {
  default = "10.100.0.0/24"
}

variable "office_ip" {
  default = "24.181.153.138"
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
