---
title: kubernetes当中的pod
date: 2022-05-31 14:43:19
permalink: /pages/ae59b4/
sidebar: auto
categories:
  - 日记
tags:
  - k8s
---
## 使用现成的镜像



### 1、创建 YAML 文件

在项目目录下创建文件 nginx-pod.yaml

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```



![](https://secure2.wostatic.cn/static/9GYrkuqVN7PMQDfYseT53W/image.png)



### 2、部署应用

```YAML
kubectl apply -f nginx-pod.yaml
```



### 3、查看应用状态

上面 yaml 文件中声明了 pod 的名称为 nginx， 可以通过以下命令查看状态。

```Bash
kubectl get pod nginx

# result
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          17s

```



### 4、访问 pod

目前我们并不能通过外部网络和 pod 通讯，因为 pod 开发的端口都只在 kubernetes 中生效。如果我们想通过外部网络访问 pod 中某个容器，可以使用 端口转发 来调试 pod 是否已经正常运行。

```Bash
kubectl port-forward nginx 8888:80
```

其中，nginx 表示 pod 名称， 8888 表示主机开放的端口号， 80表示要访问的 pod 的端口号。端口转发的窗口默认前台执行，当不需要调试时，ctrl + c 退出即可。



在另一个窗口中输入 curl localhost:8888, 则可以看到返回的信息。

![](https://secure2.wostatic.cn/static/dFMdzEsRBsT8MKUE4YVy1i/image.png)



此时如果查看 pod 的日志，可以看到有新的记录产生。

```Bash
kubectl logs nginx

# result
127.0.0.1 - - [28/May/2022:07:25:31 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.81.0" "-"

```







## 自定义镜像推送到私有仓库



```JavaScript
// create a http server
// http.js
const http = require('http');
const os = require('os');
console.log("http start...")

var handler = function(req, res) {
    console.log("http request...")
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('<h1>Hello World</h1>');
}
var www = http.createServer(handler);
www.listen(8080);
```



编写 Dockerfile:

```Docker
FROM node:7
ADD app.js /app.js
CMD ["node", "app.js"]
```



构建镜像：

```Bash
docker build -t node-server-demo .
```



打标签：

```Bash
docker tag node-server-demo looker53/node-server-demo
```



登录上传：

```Bash
docker login
docker push looker53/node-server-demo
```



## k8s 使用私有仓库镜像

docker 登录后，可以在 ~/.docker/config.json 查看到授权令牌

```Bash
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "c3R...zE2"
        }
    }
}
```



将 docker 登录需要用到的令牌配置到 k8s 中：

```Bash
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/yuz/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson
```



也可以使用 yaml 声明式配置：

如果你需要更多的设置（例如，为新 Secret 设置名字空间或标签）， 则可以在存储 Secret 之前对它进行自定义。 请务必：

- 将 data 项中的名称设置为 `.dockerconfigjson`
- 使用 base64 编码方法对 Docker 配置文件进行编码，然后粘贴该字符串的内容，作为字段 `data[".dockerconfigjson"]` 的值
- 将 `type` 设置为 `kubernetes.io/dockerconfigjson`

```Bash
apiVersion: v1
kind: Secret
metadata:
  name: myregistrykey
  namespace: awesomeapps
data:
  .dockerconfigjson: UmVhbGx5IHJlYWxseSByZWVlZWVlZWVlZWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGx5eXl5eXl5eXl5eXl5eXl5eXl5eSBsbGxsbGxsbGxsbGxsbG9vb29vb29vb29vb29vb29vb29vb29vb29vb25ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubmdnZ2dnZ2dnZ2dnZ2dnZ2dnZ2cgYXV0aCBrZXlzCg==
type: kubernetes.io/dockerconfigjson
```



私有仓库配置请参考： [https://kubernetes.io/zh/docs/tasks/configure-pod-container/pull-image-private-registry/](https://kubernetes.io/zh/docs/tasks/configure-pod-container/pull-image-private-registry/)





yaml 创建 pod 时，添加 imagePullSecrets

```Bash
apiVersion: v1
kind: Pod
metadata:
  name: node-server-demo
spec:
  containers:
  - name: node-server-demo
    image: looker53/node-server-demo:latest
    ports:
    - containerPort: 8080
  imagePullSecrets:
  - name: regcred
```



现在可以部署了：

```Bash
kubectl apply -f node-server-demo-pod.yaml
```



同样通过端口转发能调试访问到 8080 端口：

```Bash
kubectl port-forward node-server-demo 8080:8080
```



## 本地镜像直接用在 k8s

todo

