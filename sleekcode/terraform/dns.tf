resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
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
    "20 alt1.aspmx.l.google.com.",
    "20 alt2.aspmx.l.google.com.",
    "30 aspmx2.googlemail.com.",
    "30 aspmx3.googlemail.com.",
    "30 aspmx4.googlemail.com.",
    "30 aspmx5.googlemail.com.",
    "10 aspmx.l.google.com."
  ]
}

resource "aws_route53_record" "txt-d-spf" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "${var.domain}"
  ttl = "1"
  records = ["v=spf1 ip4:207.126.144.0/20 ip4:64.18.0.0/20 ip4:74.125.148.0/22 ip4:<yourdomain.com IP allocations> ~all"]
}

resource "aws_route53_record" "txt-domainkey" {
  zone_id = "${aws_route53_zone.main.id}"
  type = "TXT"
  name = "google._domainkey"
  ttl = "1"
  records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC1pgX66jLZnR8UqbLpO0x7ydj7eUzgv0ENmFtTm67NLrXiSB91JP9BuEDZEhr/Nnyxi5CzN8VVPicURbj2Nmq3FHwDDTfIyTHQoKvoh6r//SqoMQHyk8bbp72+NMiOdhkhw8ufSxX456E1aAsGDT+p/98YmeLSmUGkCRLEO3KQyQIDAQAB"]
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
  alias {
    name = "${element(aws_s3_bucket.alias-apex.*.website_domain, count.index)}"
    zone_id = "${element(aws_s3_bucket.alias-apex.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aliases-www" {
  count = "${length(var.alias_domains)}"
  zone_id = "${element(aws_route53_zone.aliases.*.id, count.index)}"
  type = "A"
  name = "www"
  alias {
    name = "${element(aws_s3_bucket.alias-www.*.website_domain, count.index)}"
    zone_id = "${element(aws_s3_bucket.alias-www.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "alias-apex" {
  count = "${length(var.alias_domains)}"
  bucket = "${element(var.alias_domains, count.index)}"
  website {
    redirect_all_requests_to = "${var.domain}"
  }
}

resource "aws_s3_bucket" "alias-www" {
  count = "${length(var.alias_domains)}"
  bucket = "www.${element(var.alias_domains, count.index)}"
  website {
    redirect_all_requests_to = "${var.domain}"
  }
}
