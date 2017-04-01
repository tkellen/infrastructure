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
