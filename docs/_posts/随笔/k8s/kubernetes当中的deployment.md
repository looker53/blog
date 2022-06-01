---
title: kubernetes当中的deployment
date: 2022-05-31 14:44:38
permalink: /pages/65b5e0/
sidebar: auto
categories:
  - 日记
tags:
  - k8s
---
通过前面的笔记应该知道：在实际部署应用时基本不会单独去创建 pod 的资源，而是会通过 ReplicaSet 资源来管理 pod。



而通过 deployment 的学习，需要知道：在实际部署应用时，也很少使用 ReplicaSet，而是通过 deployment 来创建和管理 ReplicaSet。



在 kubernetes 中，Deployment是⼀种更⾼阶资源，⽤于部署应⽤程序并以声明的⽅式升级应⽤，⽽不是通过ReplicaSet进⾏部署，ReplicaSet 被认为是更底层的概念。当创建⼀个Deployment时，ReplicaSet资源也会随之创建，而通过 ReplicaSet 管理的 pod 也会被随之创建。在 Deployment 中，pod 还是由 ReplicaSet 创建和管理。



为什么 k8s 还要抽象出一个 Deployment 的概念而不直接用 ReplicaSet 呢？因为它提供的功能更多，使用起来也更简单。在进行金丝雀这样的发布方式时，能非常轻松的对服务进行回滚和水平设置。



## 设置 deployment

还是通过编写 yaml 文件的形式编写，而且 deployment 的设置和 ReplicaSet 基本没什么区别，只需要修改 kind 类型：

```Bash
# nginx-dp.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dp
spec:
  replicas: 3  # 设置副本数量
  selector:
    matchLabels:
      app: nginx  # 匹配叫 nginx 的 pod 标签
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
```



## 部署

```Bash
kubectl apply -f nginx-dp.yaml
```



## 查看

```Bash
kubectl get deployment
```

