provider "aws" {
  profile = "aevitas"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "taraalan.tfstate"
  }
}

variable "name" {
  default = "taraalan"
}

variable "domain" {
  default = "taraalan.com"
}
