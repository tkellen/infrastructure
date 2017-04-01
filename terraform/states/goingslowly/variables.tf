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
  default = "198.58.97.98"
}
