variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "taraalan"
}

variable "domain" {
  default = "taraalan.com"
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
    key = "taraalan.tfstate"
  }
}
