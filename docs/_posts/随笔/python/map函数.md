---
title: map函数
date: 2020-05-31 15:32:44
permalink: /pages/aa810a/
sidebar: auto
categories:
  - python
tags:
  - python
---
# 

在 python 当中经常会操作列表这样的可迭代对象，如果有多层嵌套列表，操作起来会非常麻烦，用 map 可以让代码可读性增强。

## 什么是 map 函数

map 函数是 python 内置函数，可以根据对列表这样的可迭代类型做进一步操作。在新的 python3 中，map 不再是一个函数，而是一个类，但是还是习惯被称为内置函数，官网也没有更正。所以之后我们还是称为 map 函数。

![https://static01.imgkr.com/temp/515f748ee01a4ba084876e227e982eb8.png](https://static01.imgkr.com/temp/515f748ee01a4ba084876e227e982eb8.png)

728 x 452
1273 x 790

map 函数有 2 个参数，参数 function 表示要对每一个元素进行的操作，参数 iterables 是一个可迭代对象。返回值是经过 function 操作后的新对象， 在 python3 中是一个 map 对象。

(map 函数解释图)

![https://static01.imgkr.com/temp/9a23719ac3ad429fa27c415d648cec50.png](https://static01.imgkr.com/temp/9a23719ac3ad429fa27c415d648cec50.png)

728 x 403
815 x 451

看一个例子：在这个例子中，我们需要对 origin_iterable 这个列表中的每一个元素求绝对值，得到新数据。由于 map 返回值是一个 map 对象，需要转化成 list 才能得到 [1, 3, 5]

```

origin_iterable = [1, -3, -5]
new_iterable = map(abs, origin_iterable)

print(new_iterable)
# <map object at 0x0000020E21D3E910>

print(list(new_iterable)
# [1, 3, 5]

```

除了列表，map 也可以操作元组：

```

origin_iterable = (1, -3, -5)
new_iterable = map(abs, origin_iterable)
print(tuple(new_iterable))

```

也可以操作 set 集合：

```

origin_iterable = {1, -3, -5}
new_iterable = map(abs, origin_iterable)
print(list(new_iterable))

```

可以操作字典，但是操作的是 key ：

```

origin_iterable = {"name": "yuz", "age": 18}
new_iterable = map(str, origin_iterable)
print(list(new_iterable))
# ['name', 'age']

```

## function 参数

map(function, *iterable) 第一个参数 function 是一个任意的函数。如果后面只有一个参数， function 函数接收一个参数。

如果后面有 2 个参数， function 函数则需要接收 2 个参数， 参数是 iterable 当中的元素。

![https://static01.imgkr.com/temp/f2bb00e04a394028adb84c8403413342.png](https://static01.imgkr.com/temp/f2bb00e04a394028adb84c8403413342.png)

728 x 430
771 x 455

```

def add(x, y):
    return x + y

def demo_05():
    origin_iterable_1 = [5, -2, 4]
    origin_iterable_2 = [1, 8, 6]
    new_iterable = map(add, origin_iterable_1, origin_iterable_2)
    print(list(new_iterable))

```

## 对多个数据进行格式转化

现在有一个二维数据需要处理，比如 Excel 中的数据，或者数据库当中的数据。每个数据都是一个对象 Cell， 我想取出其中的值。

```

class Cell:
    def __init__(self, value):
        self.value = value

def demo_06():
    rows = [
        (Cell(1), Cell(2), Cell(3)),
        (Cell(7), Cell(8), Cell(9))
    ]

    new_data = []
    for row in rows:
        new_row = tuple(map(lambda x: x.value, row))
        new_data.append(new_row)
    return new_data
```
