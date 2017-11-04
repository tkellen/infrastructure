resource "aws_s3_bucket" "log" {
  bucket = "log.${var.domain}"
  acl = "public-read"
  policy = "${data.template_file.log-public-read.rendered}"
  website {
    index_document = "log.txt"
  }
}

data "template_file" "log-public-read" {
  template = "${file("${path.module}/../../templates/aws/public-read.tpl")}"
  vars {
    bucket = "log.${var.domain}"
  }
}
