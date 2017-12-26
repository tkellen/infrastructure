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
