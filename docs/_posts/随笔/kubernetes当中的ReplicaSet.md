---
title: kubernetes当中的ReplicaSet
date: 2022-05-31 14:44:01
permalink: /pages/5a0019/
sidebar: auto
categories:
  - 日记
tags:
  - k8s
---
ReplicaSet的目的是维护一组特定数量的 pod 副本，它总是让让 pod 以特定数量运行。 当某个 pod 挂掉后，k8s 会通过 ReplicaSet 重新启动一个新的 pod。 



定义 replicaset 的方式和 pod 很相似，都是维护一个 yaml 文件。 最关键需要注意两个问题： 1、设置好 pod 副本的数量； 2、匹配特定标签的 pod 。



pod 通常不需要独立设置一个 yaml 文件，而是通过在 ReplicaSet 中通过 templete 来指定 pod 信息以及需要用到的镜像。ReplicaSet 会通过 template 来设置好 pod 。



```YAML
# nginx-rs.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
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



这是关于 ReplicaSet 的简单说明：

![](https://secure2.wostatic.cn/static/kWoxZASsb7nYKLQtMwXTEb/image.png)



## 部署 ReplicaSet

k8s 中基本上都是通过固定的声明式方式来部署应用， 还是通过 apply 指令：

```Bash
kubectl apply -f nginx-rs.yaml
```



部署后通过命令查看会发现多了 3 个 pod

```Bash
kubectl pod status

# result
NAME             READY   STATUS    RESTARTS   AGE
nginx-rs-6l9hm   1/1     Running   0          32m
nginx-rs-7v6lm   1/1     Running   0          32m
nginx-rs-q8m5h   1/1     Running   0          32m

```



也可以通过 以下命令查看所有的 ReplicaSet

```Bash
kubectl get rs
```

## 自动重启

ReplicaSet 最重要的作用就是控制 pod 数量，维持容器的健康运行。 当一个 pod 挂掉后，ReplicaSet 会更具声明的 pod 数量重启启动一个新的 pod。



现在我们手工讲其中一个 pod 删掉：

```Bash
kubectl delete pod nginx-rs-6l9hm
```



此时再查看 pod 会发现有一个新的 pod 正在启动，过一段时间后又有 3 个 pod 正常运行。 正因为有 ReplicaSet 的控制，才有了 K8s 强大的容灾能力。



## 访问 ReplicaSet

一个 ReplicaSet 对应多个 pod, 而每一个 pod 都有独立的 ip， 此时，当需要访问应用时就可以通过访问 ReplicaSet 来进行， 然后 ReplicaSet 会把请求分配给其中一个 pod 处理。



外部网络同样无法访问 ReplicaSet 的 IP， 因为目前还是通过端口转发的形式来调试：

```Bash
kubectl port-forward replicaset/nginx-rs 8080:80
kubectl port-forward rs/nginx-rs 8080:80

```



当删掉 Replicaset 时，绑定的所有 pod 会被删除：

```Bash
kubectl delete rs nginx-rs
```

