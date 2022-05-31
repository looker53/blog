---
title: kubernetes环境搭建
date: 2022-05-24 13:50:18
permalink: /pages/236ae0/
sidebar: auto
categories:
  - 日记
tags:
  - k8s
---

- 虚拟机
- 安装 minikube
- 安装 docker
- 启动 minikube
- 编写 deployment.yaml 并完成部署



kubernetes 在容器编排领域已经形成统治地位，不管是开发、运维和测试，掌握 kubernetes 都变得非常有必要。这篇文章通过 minikube 搭建一个简单的 kubernetes 运行环境。



## 安装虚拟机

主流的操作系统都支持 kubernetes，但是 windows 操作系统在安装 kubernetes 时，不能通过本地网络直接访问，必须要使用另一台机器，额外装一个虚拟机用起来还是会更方便一些。



装虚拟机可能对电脑的配置要求会更高一些，kubernetes 本身要求电脑的配置至少要 2G 以上内存，2 核以上，虚拟机还需要占用一定的资源，可能会造成电脑满负荷运转。



在 vmware 上装了一个 ubuntu 系统，界面看上去不错。

![image-20220524171914289](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220524171914289.png)



## 安装 minikube

kubernetes 官方管理工具是 kubeadmin， 适用于生产环境搭建集群， 也可以使用第三方的管理工具 rancher 或者 k9s 这样的工具。 如果是第一次接触，还是先用 minikube 来顺利调通环境吧。



在 ubuntu 中安装 minikube 比较简单，先通过第一行命令把安装包下载到本地，在通过第二行命令完成安装。

```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb

sudo dpkg -i minikube_latest_amd64.deb
```



安装完成后，通过 minikube start 尝试启动环境：

![image-20220524172653286](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220524172653286.png)



如果是在一个新的系统上启动，可能会提示没有容器执行引擎，因而无法启动。 kubernetes 支持的容器引擎非常多，包括：

- vertualbox
- vmwarefusion
- kvm2
- vmware
- docker
- podman

可以通过 minikube start --help 查看到，我就直接用 docker 了。



## 安装 docker

docker 安装可以直接参考 [官方文档](https://docs.docker.com/engine/install/ubuntu/) 的说明.

1、先卸载掉原有的依赖：

```
sudo apt-get remove docker docker-engine docker.io containerd runc
```

2、设置 rep

```
 sudo apt-get update
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

3、添加 docker 的官方 GPG key

```
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

4、设置稳定版本

```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

5、安装 dockeer

```
sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

6、设置用户组

```
sudo usermod -aG docker $USER && newgrp docker
```



好了，当 docker 安装好后，重新运行 minikube start，出现启动成功的提示就表示 minikube 能正常使用了。

![image-20220524172931940](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220524172931940.png)



## 部署应用

管理和部署容器需要用到 kubernetes 提供的 kubectl 工具， 启动时 minikube 提示如果要使用 kubectl 需要拼写 minikube kubectl  -- ， 非常繁琐，所以可以定义一个快捷命令：

```
alias k="minikube kubectl --"
```



在目录下创建一个 nginx-dp.yaml 文件：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
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



然后通过以下命令来运行：

```
minikube kubectl -- apply -f nginx-dp.yaml
```



启动之后通过以下命令查看已经运行的 deployments:

![image-20220525143011208](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220525143011208.png)



但是部署的项目目前是无法通过外部访问的，如果需要外部访问，则需要暴露端口：

```python
kubectl expose deployment nginx-deployment --type=LoadBalancer --port 80
```



查看所有的服务端口

```
minikube node list     # 查看节点IP
kubectl get svc -A
```

![image-20220525155532089](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220525155532089.png)



或者通过 minikube 查看所有的服务：

```
minikube service list
```

![image-20220525155622151](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220525155622151.png)



现在就可以通过网络访问到nginx 服务了。