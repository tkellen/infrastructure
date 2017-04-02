provider "aws" {
  profile = "aevitas"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "tfstate-store"
    key = "peterhenrikson.tfstate"
  }
}

variable "name" {
  default = "peterhenrikson"
}

variable "domain" {
  default = "peterhenrikson.com"
}

# still hosted on linode
variable "public_ip" {
  default = "198.58.97.98"
}
