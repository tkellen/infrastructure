resource "aws_instance" "etcd" {
  count = "${var.etcd_count}"
  ami = "${var.ami}"
  instance_type = "${var.etcd_instance_type}"
  key_name = "${var.key_name}"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.etcd.id}"
  ]
  private_ip = "${cidrhost(element(aws_subnet.main.*.cidr_block, count.index), 5)}"
  tags {
    Name = "${var.name}-etcd-${count.index}"
  }
}

resource "aws_instance" "controlplane" {
  count = "${var.controlplane_count}"
  ami = "${var.ami}"
  instance_type = "${var.controlplane_instance_type}"
  key_name = "${var.key_name}"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.controlplane.id}"
  ]
  private_ip = "${cidrhost(element(aws_subnet.main.*.cidr_block, count.index), 10)}"
  tags {
    Name = "${var.name}-controlplane-${count.index}"
  }
  source_dest_check = false
}

resource "aws_instance" "worker" {
  count = "${var.worker_count}"
  ami = "${var.ami}"
  instance_type = "${var.worker_instance_type}"
  key_name = "${var.key_name}"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.worker.id}"
  ]
  tags {
    Name = "${var.name}-worker-${count.index}"
  }
  source_dest_check = false
}
