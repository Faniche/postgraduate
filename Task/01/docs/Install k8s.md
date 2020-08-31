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



### 对象规约（Spec）与状态（Status）

几乎每个 Kubernetes 对象包含两个嵌套的对象字段，它们负责管理对象的配置： 对象 *`spec`（规约）* 和 对象 *`status`（状态）* 。 对于具有 `spec` 的对象，你必须在创建对象时设置其内容，描述你希望对象所具有的特征： *期望状态（Desired State）* 。

`status` 描述了对象的 *当前状态（Current State）*，它是由 Kubernetes 系统和组件 设置并更新的。在任何时刻，Kubernetes [控制平面](https://kubernetes.io/zh/docs/reference/glossary/?all=true#term-control-plane) 都一直积极地管理着对象的实际状态，以使之与期望状态相匹配。



## 命令式命令

使用命令式命令时，用户可以在集群中的活动对象上进行操作。用户将操作传给 `kubectl` 命令作为参数或标志。

这是开始或者在集群中运行一次性任务的最简单方法。因为这个技术直接在活动对象上操作，所以它不提供以前配置的历史记录。

通过创建 Deployment 对象来运行 nginx 容器的实例：

```sh
kubectl run nginx --image nginx
```

使用不同的语法来达到同样的上面的效果：

```sh
kubectl create deployment nginx --image nginx
```

## 命令式对象配置

在命令式对象配置中，kubectl 命令指定操作（创建，替换等），可选标志和至少一个文件名。指定的文件必须包含 YAML 或 JSON 格式的对象的完整定义。

创建配置文件中定义的对象：

```sh
kubectl create -f nginx.yaml
```

删除两个配置文件中定义的对象：

```sh
kubectl delete -f nginx.yaml -f redis.yaml
```

通过覆盖活动配置来更新配置文件中定义的对象：

```sh
kubectl replace -f nginx.yaml
```

## 声明式对象配置

使用声明式对象配置时，用户对本地存储的对象配置文件进行操作，但是用户未定义要对该文件执行的操作。`kubectl` 会自动检测每个文件的创建、更新和删除操作。这使得配置可以在目录上工作，根据目录中配置文件对不同的对象执行不同的操作。

处理 `configs` 目录中的所有对象配置文件，创建并更新活动对象。可以首先使用 `diff` 子命令查看将要进行的更改，然后在进行应用：

```sh
kubectl diff -f configs/
kubectl apply -f configs/
```

递归处理目录：

```sh
kubectl diff -R -f configs/
kubectl apply -R -f configs/
```

### 描述 Kubernetes 对象

创建 Kubernetes 对象时，必须提供对象的规约，用来描述该对象的期望状态， 以及关于对象的一些基本信息（例如名称）。 当使用 Kubernetes API 创建对象时（或者直接创建，或者基于`kubectl`）， API 请求必须在请求体中包含 JSON 格式的信息。 **大多数情况下，需要在 .yaml 文件中为 `kubectl` 提供这些信息**。 `kubectl` 在发起 API 请求时，将这些信息转换成 JSON 格式。

这里有一个 `.yaml` 示例文件，展示了 Kubernetes Deployment 的必需字段和对象规约：

application/deployment.yaml 

```yaml
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```