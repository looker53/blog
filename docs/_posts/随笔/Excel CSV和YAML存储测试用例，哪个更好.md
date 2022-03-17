---
title: Excel CSV和YAML存储测试用例，哪个更好
date: 2022-03-09 18:57:28
permalink: /pages/269eba/
sidebar: auto
categories:
  - 测试
tags:
  - python
---
在实现自动化测试的时候，我们经常会使用数据驱动。所以我们经常会把测试数据单独保存在一个特定格式的文件当中，然后通过读取文件去驱动自动化测试代码。



这篇文章会对比excel、csv 和 yaml三种主流的文件格式，看看它们哪个更好。



## 1. 先来看用的最多的Excel



excel是世界上使用最广泛的数据文件格式。使用python做自动化测试，可以用openpyxl这个第三方库操作excel。



经常有人说 Excel的操作限制很多，写入和读取的速度很慢。真的是这样吗？



我们做个实验。创建一个空的Excel文件，然后插入1000条数据，看插入数据和读取这些数据会耗费多久的时间。



```python
import openpyxl
def test_insert_1000_lines_data():
    lines = 1000
    workbook = openpyxl.Workbook()
    worksheet = workbook.create_sheet('demo')
    for i in range(lines):
        data = (i, f'name{i}', f'http://www.example.com/{i}')
        worksheet.append(data)
    workbook.save('1000lines.xlsx')
    
def test_read_1000_lines_data():
    workbook = openpyxl.load_workbook('1000lines.xlsx')
    worksheet = workbook['demo']
    for row in worksheet.values:
        pass
```



插入1000条数据会消耗多少时间呢？答案是0.09秒，速度并不慢。而读取这1000条测试数据消耗的时间，只需要0.06秒。





在一个项目当中，1000个测试用例应该是比较合理的，所以在正常的测试场景下，使用excel管理用例数据在读取效率上是合适的。



但是当数据变得越来越大的时候，Excel的处理速度会越来越慢，读取数据消耗了7秒。这就意味着如果你有多个项目需要同时测试，excel的解析可能会对测试效率造成一定的影响。

|          | 1000行 | 5万行 | 10万行 |
| -------- | ------ | ----- | ------ |
| 插入时间 | 0.09s  | 3.75s | 7.44s  |
| 读取时间 | 0.07s  | 3.45s | 7.1s   |



## 2. 再看 csv 格式



不论是进行自动化测试还是进行数据分析，csv格式都更加合适。这种格式不像Excel，要去处理表格的样式，它更专注于数据。



而且在Python语言当中，内置了csv格式的处理模块，用法非常简单，没有太多额外的学习成本。

```python
import csv
def test_insert_1000_lines_data():
    lines = 1000
    with open('1000lines.csv', 'w', newline='') as f:
        csv_writer = csv.writer(f)
        for i in range(lines):
            data = (i, f'name{i}', f'http://www.example.com/{i}')
            csv_writer.writerow(data)
            
def test_read_1000_lines_data():
    with open('1000lines.csv', newline='') as f:
        csv_reader = csv.reader(f)
        for row in csv_reader:
            print(row)
```





分别对1000行、5万行和10万行数据进行插入和读取操作，csv 的速度都比excel要快一个量级。

|          | 1000行 | 5万行 | 10万行 |
| -------- | ------ | ----- | ------ |
| 插入时间 | 0.08s  | 0.09s | 0.17s  |
| 读取时间 | 0.02s  | 0.04s | 0.09s  |



对于海量数据处理，csv 比 excel 要快很多，代码编写也更简单。但是，使用csv格式一定要注意对逗号的处理。在csv当中，每一行的数据默认是用逗号分割的，如果你有一个数据当中本身就包含了逗号，一定要记得把这个数据用双引号包裹。



而且，csv 支持的数据格式非常有限，数据被读取出来后都被当成字符串，需要自己添加额外的解析操作。



```plain
id,17,18,"{'name': 'yuz', 'age': 11}"
```



## 3. 最后，我们来看看 yaml 的表现



yaml 的优点在于丰富的数据类型支持。无论是元组、字典、数字、布尔类型都能支持，并且被 python 语言轻松解析成对应的 python 数据类型。



```python
import yaml

def test_insert_1000_lines_data():
    lines = 1000
    with open('1000lines.yaml', 'w') as f:
        all_data = [{"id": i,
                     "name": f"name{i}",
                     "data": {"username": "yuz", "passoword": 123456}}
                    for i in range(lines)]
        yaml.safe_dump(all_data, f)
        
def test_read_1000_lines_data():
    with open('1000lines.yaml',
              encoding='utf-8') as f:
        data = yaml.load(f, Loader=yaml.SafeLoader)
```



在少量数据的解析上，yaml 会非常的方便。但是一旦数据增加到上万组，yaml的解析速度会非常非常慢。当数据达到10万行的时候，读取速度竟然接近 1 分钟。

|          | 1000行 | 5万行  | 10万行 |
| -------- | ------ | ------ | ------ |
| 插入时间 | 0.27s  | 14.79s | 31.78s |
| 读取时间 | 0.47s  | 26.8s  | 53.63s |



最近有越来越多的自动化测试人员使用yaml存储用例，一方面是看重了它支持的丰富的数据格式，另一方面可能是受了一些框架的影响。



httprunner这个接口自动化测试框架就采用了yaml存储用例数据。其实当存在海量数据需要读取的时候，yaml 的处理速度比Excel慢一个量级。所以httprunner 这样的框架，从测试效率这个维度来讲，更适合做单用例或者少量用例的测试。**如果想针对整个项目甚至是多个项目一次性测试的话，httprunner 的执行速度会比较慢。**



通过对Excel、csv和 yaml 三种格式的操作效率对比可以得出以下结论。

1. 如果你只想对少量的用例进行测试，或者对测试数据的格式要较高的要求，用yaml存储用例数据会更利于解析，但是这种场景下一般可以直接使用 postman 这些成熟的工具，没有必要自己实现。



1. 如果你已经习惯了Excel的操作。直接使用这种方式就可以了，1万行以下的数据， Excel还是非常快的。



1. 不管怎么样，我还是更推荐大家去尝试一下csv这种格式。首先、就算是到了10万行数据的情况下，它的处理速度也是非常快的。其次，Python语言当中直接内置了csv的模块，它的使用方式和 open.函数非常的相似，几乎没有额外的学习成本。

