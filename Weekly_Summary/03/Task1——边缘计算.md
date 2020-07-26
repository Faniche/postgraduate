# Task1——边缘计算

- 第 `3` 次周报
- 郭雅楠
- 2020.7.36

## 上周安排完成情况

- [x] 按照B站[视频教程](https://www.bilibili.com/video/BV1EV41167Uv?p=16)结合K8s官方文档继续学习，完成视频教程16-26节的内容
- [ ] 为虚拟机配置共享文件夹
- [ ] 学习复杂 `shell` 脚本的编写

+ 初步掌握了 `shell` 脚本的一些基本语法，还需要继续学习

## 遇到的问题

由于k8s版本升级较快，视频教程中的某些命令已经过时，并且无法进入通过 `kubectl exec` 命令在master节点进入 `Pod` ，但是可以使用 `docker exec`  在node节点进入docker容器，根据  [Playing with kubeadm in Vagrant Machines, Part 2](https://medium.com/@joatmon08/playing-with-kubeadm-in-vagrant-machines-part-2-bac431095706) 和 [“kubectl exec” results in “error: unable to upgrade connection: pod does not exist”](https://stackoverflow.com/questions/51154911/kubectl-exec-results-in-error-unable-to-upgrade-connection-pod-does-not-exi)  中提到的分析，可能是三台虚拟机的网络都使用了NAT+内部网络的模式，导致 `Pod` 的内部地址使用了一样的IP，如下所示

```shell
f@master:~$ kubectl get nodes -o wide 
NAME     STATUS   ROLES    AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
master   Ready    master   7d2h   v1.18.6   10.0.2.15     <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   docker://19.3.12
node1    Ready    <none>   28h    v1.18.6   10.0.2.15     <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   docker://19.3.12
node2    Ready    <none>   28h    v1.18.6   10.0.2.15     <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   docker://19.3.12

```

正在寻找合适的解决方案

## 本周计划

- [ ] 完成视频教材27-31小节的内容
- [ ] 继续学习 `Shell`
- [ ] 为虚拟机配置共享文件夹

## 导师意见

