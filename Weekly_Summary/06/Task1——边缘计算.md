# Task1——边缘计算

- 第 `6` 次周报
- 郭雅楠
- 2020.8.23

## 上周安排完成情况

- [x] 学习部署架构
- [x] 学习高可用的部署方式
- [x] 配置外置分布式数据库并测试

+ 正在学习数据库`PostgreSQL`
+ 正在学习`Helm`(k3s 和 k8s 的应用包管理工具)
+ 正在学习一个文件管理系统[NextCloud](https://zh.wikipedia.org/wiki/Nextcloud)，`NextCloud`不仅是一个文件管理系统，也是一个管理平台，有很多丰富的插件，同时helm官方支持的应用总也有`NextCloud`

## 遇到的问题

+ 之前学习k8s的时候只是学习了一些基本的配置，而k3s是基于k8s的，B站的教学视频也是学员基于已经很好的掌握了k8s，所以学习起来难度较大

## 本周计划

- [ ] 跟着视频教程继续学习(已经学习了2-14和2-21两节)

  <img src="/home/faniche/Postgraduate/Weekly_Summary/06/Task1——边缘计算.assets/image-20200823210950496.png" alt="image-20200823210950496"  />

- [ ] 在华为云服务器安装PostgreSQL数据库作为集群的外置存储

暂时计划 PostgreSQL, Redis, K3s, NextCloud 实现一个简单的文件管理系统，K3s作为管理框架，Redis作为缓存