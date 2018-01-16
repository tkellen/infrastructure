# TODO: lock this down
resource "aws_security_group" "etcd" {
  name = "${var.name}-etcd"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.name}-etcd"
  }
}

resource "aws_security_group" "controlplane" {
  name = "${var.name}-controlplane"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.name}-controlplane"
  }
}

resource "aws_security_group" "worker" {
  name = "${var.name}-worker"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.name}-worker"
  }
}
