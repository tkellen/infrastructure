resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "a" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "${var.domain}"
  ttl = "1"
  records = ["${var.public_ip}"]
}

resource "aws_route53_record" "a-star" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "*"
  ttl = "1"
  records = ["${var.public_ip}"]
}

resource "aws_route53_record" "cname-email" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "email"
  ttl = "1"
  records = ["mailgun.org"]
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

resource "aws_route53_record" "txt-mailgun-spf" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "${var.domain}"
  ttl = "1"
  records = ["v=spf1 include:mailgun.org ~all"]
}

resource "aws_route53_record" "txt-domainkey" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "mx._domainkey"
  ttl = "1"
  records = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrBqDoGjL2BJe4MemBc7D+Ba4qmu7+WboPjtd6GQjCCuDclHCc26wTZlUnAMIeUD1qPepgWU7Csaii1JG/ghY5NUJyE5lgNLZTvXLPywG/JKD9jidwuVjGwoXTn7bz1KIbuvTB5cq8cmQD5TMWO7oQuNVIYknMB7/8xuQdVi+T+QIDAQAB"]
}
