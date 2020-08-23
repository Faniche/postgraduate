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

```shell
sudo kubeadm init --apiserver-advertise-address=192.168.0.200 --pod-network-cidr=10.101.0.0/16

kubeadm join 192.168.0.200:6443 --token 5sf469.px0zr8y1ympfrc8f \
    --discovery-token-ca-cert-hash sha256:6c99922ce19ad150b1d64b6c90523ff6c27672ddfa1e613eb33e9297fc84eea4

kubectl  apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

kubectl get nodes -o wide

kubectl create deployment nginx --image=nginx

kubectl logs nginx-f89759699-qnhdz

kubectl exec -it nginx-f89759699-qnhdz /bin/bash

kubectl scale deployment --replicas=4 nginx

kubectl expose deployment nginx --port=80 --protocol=TCP --type {ClusterIP | NodePort}

kubectl get service

kubectl get pods -w

kubectl set image deployments.app nginx nginx=nginx:stable

f@master:~$ kubectl rollout status nginx
error: the server doesn't have a resource type "nginx"
f@master:~$ kubectl rollout status deployment nginx 
deployment "nginx" successfully rolled out

f@master:~$ kubectl rollout history deployment nginx 
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
3         <none>

f@master:~$ kubectl rollout undo deployment nginx --to-revision=2
deployment.apps/nginx rolled back
f@master:~$ kubectl get pods -w
NAME                     READY   STATUS              RESTARTS   AGE
nginx-674ff86d-f4982     1/1     Running             0          6m
nginx-674ff86d-kxrp4     1/1     Running             0          6m18s
nginx-674ff86d-x4fgh     1/1     Running             0          6m18s
nginx-866797d5b4-djx9l   0/1     ContainerCreating   0          9s
nginx-866797d5b4-qwnmr   0/1     ContainerCreating   0          8s
nginx-866797d5b4-djx9l   1/1     Running             0          11s
nginx-866797d5b4-4wrbl   0/1     Pending             0          0s
nginx-674ff86d-f4982     1/1     Terminating         0          6m2s
nginx-866797d5b4-4wrbl   0/1     Pending             0          0s
nginx-866797d5b4-4wrbl   0/1     ContainerCreating   0          0s
nginx-674ff86d-f4982     0/1     Terminating         0          6m3s
nginx-866797d5b4-4wrbl   0/1     ContainerCreating   0          1s
nginx-674ff86d-f4982     0/1     Terminating         0          6m7s
nginx-674ff86d-f4982     0/1     Terminating         0          6m7s
nginx-866797d5b4-qwnmr   1/1     Running             0          17s
nginx-674ff86d-kxrp4     1/1     Terminating         0          6m27s
nginx-866797d5b4-tx9b4   0/1     Pending             0          0s
nginx-866797d5b4-tx9b4   0/1     Pending             0          0s
nginx-866797d5b4-tx9b4   0/1     ContainerCreating   0          0s
nginx-866797d5b4-tx9b4   0/1     ContainerCreating   0          2s
nginx-674ff86d-kxrp4     0/1     Terminating         0          6m29s
nginx-866797d5b4-4wrbl   1/1     Running             0          10s
nginx-674ff86d-x4fgh     1/1     Terminating         0          6m30s
nginx-674ff86d-x4fgh     0/1     Terminating         0          6m31s
nginx-674ff86d-x4fgh     0/1     Terminating         0          6m35s
nginx-674ff86d-x4fgh     0/1     Terminating         0          6m35s
nginx-674ff86d-kxrp4     0/1     Terminating         0          6m35s
nginx-674ff86d-kxrp4     0/1     Terminating         0          6m35s
nginx-866797d5b4-tx9b4   1/1     Running             0          10s

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



Error: failed to run 'sh -c cd /etc/kubeedge/crds/devices && wget -k --no-check-certificate --progress=bar:force https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/crds/devices/devices_v1alpha1_device.yaml' because of error : exit status 4