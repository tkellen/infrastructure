output "ids" { value = ["${aws_subnet.main.*.id}"] }
output "route_table_id" { value = "${aws_route_table.main.id}" }
