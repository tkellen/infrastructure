variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "bikecampcook"
}

variable "domain" {
  default = "bikecampcook.com"
}

variable "vpc_cidr_block" {
  default = "10.100.0.0/24"
}

# still hosted on linode
variable "public_ip" {
  default = "198.58.97.98"
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
    key = "bikecampcook.tfstate"
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "shared.tfstate"
  }
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
