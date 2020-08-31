# Task1——边缘计算

- 第 `7` 次周报
- 郭雅楠
- 2020.8.30

## 上周安排完成情况

- [x] 学习了视频教程2-28那一节
- [x] 在华为云服务器安装PostgreSQL数据库作为集群的外置存储

## 正在进行的工作

+ 正在重新复习 `kubernetes`的相关概念，因为 k3s 中的很多概念直接用可 `kubernetes`，而 k3s 的官方文档介绍的很少
+ 在 `kubernetes` 集群中运行了 `NextCloud`，正在了解 `NextCloud` 更详细的配置

## 遇到的问题

+ 使用 `helm`通过配置文件部署应用的时候 `kuberbetes` 的一个仓库无法访问，https://github.com/rancher/k3s/issues/24，按照issue中提到的方法未能解决

## 本周计划

- [ ] 争取解决遇到的问题
- [ ] 优化`NextCloud` 的配置，尝试让`NextCloud`在k3s集群中运行
- [ ] 考虑如何将缓存引入

暂时计划使用 `PostgreSQL`, `Redis`, `K3s`, `NextCloud` 实现一个简单的文件管理系统，`K3s` 作为管理框架，`Redis` 作为缓存