---
title: 09-Python条件语句怎么用
date: 2022-08-26 17:31:42
permalink: /pages/d5db80/
sidebar: auto
categories:
  - 日记
tags:
  - 
---
## if 条件语句

python 语句是按固定顺序执行的，先执行前面的语句，再执行后面的语句。如果你像要程序按照你自己定制的流程执行，就需要用到流程控制的语句，最主要用到的是条件语句和循环语句。

  

条件语句用 if 表示，它表示当满足某个条件时，执行下面的分支代码。当条件不满足时，则跳过下面的分支代码。

![image-20210907141048465](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210907141048465.png)

  

在互联网产品中，你经常能看到条件判断的场景。比如在一个 app 的登录页面中，输入用户名和密码后，程序会判断用户名和密码是否正确，如果正确，则运行用户进入登录状态。如果错误，则必须重新输入。



对应的伪代码为：

```
if 用户名和密码正确:
  	登录成功
else:
  	重新输入用户名和密码
```

  

if 语句的语法可以表示为：

```
if expression:
  	statement1
else:
  	statement2
```



当 expresssion 这个表达式为 True，表示条件满足，statement1 会执行；当 expression 表达式结果为 False，则跳到 statement2 执行。 else 表示在一个 if 语句中上面所有的条件均不满足时，会执行的分支。当你确定 else 时你不需要做任何事，可以省略 else：

```
if expression:
  	statement1
```

  

这里需要注意一点，在 python 中遇到冒号`:` 时，新的一行要缩进，表示子句。如果没有新行，而是直接把语句跟在后面，则不需要缩进：

```
if expression: statement1
```

  

举个例子来说明一下 if 语句的用法。当学生考试成绩高于 80 分，表示良好，否则表示一般。

```
score = 88
if score > 80:
  	print("良好")
else:
  	print("一般")
```

  

有时候一个 if 语句中会有多个条件判断，可以使用 elif 来分隔每一组条件。

```
score = 70
if score > 80:
  	print("良好")
elif 60 < score <= 80:
  	print("还行")
else:
  	print("不及格")
```

  

在同一个 if 语句中，只有第一个率先满足条件的分支会执行，其他的分支不会执行。在上面的例子中，学生得了 70 分，第二个条件表达式率先满足，则走第二个分支。 而在下面的例子中，如果多个条件的范围有重合，会打印什么呢？

```
score = 70
if score > 60:
  	print("不错哦")
elif 60 < score <= 80:
  	print("还好")
else:
  	print("不及格")
```

因为第一个条件率先满足，所以直接执行第一个分支，其他的分支都不再执行。

  

多个 if 表达式需要独立判断:

```
score = 70
if score > 60:
  	print("不错哦")
if 60 < score <= 80:
  	print("还好")
else:
  	print("不及格")
```

在这个例子中，有 2 个 if 表达式，第一个不会影响第二个的执行。。

  

## 条件语句嵌套

在一个 if 语句中可以嵌套另一个 if 语句，像俄罗斯套娃一样。它表示在满足外层 if 条件后，可以执行里面的 if 语句。但是通常提早结束 if 语句，因为当条件语句嵌套很多层之后，会影响代码的可读性。

```python
score = 88
age = 1

if score > 80:
	print("良好")
if age < 6:
	print("神童")
else:
	print("一般")
```


## 你可能不知道的条件操作

在程序当中，经常需要判断一个字符串是否为空，最常使用的方式是：

```
a = ''
if not a:
  	print("字符串为空")
  
if a:
  	print("字符串不为空")
```

  

不管是字符串也好，还是列表、字典、集合，都可以使用同样的方式判断他们是否为空。当然你也可以使用下面的方式，但是这些都不是好的做法。

```
if a == '':
  	print("字符串为空")
if len(a) == 0:
  	print("字符串为空")
```

  

判断是否为 None， 用 is 判断：

```
if a is None:
  	print("a 为 None")
```

  

判断是否为 0：

```
if a == 0:
  	print("a 为 0")
```

  

## python条件判断语句案例



```python
name = ''
password = ''
if name == 'admin' and password == '123456':
  	print("登录成功")
else:
  	print("登录失败")
```

