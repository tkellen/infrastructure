output "profile" {
  value = "${var.profile}"
}

output "policies" {
  value = {
    ses = "${aws_iam_policy.ses.id}"
  }
}
