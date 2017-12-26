variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "our-365"
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
    key = "our-365.tfstate"
  }
}
