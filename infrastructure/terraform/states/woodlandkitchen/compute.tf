resource "aws_instance" "db" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name = "default"
  subnet_id = "${element(module.subnet.ids,0)}"
  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]
  tags {
    Name = "${var.name}-db-production"
  }
  iam_instance_profile = "${module.iam.instance_profile}"
}

resource "aws_instance" "www" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name = "default"
  subnet_id = "${element(module.subnet.ids,0)}"
  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]
  tags {
    Name = "${var.name}-www-production"
  }
  iam_instance_profile = "${module.iam.instance_profile}"
}
