---
title: yaml存储测试用例数据实践
date: 2022-06-16 14:58:35
permalink: /pages/6ca587/
sidebar: auto
categories:
  - 日记
tags:
  - 测试
---


yaml 文件可以一次存储多个用例：
```yaml
title: 登录成功
desc: 登录成功用
request:
  url: /adminLogin
  method: POST
  headers: {"XXX": "AAA"}
  json:
    principal: student,
    credentials: 123456a,
    imageCode: lemon
assertions: []
---
title: 登录失败
desc: 登录成功用
request:
  url: /adminLogin
  method: POST
  headers: { "XXX": "AAA" }
  json:
    principal: studen,
    credentials: 123456,
    imageCode: lemon
assertions: []
---
title: 登录未知
desc: 登录成功用
request:
  url: /adminLogin
  method: POST
  headers: { "XXX": "AAA" }
  json:
    principal: f,
    credentials: 1,
    imageCode: lemon
assertions: []

```

读取 yaml文件数据放到用例中：
```python
class AdminLoginTest(unittest.TestCase):   
    with open('login.case.yaml', encoding='utf-8') as f:
        items = list(yaml.safe_load_all(f))

    @ddt.data(*items)
    def test_admin_login(self, item):
        item = item['request']
        data = item['json']
        headers = item['headers']
        response = requests.request(method='post',
                                    url=Config.HOST + item['url'] ,
                                    json=data,
                                    headers=headers)
        print(response.json())
```

## TODO:

- 读取环境变量   env: 
- 使用环境变量 $env()
- 使用参数 $varible
- 使用 hook $mobile()
