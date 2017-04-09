resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip" "main" {
  vpc = true
  instance = "${aws_instance.production.id}"
}

resource "aws_route53_record" "a" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "${var.domain}"
  ttl = "1"
  records = ["${aws_eip.main.public_ip}"]
}

resource "aws_route53_record" "cname-nossl" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "nossl"
  ttl = "1"
  records = ["${var.domain}"]
}
