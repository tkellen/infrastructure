provider "aws" {
  profile = "aevitas"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "mathman.tfstate"
  }
}

variable "name" {
  default = "mathman"
}

variable "domain" {
  default = "mathman.biz"
}
