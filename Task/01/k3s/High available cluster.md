# High available cluster with external data source

## Component

一个Mysql作为外置数据源

一个nginx作为四层负载均衡

2个k3s server

2个k3s agent

## Start a mysql container

`docker run --name k3sdb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=k3sdb -d mysql`

## Start k3s server

### k3s-server-cloud_init.yaml

```shell
# cloud-config

runcmd:
- proxy_addr=http://192.168.0.199:1080
- external_db_addr=192.168.0.199:3306
- export http_proxy=$proxy_addr
- export https_proxy=$proxy_addr
- curl --proxy http://192.168.0.199:1080 -sfL https://get.k3s.io | sh -s - server --datastore-endpoint='mysql://root:root123@tcp(192.168.0.199:3306)/k3sdb'
```

### Start k3s server with multipass

```shell
# server1
multipass launch -v -n k3s-s1 -m 1G -d 5G --cloud-init ./k3s-server_cloud_init.yaml file:///home/faniche/Virtual\ Machines/ISO/focal-server-cloudimg-amd64.img
# server2
multipass launch -v -n k3s-s2 -m 1G -d 5G --cloud-init ./k3s-server_cloud_init.yaml file:///home/faniche/Virtual\ Machines/ISO/focal-server-cloudimg-amd64.img

```

## Start nginx container

### get server ip

```shell
s1_ip=$(multipass list --format json | jq -r '.list[]|select(.name=="k3s-s1")|.ipv4[0]')
s2_ip=$(multipass list --format json | jq -r '.list[]|select(.name=="k3s-s2")|.ipv4[0]')
```

### generate nginx config file

```shell
cat <<EOF >> ./k3s-nginx.conf
error_log stderr notice;
worker_processes auto;
events {
	multi_accept on;
	worker_connections 1024;
}
stream {
	upstream kube_apiserver {
		server ${s1_ip}:6443;
		server ${s2_ip}:6443;
	}
	server {
		listen			6443;
		proxy_pass		kube_apiserver;
		proxy_timeout	30;
		proxy_connect_timeout	2s;
	}
}
EOF
```

### launch nginx container

`docker run --name k3sproxy -p 6443:6443 -v $(pwd)/k3s-nginx.conf:/etc/nginx/nginx.conf:ro -d nginx`

## Start k3s agent

### set nginx server ip as the entry of k3s server

`s_url="https://10.236.88.1:6443"`

### get node token form k3s server

`s_token=$(multipass exec k3s-s1 -- sh -c "sudo cat -s /var/lib/rancher/k3s/server/node-token")`

### k3s-agent-cloud_init.yaml

```shell
cat <<EOF > ./k3s-agent-cloud_init.yaml
runcmd:
- export k3s_url=${s_url}
- export k3s_token=${s_token}
- export http_proxy=http://10.236.88.1:1080
- export https_proxy=http://10.236.88.1:1080
- curl --proxy http://10.236.88.1:1080 -sfL https://get.k3s.io | K3S_URL=${s_url} K3S_TOKEN=${s_token} sh -
EOF
```

### launch k3s agent

```shell
# server1
multipass launch -v -n k3s-a1 -m 1G -d 5G --cloud-init ./k3s-agent-cloud_init.yaml file:///home/faniche/Virtual\ Machines/ISO/focal-server-cloudimg-amd64.img
# server2
multipass launch -v -n k3s-a2 -m 1G -d 5G --cloud-init ./k3s-agent-cloud_init.yaml file:///home/faniche/Virtual\ Machines/ISO/focal-server-cloudimg-amd64.img
```

# High available cluster with distributed database

the number of k3s server must be odd and bigger than 3

## Start k3s master server

### k3s-server1-cloud_init.yaml

```yaml
# cloud-config

runcmd:
- export http_proxy=http://10.236.88.1:1080
- export https_proxy=http://10.236.88.1:1080
- curl --proxy http://10.236.88.1:1080 -sfL https://get.k3s.io | sh -s - server --cluster-init
```

### start server1

```shell
# server1
multipass launch -v -n k3s-s1 -m 1G -d 5G --cloud-init ./k3s-server1_cloud_init.yaml file:///home/faniche/Virtual\ Machines/ISO/focal-server-cloudimg-amd64.img
```

## start slave server

### get server1 ip

```shell
s1_ip=$(multipass list --format json | jq -r '.list[]|select(.name=="k3s-s1")|.ipv4[0]')
s1_url="https://${s1_ip}:6443"
s1_token=$(multipass exec k3s-s1 -- sh -c "sudo cat -s /var/lib/rancher/k3s/server/node-token") 
```

### generate config file

```shell
# k3s-server2-cloud_init.yaml

cat <<EOF > ./k3s-server2-cloud_init.yaml
runcmd:
- export s1_url=${s1_url}
- export s1_token=${s1_token}
- export http_proxy=http://10.236.88.1:1080
- export https_proxy=http://10.236.88.1:1080
- curl --proxy http://10.236.88.1:1080 -sfL https://get.k3s.io | sh -s - server --server ${s1_url} --token ${s1_token}
EOF
```

### start slave server

```shell
# server2
multipass launch -v -n k3s-s1 -m 1G -d 5G --cloud-init ./k3s-server1_cloud_init.yaml file:///home/faniche/Virtual\ Machines/ISO/focal-server-cloudimg-amd64.img

# server3
multipass launch -v -n k3s-s3 -m 1G -d 5G --cloud-init ./k3s-server1_cloud_init.yaml file:///home/faniche/Virtual\ Machines/ISO/focal-server-cloudimg-amd64.img
```

## start k3s agent

······

# Contanerd  

![image-20200821213235190](/home/faniche/Postgraduate/Task/01/k3s/High available cluster.assets/image-20200821213235190.png)

![image-20200821213343534](/home/faniche/Postgraduate/Task/01/k3s/High available cluster.assets/image-20200821213343534.png)

**check containerd logs**

```shell
sudo tail -f /var/lib/rancher/k3s/agent/containerd/containerd.log
```

![image-20200821214640030](/home/faniche/Postgraduate/Task/01/k3s/High available cluster.assets/image-20200821214640030.png)