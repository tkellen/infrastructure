resource "aws_s3_bucket" "main" {
  bucket = "${var.domain}"
  website {
    index_document = "index.html"
  }
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.domain}",
        "arn:aws:s3:::${var.domain}/*"
      ]
    }
  ]
}
EOF
}

# waiting on
# https://console.aws.amazon.com/support/home?region=us-east-1#/case/?displayId=2138025851&language=en
#resource "aws_s3_bucket" "assets" {
#  bucket = "s3.${var.domain}"
#  policy = "${data.template_file.assets-public-read.rendered}"
#}
#
#data "template_file" "assets-public-read" {
#  template = "${file("${path.module}/../../templates/aws/public-read.tpl")}"
#  vars {
#    bucket = "${var.domain}"
#  }
#}
