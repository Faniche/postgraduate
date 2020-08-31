#!/bin/bash

k3s-killall.sh && k3s-uninstall.sh

export http_proxy=http://host:1080
export https_proxy=http://host:1080

curl -sfL https://get.k3s.io | sh -s - server --datastore-endpoint='mysql://root:root123@tcp(192.168.0.199:3306)/k3sdb'
cat -s /var/lib/rancher/k3s/server/node-token > /home/f/host/k3s/m_token

