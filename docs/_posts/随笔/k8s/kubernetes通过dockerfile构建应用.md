---
title: kubernetes通过dockerfile构建应用
date: 2022-06-01 16:53:10
permalink: /pages/0d037b/
sidebar: auto
categories:
  - 日记
tags:
  - k8s
---

在本地使用Kubernetes时，您可能希望在Kubernetes中运行一些本地构建的Docker镜像。但是 kubernetes 希望你把镜像上传到镜像仓库，这个仓库可以是公开的，也可是是私有的，当需要用到镜像时，再从仓库中拉取下来。

在调试阶段，这可能会遇到一些麻烦。那能不能直接通过本地的 Dockerfile 文件来运行 kubernetes 应用呢？

这篇文章介绍一种办法，不需要把镜像发布到镜像仓库，直接使用本地的 Dockerfile 文件来操作。



## Dockerfile 编写

首先我写了一个网络服务，想通过 kubernetes 部署。代码经过简化：

```Python
from flask import Flask

app = Flask("payment")

@app.route("/")
def index():
  return "I'm payment server!"

app.run(port=5000)
```



我编写了一个 Dockerfile 来构建镜像：

```Docker
FROM python:3.9.0-slim
ADD . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```



构建镜像：

```Bash
docker build -t flask-demo .
```



有了镜像先用 docker 运行一下看看行不行：

```Bash
docker run flask-demo
```

可以看到服务正常启动了

![image-20220601165643337](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220601165643337.png)



## 用 kubernetes 试试

用 docker 运行容器不是我的目的，我是想通过 kubernetes 来运行的，所以现在需要编写一个 yaml 文件来指定运行的 docker 容器：

```YAML
# flask.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask
  template:
    metadata:
      labels:
        app: flask
    spec:
      containers:
      - args:
        - python
        - app.py
        image: flask-demo
        name: flask
      restartPolicy: Always
```



其中 args 表示启动容器时要运行的命令，启动一下：

```YAML
kubectl create -f flask.yaml
```

查看一下 pod 的状态，发现镜像拉取失败了。

```YAML
> kubectl get pods
NAME              READY STATUS       RESTARTS AGE
flask-world-lfrzh 0/1   ErrImagePull 0        6s
```



这是因为我们自己创建的镜像既不在 minikube 的绑定镜像库中，也没有在 docker hub 的公共镜像库中，它只在 docker 的本地库。



## 不从公共镜像库中拉取

现在我们直接在 yaml 中添加一行，不拉取镜像：

```YAML
# flask.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask
  template:
    metadata:
      labels:
        app: flask
    spec:
      containers:
      - args:
        - python
        - app.py
        image: flask-demo
        name: flask
        imagePullPolicy: Never
      restartPolicy: Always
```



当再次部署后，得到的 pod 状态是 ErrImageNeverPull：

```YAML
> kubectl get pods
NAME              READY STATUS            RESTARTS AGE
flask-world-r4g9g 0/1   ErrImageNeverPull 0        6s
```



这是因为 minikube 本身的镜像库和 docker 自带的不是同一个，因此使用 kubenetes 时找不到镜像，因为要把 Docker daemon 绑定到 minikube 的内部镜像库，可以通过以下命令得到具体的提示：

```YAML
> minikube docker-env
export DOCKER_TLS_VERIFY=”1"
export DOCKER_HOST=”tcp://172.17.0.2:2376"
export DOCKER_CERT_PATH=”/home/user/.minikube/certs”
export MINIKUBE_ACTIVE_DOCKERD=”minikube”
# To point your shell to minikube’s docker-daemon, run:
# eval $(minikube -p minikube docker-env)
```



有了提示，直接操作：

```YAML
eval $(minikube -p minikube docker-env)
```



现在再构建的时候就很可以看到正常的 pod 状态啦。



## 查看服务

还是使用端口转发来调试下部署的应用, 访问端口就能看到能正常访问了。

```YAML
kubectl port-forward deployment/flask 5000:5000
```

![image-20220601165704472](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220601165704472.png)