resource "aws_route53_zone" "main" {
  name = var.domain
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "a" {
  zone_id = aws_route53_zone.main.id
  type = "A"
  name = var.domain
  alias {
    name = aws_s3_bucket.main.website_domain
    zone_id = aws_s3_bucket.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "redirect" {
  bucket = "www.${var.domain}"
  website {
    redirect_all_requests_to = var.domain
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.id
  type = "A"
  name = "www"
  alias {
    name = aws_s3_bucket.redirect.website_domain
    zone_id = aws_s3_bucket.redirect.hosted_zone_id
    evaluate_target_health = false
  }
}
