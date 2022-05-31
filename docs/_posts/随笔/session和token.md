---
title: session和token
date: 2022-05-27 17:47:12
permalink: /pages/4bfec3/
sidebar: auto
categories:
  - 日记
tags:
  - 
---
 [toc]

## 什么是 token

在接口的响应结果中，经常会出现类似这样的返回值。

```
{
    "msg": "success",
    "token": "eyJzdWIiOiAieXV6IiwgInJvbGUiOiAiYWRtaW4ifQ"
}
```

往往需要在访问下一个接口时传递 token 数据。

```
curl -X POST -H Authorization:eyJzdWIiOiAieXV6IiwgInJvbGUiOiAiYWRtaW4ifQ <http://127.0.0.1:5000/user>
{"alg": "HS256","typ": "JWT"}
```

所以 token 本质上就是用户信息通过编码转化成另一种形态得到 token, 再通过 token 解码得到用户数据。

![image-20220527174742215](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527174742215.png)

## 无状态

要理解 token 的由来，先得从 HTTP 讲起。HTTP 协议是一种无状态的协议，服务器没有记忆能力，无法记住客户端之前有没有发送过请求，因此客户端每次发送的请求都是独立的。

这会造成一个问题，当客户端必须要登录才能进行的操作，每次请求都要重复发送用户名和密码给服务器进行校验，频繁发送敏感信息会造成很大的安全问题。

![image-20220527174812083](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527174812083.png)

## session

有没有一种方式让服务器记住客户端的（登录）状态呢？session 就是一种很好的方式，当用户登录时，发送用户名和密码之后，服务端会给客户端派生成一个 sessionId，表明这是属于哪一个用户，然后在 sessionId 中存储该用户的数据，比如这个用户之前添加的购物车，这个用户的登录时间等等，这些信息会保存在服务器。

接下来，服务器通过 cookie 的形式把 sessionId 返回给客户端。每次客户端请求该服务器时，会自动带上 sessionId 这个 cookie。 服务器接收到后查询有没有存储这个 sessionId 的信息。

相当于进入某个产业园，保安大叔会把你的信息等级在一个小本子上，比如身份证号等，下次你就拿着这个号码来，保安大叔已核对，在小本子上有登记，你就可以进去了。

![image-20220527174836146](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527174836146.png)

session 会带来几个问题。

第一，session 需要占用很多服务器的资源（要买一个很厚的本子登记）。 服务器针对每个用户都要创建一个 sessionId, 然后在这个 sessionId 对应的存储空间中存储大量数据。 用户每次请求后都需要查询有没有对应的 sessionId，会影响服务器的响应速度，尤其设计到大量数据节点时，还需要同步。

第二，每次都要查询，翻一个很厚的本子，速度很慢，当有太多请求时，很久才能收到响应。（来一个人，保安大叔要翻看上千页的本子核对）

第三，session 通常会和 cookie 搭配，但是 cookie 无法跨域。对于涉及到多个服务的跨域操作，有很大的局限性。 同时，如果涉及到跨域或者多服务器，就需要共享 session，必须保证每台服务器都能获取 session 而且要保持数据同步和一致性（人太多，设置多个保安亭，每个保安亭都要保持数据一致性，还要每天更新离职的和新进来的员工）。

我们可以采取数据库保存 session，像 redis 这样的数据库就比较适合存储 session，但是新的问题又来了。服务器每接收一次请求都需要查询数据库，当访问量太大时会给数据库带来非常大的压力，如果数据库挂了，那服务就直接1无法使用了。

![image-20220527174858612](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527174858612.png)



解决方式是配置 redis 集群，当单点数据库挂掉时，可以使用其他数据库中的数据。集群要做好数据同步，保证每个节点的数据一致性，也要做好负载均衡，尽量不让节点因为负载挂掉。就算其中有节点挂掉了，也不影响服务执行。

![image-20220527174917493](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527174917493.png)

##  Token

虽然最终通过集群管理能解决 session 的问题，但是工程量和成本还是相当高的。

既然服务器处理用户状态这么麻烦，那为什么不放在客户端去存储呢？当用户登录以后，服务器根据用户ID 或者用户名生成一个 userId，然后获取用户数据，比如购物车数据，登录时间等，把这些数据放在 userId 盒子里面，和之前的 sessionId 差不多，只是不在服务器存储了，而是直接丢给客户端。

客户端每次都携带这个关于用户的盒子给服务器，盒子中带有用户的数据。服务器可以直接拿到用户的数据，并不需要再次查询服务器。

相当于保安大叔不需要小本子了，而是直接发给你一个通行证。

(图)

这种方式就是 token 方式。服务器并不存储用户数据，而是直接通过编码或者加密方式把用户数据作为令牌直接返回给客户端，传递的方式由服务端自己设置。 每次客户端都携带这个令牌，证明自己的身份，从而得到自己的状态和数据。

这样，服务器可以节省大量的存储资源，也不需要每次查询，加快了响应速度。而且传递的方式也是由双方协定，不管是不是跨域，都可以正常传递。

![image-20220527174936899](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527174936899.png)



**签名**

