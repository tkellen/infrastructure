resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "a-new" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "new"
  ttl = "1"
  records = ["${var.public_ip}"]
}

resource "aws_route53_record" "a-db" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "db"
  ttl = "1"
  records = ["${var.public_ip}"]
}

resource "aws_route53_record" "cname-s3" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "s3"
  ttl = "1"
  records = ["s3.amazonaws.com"]
}

resource "aws_route53_record" "alias" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "${var.domain}"
  alias {
    name = "${aws_s3_bucket.main.website_domain}"
    zone_id = "${aws_s3_bucket.main.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "redirect-www" {
  bucket = "www.${var.domain}"
  website {
    redirect_all_requests_to = "${var.domain}"
  }
}

resource "aws_route53_record" "alias-www" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "www"
  alias {
    name = "${aws_s3_bucket.redirect-www.website_domain}"
    zone_id = "${aws_s3_bucket.redirect-www.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mx" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "MX"
  name = "${var.domain}"
  ttl = "1"
  records = [
    "1 aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com",
    "20 alt1.aspmx.l.google.com.",
    "20 alt2.aspmx.l.google.com."
  ]
}
