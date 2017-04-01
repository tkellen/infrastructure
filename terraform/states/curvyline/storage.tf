resource "aws_s3_bucket" "main" {
  bucket = "curvyline.com"
  website {
    index_document = "index.html"
  }
  policy = "${data.template_file.public-read.rendered}"
}

data "template_file" "public-read" {
  template = "${file("${path.module}/../../templates/public-read-policy.tpl")}"
  vars {
    bucket = "curvyline.com"
  }
}
