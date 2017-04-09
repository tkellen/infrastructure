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

resource "aws_route53_record" "cname-cdn" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "cdn"
  ttl = "1"
  records = ["d1grml7t1u9jas.cloudfront.net"]
}

resource "aws_route53_record" "cname-img0" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "img0"
  ttl = "1"
  records = ["d1grml7t1u9jas.cloudfront.net"]
}

resource "aws_route53_record" "cname-img1" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "img1"
  ttl = "1"
  records = ["d1grml7t1u9jas.cloudfront.net"]
}

resource "aws_route53_record" "cname-s3" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "s3"
  ttl = "1"
  records = ["s3.${var.domain}.s3-website-us-east-1.amazonaws.com"]
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
  name = "mailo._domainkey"
  ttl = "1"
  records = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDVbqq6h5bh2a1WPEGh5o26jJEh5G1GnGE1xEUEL+P9WS2MnOKU40OEnQW6j9pUY2n1ccZvllSEWBlYKWTDPEYOPFphCLvTqUiVy8JIY0cVF+bCsX06zEp6ewBQ36MjRNs9yUUl0PcB/vVS2THhPbTo5+Y0kDkTtekMAWbR0taK7wIDAQAB"]
}

##
# Provide basic redirection for alias domains
# e.g. alias.com and www.alias.com will go to canonical.
#
resource "aws_route53_zone" "aliases" {
  count = "${length(var.alias_domains)}"
  name = "${element(var.alias_domains, count.index)}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "aliases-apex" {
  count = "${length(var.alias_domains)}"
  zone_id = "${element(aws_route53_zone.aliases.*.id, count.index)}"
  type = "A"
  name = "${element(var.alias_domains, count.index)}"
  ttl = "1"
  records = ["${var.public_ip}"]
}

resource "aws_route53_record" "aliases-www" {
  count = "${length(var.alias_domains)}"
  zone_id = "${element(aws_route53_zone.aliases.*.id, count.index)}"
  type = "A"
  name = "www"
  ttl = "1"
  records = ["${var.public_ip}"]
}
