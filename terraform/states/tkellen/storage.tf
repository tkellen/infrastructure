resource "aws_s3_bucket" "main" {
  bucket = "${var.domain}"
  website {
    index_document = "index.html"
  }
  policy = "${data.template_file.main-public-read.rendered}"
}

data "template_file" "main-public-read" {
  template = "${file("${path.module}/../../templates/aws/public-read.tpl")}"
  vars {
    bucket = "${var.domain}"
  }
}
