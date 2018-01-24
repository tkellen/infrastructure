output "id" {
  value = "${aws_iam_role.main.id}"
}

output "instance_profile" {
  value = "${aws_iam_instance_profile.main.name}"
}

output "user" {
  value = "${aws_iam_user.main.name}"
}
