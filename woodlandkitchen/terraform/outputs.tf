output "domain" {
  value = "${var.domain}"
}

output "domain_zone_id" {
  value = "${aws_route53_zone.main.id}"
}
