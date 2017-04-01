resource "aws_s3_bucket" "main" {
  bucket = "${var.domain}"
  website {
    index_document = "index.html"
  }
  policy = "${data.template_file.main-public-read.rendered}"
}

data "template_file" "main-public-read" {
  template = "${file("${path.module}/../../templates/public-read-policy.tpl")}"
  vars {
    bucket = "${var.domain}"
  }
}
