# aevitas
> cluster management guide.


## Setting up a cluster
First, spin up the cluster VMs by applyig the the terraform configuration
under `terraform`.

```
cd terraform
terraform init
terraform apply
terraform apply
```
*Applying twice is needed to ensure the elastic ip is correctly exported.*

The terraform configuration above provides exports that are used to build
environment variables that power [KWM]. Export those settings into your
environment by running the following:
```
. <(bin/init)
```

Bootstrap the cluster using KWM:
```
kwm render pki | bash
kwm render cluster-admin | bash
kwm nodes etcd | xargs -n1 kwm render etcd-node | bash
kwm nodes controlplane | xargs -n1 kwm render controlplane-node | bash
kwm nodes controlplane | xargs -n1 kwm render worker-node | bash
kwm nodes worker | xargs -n1 kwm render worker-node | bash
kwm render cni-manifest > kubernetes/cni.yml
kwm render dns-manifest > kubernetes/kube-dns.yml
kubectl --context=aevitas apply -f kubernetes

# Bounce cri-containerd (remove when this is resolved):
# https://github.com/containerd/cri-containerd/issues/545
((kwm nodes controlplane && kwm nodes worker) | uniq |
  xargs -n1 -I {} bash -c "echo 'sudo systemctl restart containerd' | kwm connect {}"
)
```

Verify the cluster is up!
```
kubectl --context=aevitas get componentstatus
kubectl --context=aevitas get nodes -o wide
kubectl --context=aevitas get pods -o wide --all-namespaces
```

[KWM]: http://github.com/tkellen/kwm
