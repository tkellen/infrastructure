resource "aws_db_subnet_group" "main" {
  name = "${var.name}"
  subnet_ids = ["${module.subnet.ids}"]
}

resource "aws_security_group" "rds" {
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [
      "${var.vpc_cidr_block}"
    ]
  }
}

resource "aws_db_instance" "rds" {
  identifier = "${var.name}"
  storage_type = "gp2"
  allocated_storage = 50
  engine = "postgres"
  engine_version = "9.6.1"
  instance_class = "db.t2.small"
  name = "${var.name}"
  username = "${var.name}"
  password = "changed_immediately"
  db_subnet_group_name = "${aws_db_subnet_group.main.id}"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  backup_retention_period = 30
  backup_window = "05:00-18:30"
  maintenance_window = "sun:03:00-sun:04:00"
  allow_major_version_upgrade = true
}
