resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "redirect-apex" {
  bucket = "${var.domain}"
  website {
    redirect_all_requests_to = "www.bikecampcook.com"
  }
}


resource "aws_s3_bucket" "redirect-www" {
  bucket = "www.${var.domain}"
  website {
    redirect_all_requests_to = "www.bikecampcook.com"
  }
}

resource "aws_route53_record" "a" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "${var.domain}"
  alias {
    name = "${aws_s3_bucket.redirect-apex.website_domain}"
    zone_id = "${aws_s3_bucket.redirect-apex.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "www.${var.domain}"
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
    "20 alt1.aspmx.l.google.com.",
    "20 alt2.aspmx.l.google.com.",
    "30 aspmx2.googlemail.com.",
    "30 aspmx3.googlemail.com.",
    "30 aspmx4.googlemail.com.",
    "30 aspmx5.googlemail.com.",
    "10 aspmx.l.google.com."
  ]
}
