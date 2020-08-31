#!/bin/bash

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
echo 'Setting proxy'
export HTTP_PROXY="http://10.100.0.1:1080"
export HTTPS_PROXY="http://10.100.0.1:1080"
echo 'Get apt-key from google'
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
unset HTTP_PROXY
unset HTTPS_PROXY
sudo apt-get -o Acquire::http::proxy="socks5h://10.100.0.1:1072/" update
sudo apt-get -o Acquire::http::proxy="socks5h://10.100.0.1:1072/" install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# config some env
sudo ufw disable
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
# cat >>/etc/sysctl.d/kubernetes.conf<<EOF
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables = 1
# EOF
# sysctl --system

echo 'Pull the images'
docker pull gotok8s/kube-apiserver:v1.19.0
docker pull gotok8s/kube-controller-manager:v1.19.0
docker pull gotok8s/kube-scheduler:v1.19.0
docker pull gotok8s/kube-proxy:v1.19.0
docker pull gotok8s/pause:3.2
docker pull gotok8s/etcd:3.4.9-1
docker pull gotok8s/coredns:1.7.0
echo 'Finish'

# command auto completion
kubectl completion bash > kubectl.sh
sudo mv kubectl.sh /etc/profile.d/
source /etc/profile.d/kubectl.sh
