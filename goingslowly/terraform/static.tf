/*
resource "aws_route53_record" "static" {
  zone_id = aws_route53_zone.main.id
  type = "A"
  name = "adrift"
  alias {
    name = aws_s3_bucket.static.website_domain
    zone_id = aws_s3_bucket.static.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "static" {
  bucket = "adrift.${var.domain}"
  website {
    index_document = "index.html"
  }
  acl = "public-read"
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
        "arn:aws:s3:::adrift.${var.domain}",
        "arn:aws:s3:::adrift.${var.domain}/*"
      ]
    }
  ]
}
EOF
}
*/
