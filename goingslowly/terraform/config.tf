variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "goingslowly"
}

variable "domain" {
  default = "goingslowly.com"
}

variable "alias_domains" {
  default = [
    "goingslowly.net"
  ]
}

# still hosted on linode
variable "public_ip" {
  default = "45.33.68.150"
}

provider "aws" {
  profile = var.profile
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "aevitas"
    region = "us-east-1"
    bucket = "infrastructure-state-store"
    key = "goingslowly.tfstate"
  }
}
