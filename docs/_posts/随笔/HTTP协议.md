---
title: HTTP协议
date: 2022-05-31 14:56:09
permalink: /pages/5269a3/
sidebar: auto
categories:
  - 测试
tags:
  - 接口
---

### 1.1、什么是 API 接口

项目地址：[http://api.lemonban.com/futureloan](http://api.lemonban.com/futureloan)

![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903200944863.png)

**接口定义规则，**可以在接口文档查看：

- 访问地址
- 请求方法
- 请求参数

**什么是接口测试？**

测试接口的返回数据是否和预期一致。可以使用浏览器、postman、jmeter 和 soupui 等接口测试工具，也可以通过代码访问。

### 1.2、HTTP 协议

接口需要使用协议才能完成，最广泛使用的协议是 [HTTP 协议](https://developer.mozilla.org/zh-CN/docs/Web/HTTP)。HTTP（超文本传输协议）是用于传输超媒体文档（例如 HTML）的应用层协议。它是为 Web 浏览器与 Web 服务器之间的通信而设计的，但也可以用于其他目的。HTTP 遵循经典的**客户端-服务端**模型，客户端打开一个连接以发出请求，然后等待直到收到服务器端响应。

用户通过客户端访问某个 URL 地址，发送请求给服务器，服务器接收到请求以后，解析请求数据，给客户端返回响应数据。

![image-20210903201036703](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903201036703.png)



**C/S 软件架构**

- Client/Server, Browser/Server
- P2P, peer to peer。



## 邮局的比喻

客户端访问服务端类比于 邮局系统。

- 发送的目的地
- 手机号精确找到收件人 ： 端口 和 路径
- 我们自己的IP和端口也会写上去： 别人会给你回
- 快递公司的选择： 选择什么快递公司不是那么重要，要发送的东西的特性。 请求方法
- 选择什么请求方法：你要发送的数据的特性。
- 填快递单： 快递内容进行简单的说明：   请求头
- 快递盒子里具体的东西：    请求体



### 1.2.1、HTTP 请求

![image-20210903201108025](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903201108025.png)



**URL**

![image-20210903201126218](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903201126218.png)

统一资源定位符（Uniform Resource Locator），它也被称为 web 地址。相当于快递单上的地址。

**请求方法**

![image-20210903201145102](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903201145102.png)

常见的请求方法：

- GET，请求指定的资源，使用 GET 的请求应该只用于获取数据。
- POST，发送数据给服务器，创建或者更新资源。
- PUT，创建或者替换目标资源。
- PATCH，用于对资源进行部分修改。
- DELETE，删除资源

具体来说，一个接口支持那种请求方式，是由谁说了算？？



**GET 请求和 POST 请求的区别**

|**区别**|**GET**|**POST**|
|-|-|-|
|作用|获取资源|创建资源|
|请求主体|无请求主体|有请求主体|
|幂等性|幂等|非幂等|
|缓存|可以缓存|一般不缓存|
|历史记录和书签|可存放|不可|


> GET 和 POST 都是支持 form 表单的，GET时还是通过 URL 参数传递。

**请求头**

**Content-Type**

请求体

### 1.2.2、HTTP 响应

**响应状态码**

- 1**  信息，服务器收到请求，需要请求者继续执行操作
- 2**  成功，操作被成功接收并处理
- 3**  重定向，需要进一步的操作以完成请求
- 4**  客户端错误，请求包含语法错误或无法完成请求
- 5**  服务器错误，服务器在处理请求的过程中发生了错误



**响应媒体类型**

**响应头**

**Set-Cookie**

```Python
Set-Cookie: id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; Secure; HttpOnly
```

2.3.1https://blog.csdn.net/coderising/article/details/112645885)

### 1.3、接口是怎么实现的