这种 token 方式目前还有一个问题：很容易被伪造，任何人都可以宣称自己是某个用户，从而获取该用户的私密信息，必须要想办法证明这个 token 就是由信任的服务器颁发给客户端的。

这个办法就是签名。

当用户登录时，服务器提取用户名或者id 组装成 payload ，代表用户数据，然后用 header 拼接 Payload 组装成新的数据，通过 HS256 这一类的加密算法得到签名。然后再拼接 header, payload和sign，得到token。

![image-20220527175001062](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527175001062.png)

sign 保证了 token 是由服务器签发的，因为只有服务器知道签名的密钥。接下来还是和之前一样，每次访问新的接口，只需要带上这个 token 就可以了。

服务器获取 header 和 payload，使用服务端的密钥得到新的签名，和客户端传过来的 sign 对比，如果一致，表示这是合法的 token, 如果不一致，就是伪造的。









**token注销**

token 还有一个问题是不能主动注销。



**JWT**

在上面的例子中，实际上不需要 Header 也是可以生成 token 防止篡改的。通过 payload 同样可以生成签名，有签名就可以防篡改。

但是现在在 web 开发中，经常会加上 header，使用一种标准的 token 传递规范，就是 JWT(Json Web Token)。

JWT 分为 3 个部分：

- header 头部
- payload 负荷
- signature 签名

他们在网络中作为一个 token 整体传递，传递的格式是：

```
header.payload.signature
```

比如，你看到登陆之后，服务器会返回一串 token 数据，通常类似于这样

![image-20220527174742215](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220527174742215.png)

header 是一个 json 对象，包含了 token 的头部数据，比如签名用的算法，token 的类型：

```
{
  "alg": "HS256",
  "typ": "JWT"
}
```

然后把这个 json 对象通过 base64url 编码成字符串形式。

```
eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0
```

payload 也是一个 json 对象，官方定义的字段有：

- iss (issuer)：签发人
- exp (expiration time)：过期时间
- sub (subject)：主题
- aud (audience)：受众
- nbf (Not Before)：生效时间
- iat (Issued At)：签发时间
- jti (JWT ID)：编号

你也可以自己定义想要的字段，比如用户名，用户角色等

```
{
  "iss": "yuzewang",
  "sub": "login",
  "name": "yuz",
  "admin": true
}
```

通过 base64url 转化成字符串：

```
ewogICJpc3MiOiAieXV6ZXdhbmciLAogICJzdWIiOiAibG9naW4iLAogICJuYW1lIjogInl1eiIsCiAgImFkbWluIjogdHJ1ZQp9
```

sign 签名是计算出来的：

```
hs256(
    base64url_encode(header) + '.' + base64url_encode(payload),
    secet_key
)
```

注脚：

[**1**]    登录接口通过对非敏感的用户数据编码得到 token。

```python
@app.route("/login", methods=['post'])
def login():

    def b64_url(text):
        b64_playload = base64.urlsafe_b64encode(text.encode())
        return b64_playload.decode().strip('=')

    username = request.json.get("username", "")
    pwd = request.json.get("password", "")
    # 查询数据库，是否有这个人
    payload = {"sub": username, "role": "admin"}
    payload = json.dumps(payload)
    b64_url = b64_url(payload)
    return b64_url
```

[**2**]    使用 token 访问其他接口

```
@app.route("/user", methods=['post'])
def user():
    token = request.headers.get('Authorization')

    def decode_b64_url(text):
        padding = (4 - len(text) % 4) %4 * '='
        text_with_padding = text + padding
        b64_playload = base64.urlsafe_b64decode(text_with_padding.encode())
        return b64_playload.decode()

    payload = decode_b64_url(token)
    if 'yuz' in payload:
        return "you get your secret user info"
    return "username is incorrect"
```

2.3.6 附件1：token知识图谱

[token知识图谱.xmind](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/bd8fa88b-c3fd-461b-9e1f-00c565a99bfb/token.xmind)

2.3.7 附件2：返回 token 的服务器代码：

```python
import base64
import json
from flask import Flask, request

app = Flask(__name__)

@app.route("/login", methods=['post'])
def login():

    def encode_b64_url(text):
        b64_playload = base64.urlsafe_b64encode(text.encode())
        return b64_playload.decode().strip('=')

    username = request.json.get("username", "")
    pwd = request.json.get("password", "")
    # 查询数据库，是否有这个人
    payload = {"sub": username, "role": "admin"}
    payload = json.dumps(payload)
    b64_url = encode_b64_url(payload)
    return b64_url

@app.route("/user", methods=['post'])
def user():
    token = request.headers.get('Authorization', '')

    def decode_b64_url(text):
        padding = (4 - len(text) % 4) %4 * '='
        text_with_padding = text + padding
        b64_playload = base64.urlsafe_b64decode(text_with_padding.encode())
        return b64_playload.decode()

    payload = decode_b64_url(token)
    if 'yuz' in payload:
        return "you get your secret user info"
    return "username is incorrect"

if __name__ == '__main__':
    app.run(debug=True)
```



## 参考

- [干掉session,爽死了](https://blog.csdn.net/coderising/article/details/112645885)

- http://www.ruanyifeng.com/blog/2018/07/json_web_token-tutorial.html

- https://jwt.io/introduction

  