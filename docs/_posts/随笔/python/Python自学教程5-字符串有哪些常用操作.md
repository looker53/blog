---
title: Python自学教程5-字符串有哪些常用操作
date: 2022-08-24 15:22:57
permalink: /pages/ebd260/
sidebar: auto
categories:
  - 日记
tags:
  - 
---


任何编程语言，不管是Python、Java 还是 Golang， 字符串都是最重要的一种数据类型。 但是字符串的操作又很多，初学者经常毫无头绪，不知道从哪儿学起，也不知道哪些操作用得多，今天九柄就和你来扒一扒Python当中，怎么使用字符串比较合适。



## 字符串是什么

可以说，你在世界上看到的任意文字都将以字符串的形式展示，任何数据和内容也都可以用字符串表示，为了方便，我们就把字符串称为文字吧。



在 Python 中表示字符串有很多形式。在数据左右两边加一对引号，可以是单引号，双引号和三引号。引号是英文半角，全角会报错。

``` python
  # 双引号
  a = "jiubing"
  
  # 单引号
  a = 'jiubing'
  
  # 三引号
  a = '''jiubing'''
  a = """jiubing"""
  
  # 全角 Error
  a = ‘jiubing’
```

  

三引号既可以表示字符串，又可以表示注释。它们的区别在于是否使用变量存储，没有存储的字符串，无法复用，就是注释。

  

## 字符串如何获取某个字符

从字面上看，字符串是用字符串起来的，和羊肉串、牛肉串差不多，在吃羊肉串的时候，有的人习惯一口一串，从签子底部用嘴一划，所有的肉都被收进嘴里， 而我看到一些女生，吃羊肉串非常斯文， 她会先用筷子把一块肉挑到碗里再吃。



字符串也可以一个个字符的取，大多数情况下，都可以使用索引方式得到某个单一字符。索引的作用是取出一个字符，索引从0开始

``` python
  man = "kang li"
  print(man[1]) #a
  print(man[0]) #k
```

  

索引可以是负数，表示倒数第几个，也就是从字符串的右边数到左边。索引为 -1 表示获取倒数第一个字符，索引为 -2 表示获取倒数第二个字符。为什么正序数的索引从 0 开始，倒序就不能从 0 开始呢？因为索引为 0 不能同时表示两个字符，会造成指令的冲突。

``` python
  print(man[-1]) #i
```

  

超出索引范围报 IndexError 错误

``` python
  print(man[8])
```

  

  

## 字符串截取

索引一次只能获取一个字符，切片可以一次获取多个。如果想获取字符串的某些子串，可以通过切片实现。切片的表示方法是：`var[start: end]`。 start 表示开始位置的索引号，end 表示结束位置的索引号， 但是不包含 end。

``` python
  girl = "Smile沫沫"
  part_of_girl = girl[0:1]
  print(part_of_girl)  # S
```

  

切片的索引号也可以是负数，但是在使用的时候要确保 end 是在 start 的右边，end - start > 0 。

``` python
  girl = "Smile沫沫"
  print(girl[0: -2])  # Smile
  print(girl[-2: -4])  # 空字符串，取不到字符
```

  

切片的索引号超出范围是不会报错的，取到尽头为止。

``` python
  girl = "Smile沫沫"
  print(girl[0:100000000000])
```

  

切片的 start 和 end 都可以省略。

``` python
  girl[1:]
  girl[:-1]
  girl[:]
```

  

切片可以加第三个参数， `girl[start:end:step]`, 其实使用切片时，默认的步长是为 1。

``` python
  girl[0:3:2]
```

  



## 字符串逆序输出

步长为 -1，表示从后面往前面数，girl[::-1]， 反转字符串。

``` python
  girl[::-1]
```

  

## 获取字符串长度

```
  len(girl)
```

  

## 字符串格式化

格式化相当于一个模板，模板中有些空位需要动态的填入数据。

![image-20210903164914851](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903164914851.png)

``` python
  from_name = '张三'
  title = '学费'
  money = 500
  to_name = '李四'
  
  info = f"""
  今天收到 {from_name}
  交   来 {title}
  人民币   {money} 元
  收款人   {to_name}
  """
```

  

更高级的字符串模板可以使用 template, 它主要防止用户输入对程序安全造成影响。 一般我们在web开发中的模板渲染就是基于这种技术。



## 字符串分割

split 通过某个分隔符分割字符串，分割后得到一个列表。 如果没有指定分隔符，则把整个字符串作为唯一的元素存放到列表中。

``` python
  girls = 'Lucy-Monic-Jessy'
  girl_list = girls.split('-')
  print(girl_list) # ['Lucy', 'Monic', 'Jessy']
  
  girl_list = girls.split()
  print(girl_list) # ['Lucy-Monic-Jessy']
```

  



## 字符串拼接

join 方法是 split 的反向应用，它可以把一个列表通过特定的连接符组成一个字符串。

``` python
  a = ['hello', 'world']
  b = "".join(a)
  print(b)
```

  



## 字符串查找

通常，可以使用 find 或者 index 来查找简单的字符：

```python
a = "hello world"
a.find("he")
```



但是如果涉及到复杂的匹配规则，一般会用正则表达式。



## 字符串匹配

正则表达式非常枯燥，在没有具体的实战场景前，建议不用花太多时间提前了解，不然时间花了，没几天又忘得一干二净。这里简单写一个匹配规则， 表示匹配一个数字。

```
import re
string = "ayu7o99"
re.search("\d", string)
```



## 字符串替换

replace 替换某个子串。但是原来的数据是不会发生变化的，而是把替换后的字符串用新的变量表示。

``` python
  a = "Soul 小芳"
  b = a.replace("Soul", "灵魂歌手")
  print(b) # 灵魂歌手 小芳
  print(a) # Soul 小芳
```

  



## 字符串删除某个字符

字符串是不可变的数据类型，并不能真的把某个字符删除，但是我们可以使用 replace 方法间接实现，把指定的字符串替换成空字符串。

```
 a = "Soul 小芳"
 # 去掉 ou
 b = a.replace('ou', '')
```



## 自动化测试场景

1、使用 string 表示测试用例

```
  username = 'jiubing1'
  password = '123456'
  age = 18
  
  print("用户名", username)
  print("密码", username)
  print("年龄", username)
```

2、去掉 username 的空格

```
  username = 'jiubing1'
  first, last= username.split(' ')
  username = ''.join([first, last])
```

3、格式化输出

```
  user = f"""
  -------------------------
  用户名：{username}
  密码：{password}
  年龄：{age}
  -------------------------
  """
```

4、通过 input 打印出测试用例（模拟前端页面）

5、访问网址拼接

```
  url = '<http://xxx.com/register>'
  full_url = f'{url}?username={username}&password={password}&age={age}'
```

6、通过网址获取所有参数(后面的内容)

```
  url, params = full_url.split('?')
  info = dict()
  for param in params.split('&'):
  key, value = param.split('=')
  info.update({key:value})
  print(info)
```



我是九柄，全网同号，下次再聊。