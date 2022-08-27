---
title: 10-Python循环语句怎么用
date: 2022-08-26 17:43:29
permalink: /pages/baabda/
sidebar: auto
categories:
  - 日记
tags:
  - 
---


循环是另一种控制流程的方式，一个循环体中的代码在程序中只需要编写一次，但可能会连续运行多次。在 python 中主要包含两种循环结构：

- while 循环，表示满足某种条件是，重复运行一段固定代码。
- for 循环，表示遍历某组数据，每次取出一个，重复运行一段固定代码。



## while 循环
while 循环的语法和 if 条件非常类似：

```
while expression:
	statement1
```


当 expression 条件满足时，执行 statement1 语句， 语句执行完后，会返回第一行继续判断条件是否满足。如果该条件一直保持满足状态，循环语句无法退出，就会出现死循环的状态。

```
while True:
	print("hello, you")
```



为了让程序运行到一定阶段退出循环体，需要改变条件，当条件改变到不满足的状态时，就可以退出循环结构了：

```
times = 0
while times < 1000:
	print(f"hello you {times}")
	times += 1
```


## for 循环

for 循环是一种更加常用的循环结构，主要作用**遍历**一组数据达到循环执行的效果。这组数据通常是字符串，列表，元素，字典等可迭代的数据。

``` python
my_string = 'hello you'
for letter in my_string:
    print(letter)
```


letter 是一个临时变量，表示每一轮循环从 my_string 中取出来的元素，第一轮循环是 `h`, 第二轮循环是 `e` 。临时变量在退出循环结构之后会失效。

```
for letter in my_string:
    print(letter)  # YES

    print(letter)  # NO
```



**遍历列表**

``` python
dalaos = ['小芳', '温暖如初', '小蚊子']
for dalao in dalaos:
    print(dalao)
```



遍历字符串、列表、元组等数据时，可以使用 enumerate 函数同时获取索引和值，经常可以用到。

```
dalaos = ['小芳', '温暖如初', '小蚊子']
for index, item in enumerate(dalaos):
	print(item)
```



**遍历字典**

遍历字典默认是获取 key

```
user = {"name": "小芳", "age": "17"}
for item in user:
	print(item)
```


同时获取 key 和 value 是更常用的做法：

```
for key, item in user.items():
	print(key, item)
```



**range**

range 的作用是生成一个类似于列表的数据，range(6) 生成类似于 [0,1,2,3,4,5] 的数据。当你需要对某段代码循环运行指定次数，但是又没有现成的数据可以遍历时，可以用 range

```
for item in range(10000):
	print(item)
```



range() 的参数类似于切片的写法，当只有一个参数时，表示结束索引号，当有两个参数时，表示开始和结束的索引号，当有3个参数时，增加步长。



``` python

# start, end
for item in range(3,8):
    print(item)

# start, end, step
for item in range(3,8,2):
    print(item)
```


## 循环的嵌套

之前我们了解到， for 循环作用是对一组数据中的不同元素执行相同的操作（代码），如果想对不同的元素进行差异化操作，可以使用 for 循环嵌套 if 的组合。

```
dalaos = ['小芳', '温暖如初', '小蚊子']
for dalao in dalaos:
	if dalao == '小芳':
	print("村里有个姑娘，叫小芳。")
else:
	print("没有你要找的人")
	  
```


对元素分组：

``` python
users = [
    {"name": 'yyz', "age": 18},
    {"name": '小芳', "age":16},
    {"name": 'v', "age": 19},
    {"name": 'w', "age": 20},
]

adult = []
kids = []

for user in users:
    # user =  {"name": 'yyz', "age": 18}
    if user['age'] >= 18:
        adult.append(user)
    else:
        kids.append(user)

        print(adult)
        print(kids)
```


## break

在 while 和 for 的循环体中，都可以使用 break 关键字终止整个循环体的运行。尤其是在和 if 的搭配使用中，当满足某个条件时，就终止整个循环结构。

```
while True:
    username = input("输入用户名")
    paword = input("输入密码")
    if username == 'admin' and paword == '123456':
    	print('login')
    	break
```


## continue

continue 则可以跳过本轮循环，进入下一轮循环。他也常常和 if 搭配使用：

```
songs = ['传奇','', '礼物', '故乡', '']
for song in songs:
	if not song:
	print("下一曲")
	continue
print(f"正在播放：{song}")
```


## 循环的自动化测试实际使用

自动化测试场景：表示多个测试数据



1、写一个程序，存储一个测试数据

```
username = input("请输入用户名:")
pass = input("请输入密码:")
age = input("请输入年龄:")

user = dict()
user.update(username=username,
    pass=pass,
    age=age)
```


2、写一个程序，可以存储多个测试数据

```
users = list()
users.append(user)
print(users)
```


3、添加多个用例，运行多个用例

```python
users = list()
while len(users) < 3:
    username = input("请输入用户名:")
    pass = input("请输入密码:")
    age = input("请输入年龄:")

    user = dict()
    user.update(username=username,
                passd=pass,
                age=age)
    users.append(user)
    print(users)

    for case in users:
        print(f"运行用例-用户名{case['username']}")
```



刚接触循环，可能很难分析出代码接下来会执行哪一行，此时可以在循环体内设置一个断点，通过 debug 模式运行程序，从而理解代码的执行过程。



## 练习题

练习题1：生成 0-100 的奇数怎么写？

练习题2：求出 0-100 的数的和？

练习题3：求出 0-100 的数的奇数和与偶数和

练习题4：生成一个 * 组成的直角三角形

练习题5：把 c 变成一个扁平的列表



```python
while True:
    try:
        n=int(input())
        nums=[int(i) for i in input().split()]
        a = []
        if len(nums)==0:
            print(0)
            for i in nums:
                position = bisect.bisect_left(a, i)#在a中插入i应插入的位置index，排序；若i已存在，则返回左边的位置index
                if len(a)==position:#第一个元素，或者大于a中元素的元素才插入
                    a.append(i)
                else:
                    a[position]=i#否则替换对应index的值
                    print(len(a))
                    except:
                        break
```