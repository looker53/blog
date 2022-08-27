---
title: Python自学教程7-字典有哪些常用操作
date: 2022-08-24 21:52:20
permalink: /pages/e797fe/
sidebar: auto
categories:
  - 日记
tags:
  - 
---


Hi，今天我们聊聊字典。



正式开始前，先看一个问题。下面的个人信息，如果想使用Python数据类型表示，应该用什么数据类型呢？

![1659616450030](https://wcflove.gitee.io/images/1659616450030.png)



你会发现，数字、字符串、列表其实表达起来都不是很方便。 字典就比较适合这种场景。



python中的字典类型能很方便的表达多维数据。字典类型利用集合元素的不重复特性作为key与对应的值形成键值对。然后因为集合中的元素都是可哈希，非常方便建立哈希表来做索引查询对应的值。



## Python字典的定义

字典使用一对大括号进行定义，键值对之间使用逗号隔开，键和值使用冒号分隔。



键必须是不可变类型，一般使用字符串，数字，和元组也可以但用的不多。



值可以是任意数据类型。

```python
>>> a = {}      # 空字典
>>> b = {
    'name': '九柄',
    'age': 18,
    'hobby': ['运动', 'meizi'],
    'friends': [
        {'name': '刘德华'},
        {'name': '张学友'}
    ]
}
>>> print(type(a))
< class 'dict' >
>>> print(type(b))
< class 'dict' >
```





## Python字典的常用操作

字典的基本操作分为：增、删、改、查。



- ”查“ 主要是去获取列表的某一个元素或者是多个元素，通过索引和切片可以获取。
- ”增“ 主要是对这个字典当中去添加一个新的元素。
- “删” 主要指我们对字典当中的某元素进行删除。
- “改”主要是这个对这个字典当中的元素去进行修改。



## Python字典的查询

字典通过键作为索引来获取对应的值。

```python
>>> b = {
    'name': '心蓝',
    'age': 18,
    'hobby': ['运动', 'meizi'],
    'friends': [
        {'name': '刘德华'},
        {'name': '张学友'}
    ]
}
>>> print(b['name'])
'心蓝'
>>> print(b['hobby'][-1])
'meizi'
```

这种方式很好的将键和值联系起来，就像查字典一样。



### Python字典是否存在key

如果想判断某个 key 是不是已经存在，可以直接使用 `in` 来判断：

```python
print("name" in b)
```



### Python字典的键可以是列表吗？



关于 Python 字典的键，始终需要注意的是：

- 键不能重复
- 键必须可哈希，更直白一点，键必须是不可变数据类型



列表是可变的数据类型，所以不能作为字典的键。 同样的，字典，集合这一类的可变数据类型都不能作为字典的键。





### Python字典的键可以是元组吗？

元组是不可变的，可以作为字典的键。 



同样的，字符串、整型、浮点数、布尔值都是不可变的，所以都可以作为字典的键。



### Python字典的值允许重复吗

既然字典的键不能重复，那值可以重复吗？



答案是可以的，字典的值几乎不会做任何限制，你可以存储任何的数据类型，任何的数据值。



不同的键对应相同的值，完全是合理的：

```python
a = {
    "my_name": "jiubing",
    "your_name": "jiubing"
}
```



## Python字典取值的几种方法

取值最经典对的方法是通过中括号取值。

```python
>>> d = {'name': '九柄', 'age': 18}
>>> d["name"]
九柄
```



但这种方式有个弊端，当取的 key 不存在时，会报错。 比如我取一个 hobby ，因为不存在，会触发 keyerror 错误。

```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 'keyerror'
```



为了避免这种情况，我比较习惯用 get 方法，当 key 不存在的时候，可以指定一个默认值 None, 不会引发错误。

```python
d = {'name': '九柄', 'age': 18}
d.get("hobby", None)
```



## Python字典添加元素

字典添加元素和修改元素的语法是一样的。

如果键不存在，则添加元素。

```python
>>> d = {'name':'九柄'}
>>> d['age'] = 18
>>> print(d)
{'name': '九柄', 'age': 18}
```



如果键存在则修改字典

```python
>>> d = {'name': '九柄'}
>>> d['name'] = 'jiubing'
>>> print(d)
{'name': 'jiubing'}
```



## Python字典删除元素

- `pop(key[,d])`

删除指定的键对应的值，并返回该值，如果键不存在则返回默认值`d`，如果没有给定`d`，则抛出异常

```python
>>> d = {'name': 'jiubing', 'age': 18}
>>> d.pop('age')
18
>>> print(d)
{'name': 'jiubing'}
>>> d.pop('age')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 'age'
>>> d.pop('age', -1)
-1
```

- `.popitem()`

任意删除字典中的一个键值对，并以二元元组`(key,value)`的形式返回

```python
>>> d = {'name': 'jiubing', 'age': 18}
>>> d.popitem()
('age', 18)
```







## Python字典合并

还可以通过方法`.update(new_dict)`，将`new_dict`合并

```python
>>> d = {'name':'九柄'}
>>> new = {'age':18, 'gender':'男'}
>>> d.update(new)
>>> print(d)
{'name': '九柄', 'age': 18, 'gender': '男'}
```

当有重复key的时候会覆盖

```python
>>> d.update({'sex': '女','height': 170})
>>> print(d)
{'name': 'xinlan', 'age': 18, 'sex': '女', 'height': 170}
```



## Python字典遍历

遍历字典使用 for 循环语法，但是要注意要获取字典的 items() 方法， 通过 items() 可以同时得到键值对，element 是一个元组。

```python
new = {'age':18, 'gender':'男'}
for element in new.items():
    #element是键值对
	print(element)
```



如果一不小心把 items()  落掉了，则只能得到 key:

```python
for element in new:
	#element只有key
	print(element)
```



如果只想获取值，则加上 values()， 快来验证下吧。

```
for element in new.values():
	#element只有value
	print(element)
```







## Python字典排序

Python的 key, value 一般按照先添加，先展示的顺序展示。 如果想对字典排序，就要改变键值对的展示顺序。 下面是一种比较优雅的实现，但用了一些还没讲的内容。

可以为key参数值指定lambda表达式，代码如下：

```python
y1 = {k: v for k, v in sorted(x.items(), 
                              key=lambda item: item[1])} 
print(y1) 
# 按值降序排列 
y2 = {k: v for k, v in sorted(x.items(), 
                              key=lambda item: item[1], reverse=True)} 
print(y2) 
```

这段代码使用了for-in表达式生成了字典，其中x是待排序的字典。items获取了key-value对。而lambda表达式的item就是当前的key-value对。item[0]表示key，item[1]表示value，所以使用item[1]，就表示按value排序，而使用item[0]，就是按key排序。



## 总结

字典的操作是非常丰富的，除了上面讲的内容，还有一些进阶操作比如 setdefaultdict 、默认字典，排序字典，都还没涉及到，后面出专门的文章进行说明。



字典也是面试中经常考察的知识点，准备好对应的面试题，在招聘中能占据主动。 需要面试题的评论区回复“面试”

