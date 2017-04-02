variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "taraalanphotography"
}

variable "domain" {
  default = "taraalanphotography.com"
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
    key = "taraalanphotography.tfstate"
  }
}
