variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "mathman"
}

variable "domain" {
  default = "mathman.biz"
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
    key = "mathman.tfstate"
  }
}
