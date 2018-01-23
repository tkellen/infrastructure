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

resource "aws_route53_record" "mail" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "MX"
  name = "${var.domain}"
  ttl = "1"
  records = [
    "0 midwestcompliance-com.mail.protection.outlook.com"
  ]
}

resource "aws_route53_record" "mail-validation" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "${var.domain}"
  ttl = "1"
  records = ["MS=ms72874370"]
}

resource "aws_route53_record" "mail-autodiscover" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "autodiscover"
  ttl = "1"
  records = ["autodiscover.outlook.com"]
}

resource "aws_route53_record" "mail-sip" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "sip"
  ttl = "1"
  records = ["sipdir.online.lync.com"]
}

resource "aws_route53_record" "mail-lyncdiscover" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "lyncdiscover"
  ttl = "1"
  records = ["webdir.online.lync.com"]
}

resource "aws_route53_record" "mail-enterpriseregistration" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "enterpriseregistration"
  ttl = "1"
  records = ["enterpriseregistration.windows.net"]
}

resource "aws_route53_record" "mail-enterpriseenrollment" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "enterpriseenrollment"
  ttl = "1"
  records = ["enterpriseenrollment.manage.microsoft.com"]
}

resource "aws_route53_record" "mail-spf" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "${var.domain}"
  ttl = "1"
  records = ["v=spf1 include:spf.protection.outlook.com -all"]
}

resource "aws_route53_record" "mail-sip-tls" {
  zone_id = "${aws_route53_zone.main.id}"
  name = "_sip._tls"
  type = "SRV"
  ttl = "1"
  records = [ "100 1 443 sipdir.online.lync.com" ]
}

resource "aws_route53_record" "mail-sip-federation-tcp" {
  zone_id = "${aws_route53_zone.main.id}"
  name = "_sipfederationtls._tcp"
  type = "SRV"
  ttl = "1"
  records = [ "100 1 5061 sipfed.online.lync.com" ]
}

##
# These records validate that we own midwestcompliance.com so that Amazon SES
# will send emails as though they came from our domain. They also ensure that
# DKIM is configured properly so that the emails sent will not wind up in spam
# folders for the recipients.
#
resource "aws_route53_record" "mail-ses-validate-1" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "_amazonses"
  ttl = "1"
  records = ["pU89IWu8L6Tbct/xj0gSPALcPzIypa8E1105/xlM0Mw="]
}

resource "aws_route53_record" "mail-ses-validate-2" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "meradfrx2cnxqawgusteuhmacrhtdrat._domainkey"
  ttl = "1"
  records = ["meradfrx2cnxqawgusteuhmacrhtdrat.dkim.amazonses.com"]
}

resource "aws_route53_record" "mail-ses-validate-3" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "fejsminveyu7wvqdbkpitihg3hn4mhz2._domainkey"
  ttl = "1"
  records = ["fejsminveyu7wvqdbkpitihg3hn4mhz2.dkim.amazonses.com"]
}

resource "aws_route53_record" "mail-ses-validate-4" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "CNAME"
  name = "5qpxqizafufc5zjohdi4vc7rz3q2fbx6._domainkey"
  ttl = "1"
  records = ["5qpxqizafufc5zjohdi4vc7rz3q2fbx6.dkim.amazonses.com"]
}
