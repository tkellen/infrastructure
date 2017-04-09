variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "thewoodlandkitchen"
}

variable "domain" {
  default = "thewoodlandkitchen.com"
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
    key = "thewoodlandkitchen.tfstate"
  }
}