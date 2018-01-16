data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "main" {
  count = "${length(local.subnetCidrs)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${element(local.subnetCidrs, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.name}-${count.index}"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.main.*.id}"]
  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_route" "main" {
  route_table_id = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table_association" "main" {
  count = "${length(local.subnetCidrs)}"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_eip" "loadbalancer" {
  instance = "${aws_instance.controlplane.0.id}"
  vpc = true
}
