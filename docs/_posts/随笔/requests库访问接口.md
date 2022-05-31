---
title: requests库访问接口
date: 2022-05-31 14:57:25
permalink: /pages/75db6a/
sidebar: auto
categories:
  - 测试
tags:
  - 接口
---

### 安装

```Python
pip install requests
```

### 发送请求

发送 GET 请求

```Python
url = '<http://httpbin.org/get>'
resp = requests.get(url )
```

发送 POST 请求

```Python
url = '<http://httpbin.org/post>'
resp = requests.post(url)
```

指定请求方法

```Python
url = '<http://httpbin.org/post>'
resp = requests.request(method='post', url=url)
```

### 传输参数

GET 和 POST 都可以传递 URL 参数

```Python
params = {"page": 3}
requests.get(url, params=params)
```

POST 通过 multipart/form-data 传递参数，GET 请求不可以

```Python
data = {"username": "yuz", "password": "123456"}
requests.post(url, data=data)
```

POST 通过 json 传递参数，GET 请求不可以

```Python
data = {"username": "yuz", "password": "123456"}
requests.post(url, json=data)
```

### 获取响应

**获取文本**

```Python
resp.text
```

**获取 json**

```Python
resp.json()
```

**获取二进制数据**

```Python
resp.content
```

**它们之间的关系**

![image-20210903204804518](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903204804518.png)

### 鉴权

**session 鉴权**

课堂派中就是使用这种方式，登录后获取用户信息不需要手工添加其他的参数了。

![image-20210903204843066](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903204843066.png)

```Python
def login_with_session():
    s = requests.Session()
    login_url = 'https://v4.ketangpai.com/UserApi/login'
    data = {
        "email": "wagyu2016@163.com",
        "password": "admin123456",
        "remember": "0"
    }
    s.post(login_url, data)

    user_url = 'https://v4.ketangpai.com/UserApi/getUserInfo'
    r = s.get(user_url)
    print(r.text)
```

也可以手工添加 cookie：

```Python
def login():
    url = 'https://v4.ketangpai.com/UserApi/login'
    data = {
        "email": "wagyu2016@163.com",
        "password": "admin123456",
        "remember": "0"
    }
    r = requests.post(url, data)
    sid = r.cookies.get('PHPSESSID')

    url = '<https://v4.ketangpai.com/UserApi/getUserInfo>'
    r = requests.get(url, cookies={'PHPSESSID': sid})
    print(r.text)
```

**token**

```Python
def login():
    url = 'http://api.lemonban.com/futureloan/member/login'
    headers = {
        "X-Lemonban-Media-Type": "lemonban.v2"
    }
    data = {
        "mobile_phone": "18111112222",
        "pwd": "12345678"
    }
    r = requests.post(url, json=data, headers=headers)
    content = r.json()

    member_id = content['data']['id']
    token_type = content['data']['token_info']['token_type']
    token = content['data']['token_info']['token']

    url = f'<http://api.lemonban.com/futureloan/member/{member_id}/info>'
    headers = {
        'Authorization': token_type + ' ' + token,
        "X-Lemonban-Media-Type": "lemonban.v2"
    }
    r = requests.get(url, headers=headers)
    print(r.text)
```

### 扩展

- xml 格式数据请求和响应解析（application/xml）

