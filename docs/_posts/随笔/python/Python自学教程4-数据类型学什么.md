---
title: Python自学教程4-数据类型学什么
date: 2022-08-23 16:58:49
permalink: /pages/39e25b/
sidebar: auto
categories:
  - 日记
tags:
  - 
---
Hi，我是九柄，全网同号，今天我们说说Python的数据类型。



## python数据类型有什么特点

每一门编程语言都要学数据类型的，每种类型的操作会稍微有一点区别。Python是一门非常灵活的编程语言，数据类型的指定和其他编程语言会稍微有一点区别。



首先，Python 不需要显性声明数据的类型，当定义变量的时候，会智能判断变量存储的类型。

```
name = "jiubing"
age = 19
公号 = "九柄"
```



其次，在定义变量时，不需要指定一个数据，这样程序才知道它的数据类型。

```
name    # 错误写法，变量没写数据
```



## Python是强类型的编程语言



你可能经常会听说一门编程语言是强类型还是弱类型，其实你不需要太去深究这个概念，只需要大概知道，强类型语言不能用两个不同类型的数据进行运算就可以了（不是绝对的）。



python 是强类型的，所以运算时，要注意是否同类型。

```
"jiubing"  + 1    #错误写法
"jiubing" * 3   # 但这个是正确的
```



## 数据类型有哪些

Python 里面常用的数据类型有：

- str 字符串
- int 整型
- float  浮点数 
- bool  布尔
- list  列表
- dict  字典
- tuple  元组
- set  集合
- NoneType  空类型



每一个数据类型的表示都有一个小小案例，眼熟就够了，后面每种数据类型都会详细讲。

```
# str
"hello"

# int
3

# float
3.1

# bool
True

# list
[1,2,3]

# dict
{"name": "mingtian"}

# tuple
(1,2)

# set
{1,2,3}

# NoneType
None
```



## 数据类型判断



虽然我们写了这么多数据，但是并不知道在 python 中他们真的数据类型是什么。isinstance() 这个操作可以判断一个数据是否为某个数据类型。 但是 None 不能用这个判断。



```
# str
print(isinstance("hello", str))

# int
print(isinstance(3, int))

# float
print(isinstance(3.1, float))

# bool
print(isinstance(True, bool))

# list
print(isinstance([1,2,3], list))

# dict
print(isinstance({"name": "mingtian"}, dict))

# tuple
print(isinstance((1,2), tuple))

# set
print(isinstance({1,2,3}, set))

# NoneType
print(None is None)
True
True
True
True
True
True
True
True
True
```



有的教程会用 type() 这个操作判断数据类型，但是 isinstance 会更加常用，我个人认为 type 稍微了解就可以了。





## 数据类型转换



几乎所有的数据类型都是可以转化成字符串的，但是反过来则不一定。数据类型转换需要满足特定的规则。



**转化成整型**

```
  # float 转成 int, 去掉小数点
  print(int(1.7))
  
  # bool 转成 int, True 为 1， False 为 0
  print(int(True))
  
  # str 转成 int, 必须是整数格式
  print(int("4"))
  1
  1
  4
```



**转换成浮点数**

```
  # int 转换成 float
  print(float(3))
  
  # bool 转换成 float
  print(float(True))
  
  # str 转成 float, 必须是浮点格式
  print(float("4.6"))
  3.0
  1.0
  4.6
```



**转换成布尔类型**

```
  # int 转换成 bool, 0 为 False, 其他为 True
  print(bool(3))
  print(bool(0))
  
  # float 转换成 bool, 和 int 一样
  print(bool(-1.2))
  
  # str 转成 bool, "" 为 False, 其他为 True
  print(bool(""))
  print(bool("ab"))
  
  # tuple 转成 bool, 空为 False
  # list 转成 bool, 空为 False
  # dict 转成 bool, 空为 False
  # set 转成 bool, 空为 False
  print(bool([]))
  True
  False
  True
  False
  True
  False
```



**转换成列表**

一般是容器类型才能相互完成转换。

```
  # str -> list ，拆分字符
  print(list("没那么简单"))
  
  # dict -> list ，得到所有的 key
  print(list({"name": "mingtian"}))
  ['没', '那', '么', '简', '单']
  ['name']
```



**转换成字典**

首先原类型是一个序列，序列当中的每个元素需要包含两个元素，作为键值对。

```
  origin = [("name","mingtian"), ("age", "19")]
  print(dict(origin))
  {'name': 'mingtian', 'age': '19'}
```



## 可变数据类型和不可变类型

每一个数据都会存在电脑内存当中某个位置， 有的数据定义好了之后，可以修改，而有的数据类型则不能被修改。 数据类型可变性直接决定了以后的操作，如果不深入理解，代码经常会出问题。



而现在只需要大概了解，后面再深入讲解。



Python 的可变类型：

- 列表
- 字典
- 集合



Python 的不可变类型：

- 字符串
- 整型
- 浮点数
- 布尔
- 元组



## 数据类型学什么

总体上来说，看到一个数据，能马上能识别它是什么类型就可以了。 随后，就可以根据不同的数据类型执行对应的操作。 必要的时候，还需要对数据类型进行转换。



数据类型中，列表、字典、元组经常会在面试题中出现，在面试之前需要额外留意，我整理的面试八股文中就有很多这样的题，可以在文章末尾拿到。

![image.png](https://s2.loli.net/2022/08/23/PhsueMI98YcEoiA.png)



数据类型还有很多非常详细的操作，尤其是字符串、列表、字典需要使用非常多，需要仔细掌握。



我是九柄，下期见啦。