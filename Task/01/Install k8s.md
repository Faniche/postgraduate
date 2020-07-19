```shell
docker network create --driver bridge --subnet 172.18.0.0/16 --gateway 172.18.0.1 k8s
```

install kubeadm

使用docker

### Pre-requisites

##### Update /etc/hosts

So that we can talk to each of the nodes in the cluster

```shell
cat >>/etc/hosts<<EOF
192.168.0.103 kmaster.example.com kmaster
192.168.0.108 kworker.example.com kworker
EOF
```

1. ```
   export HTTP_PROXY=192.168.0.114:1080
   ```

   ## On kmaster

```
kubeadm init --apiserver-advertise-address=10.100.0.3 --pod-network-cidr=10.101.0.0/16
```

## Get k8s images

```shell
docker pull gotok8s/kube-apiserver:v1.18.6
docker pull gotok8s/kube-controller-manager:v1.18.6
docker pull gotok8s/kube-scheduler:v1.18.6
docker pull gotok8s/kube-proxy:v1.18.6
docker pull gotok8s/pause:3.2
docker pull gotok8s/etcd:3.4.3-0
docker pull gotok8s/coredns:1.6.7
```



