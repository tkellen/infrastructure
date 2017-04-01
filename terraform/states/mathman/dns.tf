resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "a" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  type = "A"
  name = "${var.domain}"
  ttl = "1"
  records = [
    "192.30.252.153",
    "192.30.252.154"
  ]
}

resource "aws_route53_record" "cname-www" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["${var.domain}"]
}
