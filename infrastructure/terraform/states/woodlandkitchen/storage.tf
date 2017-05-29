resource "aws_s3_bucket" "main" {
  bucket = "${var.name}"
}
