provider "aws" {
  profile = "aevitas"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "maplehillhood.tfstate"
  }
}

variable "name" {
  default = "maplehillhood"
}

variable "domain" {
  default = "maplehillhood.com"
}
