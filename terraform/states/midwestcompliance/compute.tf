resource "aws_instance" "production" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  key_name = "default"
  subnet_id = "${element(module.subnet.ids,0)}"
  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]
  tags {
    Name = "${var.name}-production"
  }
  iam_instance_profile = "${module.iam.instance_profile}"
}

resource "aws_instance" "staging" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  key_name = "default"
  subnet_id = "${element(module.subnet.ids,0)}"
  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]
  tags {
    Name = "${var.name}-staging"
  }
  iam_instance_profile = "${module.iam.instance_profile}"
}
