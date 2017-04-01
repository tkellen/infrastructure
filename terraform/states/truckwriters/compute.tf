resource "aws_instance" "production" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  key_name = "default"
  subnet_id = "${aws_subnet.main.id}"
  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]
  tags {
    "Name" = "${var.name}-production"
  }
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
}
