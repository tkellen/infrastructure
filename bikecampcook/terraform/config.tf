variable "profile" {
  default = "aevitas"
}

variable "name" {
  default = "bikecampcook"
}

variable "domain" {
  default = "bikecampcook.com"
}

# still hosted on linode
variable "public_ip" {
  default = "198.58.97.98"
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
    key = "bikecampcook.tfstate"
  }
}
