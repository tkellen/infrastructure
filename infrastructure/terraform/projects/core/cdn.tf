resource "aws_s3_bucket" "cdn" {
  bucket = "${var.name}"
  acl = "public-read"
  policy = "${data.template_file.cdn-public-read.rendered}"
  website {
    index_document = "index.html"
  }
  # allow web fonts to be hosted from anywhere
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

data "template_file" "cdn-public-read" {
  template = "${file("${path.module}/../../templates/aws/public-read.tpl")}"
  vars {
    bucket = "${var.name}"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  aliases = ["cdn.aevitas.io"]
  origin {
    domain_name = "${aws_s3_bucket.cdn.bucket_domain_name}"
    origin_id = "${aws_s3_bucket.cdn.id}"
  }
  default_cache_behavior {
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.cdn.id}"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  # TODO: add letsencrypt ssl cert
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
