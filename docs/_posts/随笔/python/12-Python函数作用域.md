---
title: 12-Python函数作用域
date: 2022-08-26 20:01:11
permalink: /pages/bf77f7/
sidebar: auto
categories:
  - 日记
tags:
  - 
---
## 函数作用域

![https://gitee.com/looker53/pics/raw/master/img//20210514140030.png](https://gitee.com/looker53/pics/raw/master/img//20210514140030.png)
函数外是全局变量
函数内是局部变量
可以使用同一个名称代表不同的数据
局部可以使用全局变量
全局不能获取局部变量（监狱里的烟在外面不是硬通货）

```python
money = 3
def buy_soap():
    print(f"买肥皂需要{money}")

def buy_soap():
    money = "2只烟"
    print(f"买肥皂需要{money}")
```

函数调用另外的函数：

```python
def eat(name, food):
	print("{} 最喜欢吃 {}".format(name, food))

def offer(name, money, food):
	print("恭喜 {} 拿到 {}k offer".format(name, money))

eat(name, food)
offer('yuze', '87', '辣条')
```





内置函数
enumerate
eval
sum
range
max
min
zip
id