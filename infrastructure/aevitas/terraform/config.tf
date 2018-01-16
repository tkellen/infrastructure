variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "aevitas"
}

variable "domain" {
  default = "aevitas.io"
}

provider "aws" {
  profile = "${var.profile}"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "infrastructure-state-store"
    key = "core.tfstate"
  }
}

data "aws_ami" "ubuntu" {
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180109"]
  }
}

module "cluster" {
  source = "./cluster"
  name = "${var.name}"
  key_name = "default"
  cidr = "10.100.0.0/16"
  ami = "${data.aws_ami.ubuntu.id}"
  etcd_count = 3
  etcd_instance_type = "t2.medium"
  controlplane_count = 1
  controlplane_instance_type = "t2.medium"
  worker_count = 2
  worker_instance_type = "t2.medium"
}
