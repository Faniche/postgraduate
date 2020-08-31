#!/bin/bash

k3s-killall.sh

export http_proxy=http://host:1080
export https_proxy=http://host:1080

s_url="https://host:6443"
m_token=$(cat /home/f/host/k3s/m_token)

curl -sfL https://get.k3s.io | K3S_URL=${s_url} K3S_TOKEN=${m_token} sh -
