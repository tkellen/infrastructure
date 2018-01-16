output "profile" {
  value = "${var.profile}"
}

output "cluster-name" {
  value = "${var.name}"
}

output "cluster-controlplane-hostnames" {
  value = "${module.cluster.controlplane-hostnames}"
}

output "cluster-controlplane-ssh-ips" {
  value = "${module.cluster.controlplane-ssh-ips}"
}

output "cluster-controlplane-private-ips" {
  value = "${module.cluster.controlplane-private-ips}"
}

output "cluster-etcd-hostnames" {
  value = "${module.cluster.etcd-hostnames}"
}

output "cluster-etcd-ssh-ips" {
  value = "${module.cluster.etcd-ssh-ips}"
}

output "cluster-etcd-private-ips" {
  value = "${module.cluster.etcd-private-ips}"
}

output "cluster-worker-ssh-ips" {
  value = "${module.cluster.worker-ssh-ips}"
}

output "cluster-worker-private-ips" {
  value = "${module.cluster.worker-private-ips}"
}

output "cluster-worker-hostnames" {
  value = "${module.cluster.worker-hostnames}"
}

output "cluster-public-ip" {
  value = "${module.cluster.public-ip}"
}
