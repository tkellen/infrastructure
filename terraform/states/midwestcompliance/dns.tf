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

resource "aws_route53_record" "a-rdp" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "rdp"
  ttl = "1"
  records = ["${var.office_ip}"]
}

resource "aws_route53_record" "a-mail" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "mail"
  ttl = "1"
  records = ["${var.office_ip}"]
}

resource "aws_route53_record" "a-dds" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "dds"
  ttl = "1"
  records = ["${aws_eip.main.public_ip}"]
}

resource "aws_route53_record" "cname-www" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["${var.domain}"]
}

resource "aws_route53_record" "a-star" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "A"
  name = "*"
  ttl = "1"
  records = ["${aws_eip.main.public_ip}"]
}

resource "aws_route53_record" "cname-blog" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "blog"
  ttl = "1"
  records = ["ghs.google.com"]
}

resource "aws_route53_record" "cname-s3" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "s3"
  ttl = "1"
  records = ["s3.amazonaws.com"]
}

resource "aws_route53_record" "cname-cdn" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "cdn"
  ttl = "1"
  records = ["dj0liqp3podgx.cloudfront.net"]
}

resource "aws_route53_record" "mx" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "MX"
  name = "${var.domain}"
  ttl = "1"
  records = [
    "0 asp.reflexion.net",
    "100 mx-100.reflexion.net",
    "200 mx-110.reflexion.net"
  ]
}

##
# These records validate that we own midwestcompliance.com so that Amazon SES
# will send emails as though they came from our domain. They also ensure that
# DKIM is configured properly so that the emails sent will not wind up in spam
# folders for the recipients.
#
resource "aws_route53_record" "ses-validate-1" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "_amazonses"
  ttl = "1"
  records = ["pU89IWu8L6Tbct/xj0gSPALcPzIypa8E1105/xlM0Mw="]
}

resource "aws_route53_record" "ses-validate-2" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "meradfrx2cnxqawgusteuhmacrhtdrat._domainkey"
  ttl = "1"
  records = ["meradfrx2cnxqawgusteuhmacrhtdrat.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses-validate-3" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "fejsminveyu7wvqdbkpitihg3hn4mhz2._domainkey"
  ttl = "1"
  records = ["fejsminveyu7wvqdbkpitihg3hn4mhz2.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses-validate-4" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "5qpxqizafufc5zjohdi4vc7rz3q2fbx6._domainkey"
  ttl = "1"
  records = ["5qpxqizafufc5zjohdi4vc7rz3q2fbx6.dkim.amazonses.com"]
}

# TODO
# add cdn.midwestcompliance.com
