variable "name" { }
variable "existing-policy-arns" {
  type = "list"
  default = []
}
variable "create-policy-names" {
  type = "list"
  default = []
}
variable "create-policy-documents" {
  type = "list"
  default = []
}
