resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "redirect" {
  bucket = "${var.domain}"
  website {
    redirect_all_requests_to = "www.taraalanphotography.com"
  }
}

resource "aws_route53_record" "a" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "${var.domain}"
  alias {
    name = "${aws_s3_bucket.redirect.website_domain}"
    zone_id = "${aws_s3_bucket.redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cname-www" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["www.taraalanphotography.com"]
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
