resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "a-db" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "db"
  ttl = "1"
  records = ["${aws_instance.db.public_ip}"]
}

resource "aws_route53_record" "apex" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "${var.domain}"
  ttl = "1"
  records = ["${aws_instance.www.public_ip}"]
}

resource "aws_route53_record" "cname-www" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["${var.domain}"]
}

resource "aws_route53_record" "cname-shop" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "shop"
  ttl = "1"
  records = ["shops.myshopify.com"]
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
