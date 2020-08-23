# Task1——边缘计算

**第一次周报中提到的问题详细描述及解决**

+ 2020.7.14
+ 郭雅楠

**之前的问题已得到解决**

**主要原因:**

+ DNS服务器列表配置的顺序，导致域名解析错误

**仍然存在的问题**

+ 配置静态IP后丢包严重，暂时不知道原因

## 之前存在的问题描述

虚拟机默认网络配置信息

<img src="/home/faniche/.config/Typora/typora-user-images/image-20200714204406176.png" alt="image-20200714204406176"  />

网络信息

<img src="/home/faniche/.config/Typora/typora-user-images/image-20200714204259337.png" alt="image-20200714204259337"  />

enp0s3是桥接的宿主机的网络，enp0s8是在VirtualBox中定义的网络

<img src="/home/faniche/.config/Typora/typora-user-images/image-20200714204120957.png" alt="image-20200714204120957" style="zoom:80%;" />

默认情况下，虚拟机可以连接到公网

<img src="/home/faniche/.config/Typora/typora-user-images/image-20200714204501595.png" alt="image-20200714204501595"  />

修改后的网络配置

![image-20200714205143826](/home/faniche/.config/Typora/typora-user-images/image-20200714205143826.png)

无法连接网络

<img src="/home/faniche/.config/Typora/typora-user-images/image-20200714205048108.png" alt="image-20200714205048108"  />





之前使用的配置，静态IP

![image-20200714210701561](/home/faniche/.config/Typora/typora-user-images/image-20200714210701561.png)

这里显示DNS有问题，但是已经找到了原因，`8.8.8.8`和`8.8.4.4`不可达，配置的dns服务器貌似只会取第一个地址

![image-20200714210749316](/home/faniche/.config/Typora/typora-user-images/image-20200714210749316.png)

将DNS服务器地址修改后，只保留宿主机作为DNS服务器

![image-20200714211243782](/home/faniche/.config/Typora/typora-user-images/image-20200714211243782.png)

问题得到解决，但是丢包严重

![image-20200714210430517](/home/faniche/.config/Typora/typora-user-images/image-20200714210430517.png)

![image-20200714211158183](/home/faniche/.config/Typora/typora-user-images/image-20200714211158183.png)

