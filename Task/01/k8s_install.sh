#!/bin/bash
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
export HTTP_PROXY=10.100.0.1:1080
export HTTPS_PROXY=10.100.0.1:1080
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt kubernetes-stretch main
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
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

