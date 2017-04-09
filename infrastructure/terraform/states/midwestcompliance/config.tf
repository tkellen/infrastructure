variable "profile" {
  default = "aevitas"
}

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


provider "aws" {
  profile = "${var.profile}"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "midwestcompliance.tfstate"
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
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20150325"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}