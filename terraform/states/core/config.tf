provider "aws" {
  profile = "aevitas"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "core.tfstate"
  }
}

variable "name" {
  default = "aevitas"
}

variable "domain" {
  default = "aevitas.io"
}
