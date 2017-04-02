provider "aws" {
  profile = "aevitas"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "charfacts.tfstate"
  }
}

variable "name" {
  default = "charfacts"
}

variable "domain" {
  default = "charfacts.com"
}