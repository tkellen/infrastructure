variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "woodlandkitchen"
}

variable "domain" {
  default = "thewoodlandkitchen.com"
}

variable "vpc_cidr_block" {
  default = "10.100.0.0/24"
}

provider "aws" {
  profile = "${var.profile}"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "woodlandkitchen.tfstate"
  }
}

data "aws_availability_zones" "available" {

}

data "aws_ami" "ubuntu" {
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170414"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
