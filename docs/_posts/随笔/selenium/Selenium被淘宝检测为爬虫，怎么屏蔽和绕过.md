---
title: Selenium被淘宝检测为爬虫，怎么屏蔽和绕过
date: 2022-03-17 18:57:01
permalink: /pages/8b6b56/
sidebar: auto
categories:
  - 测试
tags:
  - selenium
---


## Selenium 操作被屏蔽

使用selenium自动化网页时，有一定的概率会被目标网站识别，一旦被检测到，目标网站会拦截该客户端做出的网页操作。



比如淘宝和大众点评的登录页，当手工打开浏览器，输入用户名和密码时，是能正常进入首页的，但是如果是通过selenium打开， 会直接提示验证失败，点击框体重试。

![image-20220319154742804](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220319154742804.png)



本文介绍一种办法，不需要修改浏览器属性，不需要注入JavaScript脚本，也能轻松绕过网站检测。



## Selenium为何会被检测

每一个浏览器访问网站时，都会带上特定的指纹特征，网站会解析这些特征，从而判断这次访问是不是自动化程序。



一个最广为人知的特征是`window.navigator.webdriver`，该特征直接标明此浏览器是webdriver程序。当一个浏览器通过selenium启动后，在开发者工具中输入这个属性，会发现被标为 true， 而手工打开的浏览器是 false。

![image-20220319155653945](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220319155653945.png)



实际上，浏览器被检测为webdriver程序的特征并不止这一个，这意味着，就算你通过修改属性，也不一定能绕过网站的检测。



我们可以通过 [sannysoft](https://bot.sannysoft.com/) 来检测浏览器指纹，如果浏览器是通过selenium等自动化程序打开的，访问这个网址后会有很多特征暴露这些指纹，这些特征的值和手工打开后的值是不一样的，因此可以很轻易被别人检测出来。

![image-20220319160323829](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220319160323829.png)

![image-20220319160459845](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220319160459845.png)



有人也试图不用selenium，换成puppeter和playwright这样的自动化工具，但是结局都是一样的。



## Selenium避免被检测方法

浏览器在启动时就会带上指纹特征，如果使用自动化程序启动时已经被标记，那为什么不直接用手工启动，然后用Selenium连接已经启动的浏览器呢？



那手工打开浏览器要做什么操作才能让Selenium连接呢？Selenium又是怎样连接手工打开的浏览器呢？



我在 [Selenium连接已存在的浏览器1](https://www.jiubing.site/pages/c62e69/) 这篇文章详细记录了需要的步骤，概括起来：

1、打开浏览器时添加以下参数：

```
--remote-debugging-port=9222 --user-data-dir="C:\selenium\ChromeProfile"
```



2、selenium中设置浏览器选项，通过上面设置的 9222端口连接浏览器：

```python
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
chrome_options.add_experimental_option("debuggerAddress", "127.0.0.1:9222")
driver = webdriver.Chrome(options=chrome_options)
```



## 通过 subprocess 运行浏览器

当然，做自动化程序一般不会手工点击图标来打开浏览器，我们可以用命令行启动浏览器，然后再用 selenium 连接。

```python
import subprocess
cmd = '"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" ' \
'--remote-debugging-port=9222 ' \
'--user-data-dir="C:\selenium\ChromeProfile"'

subprocess.run(cmd)
```

