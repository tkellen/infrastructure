provider "aws" {
  profile = "aevitas"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "sleekcode.tfstate"
  }
}

variable "name" {
  default = "sleekcode"
}

variable "domain" {
  default = "sleekcode.net"
}

variable "alias_domains" {
  default = [
    "sleekcode.com"
  ]
}

# still hosted on linode
variable "public_ip" {
  default = "198.58.97.98"
}
