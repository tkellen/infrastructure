variable "name" {}
variable "key_name" {}
variable "cidr" {}
variable "ami" {}
variable "etcd_count" {}
variable "etcd_instance_type" {}
variable "controlplane_count" {}
variable "controlplane_instance_type" {}
variable "worker_count" {}
variable "worker_instance_type" {}

locals {
  subnetCidrs = [
    "${cidrsubnet(var.cidr, 8, 0)}",
    "${cidrsubnet(var.cidr, 8, 1)}",
    "${cidrsubnet(var.cidr, 8, 2)}"
  ]
}
