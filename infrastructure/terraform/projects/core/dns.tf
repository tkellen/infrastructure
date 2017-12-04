resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "cname-cdn" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "cdn"
  ttl = "1"
  records = ["${aws_cloudfront_distribution.cdn.domain_name}"]
}

resource "aws_route53_record" "a-log" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "log"
  alias {
    name = "${aws_s3_bucket.log.website_domain}"
    zone_id = "${aws_s3_bucket.log.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mx" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "MX"
  name = "${var.domain}"
  ttl = "1"
  records = [
    "20 alt1.aspmx.l.google.com.",
    "20 alt2.aspmx.l.google.com.",
    "30 aspmx2.googlemail.com.",
    "30 aspmx3.googlemail.com.",
    "30 aspmx4.googlemail.com.",
    "30 aspmx5.googlemail.com.",
    "10 aspmx.l.google.com."
  ]
}

resource "aws_route53_record" "cnams-mailchimp-dkim" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "k1._domainkey"
  ttl = "1"
  records = ["dkim.mcsv.net"]
}

resource "aws_route53_record" "txt-mailchimp-spf" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "${var.domain}"
  ttl = "1"
  records = ["v=spf1 include:servers.mcsv.net ?all"]
}

resource "aws_s3_bucket" "log" {
  bucket = "log.${var.domain}"
  website {
    redirect_all_requests_to = "https://github.com/tkellen/yakb"
  }
}
