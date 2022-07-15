---
title: Pycharm使用教程：5个非常有用的技巧
date: 2022-07-15 14:26:04
permalink: /pages/b44f03/
sidebar: auto
categories:
  - 日记
tags:
  - 
---
PyCharm 是一款非常强大的编写 python 代码的工具。掌握一些小技巧能成倍的提升写代码的效率，本篇介绍几个经常使用的小技巧。  
  
## 一、分屏展示  
  
当你想同时看到多个文件的时候：  
  
1. 右击标签页；  
2. 选择 move right 或者 split vertical；  
3. 效果。  
 ![image.png](http://testingpai.com/upload/file/2019/ca2dbe94-dad4-4a6c-8bff-b483fb47502c.png)  
  
## 二、远程 Python 解释器  
  
1. 解释器设置里点击设置；  
2. 选择 docker, ssh 等远程解释器。  
  
![image.png](http://testingpai.com/upload/file/2019/5b19f75f-34d3-42a9-b68e-6e88251302d0.gif)  
  
## 三、Live Templates  
  
live templates 主要是偷懒用的，采用事先定义好的模板，一个按键完成一长串的代码输入：  
  
1. 快捷键 `ctrl + j`展示所有的 live template;  
2. 快捷输入各种表达方式;  
3. 输入对应名字的字符时会有相应提示，比如输入 main 可以展示 if...main... 表达式和推导式等。  
 ![image.png](http://testingpai.com/upload/file/2019/67b419d9-6cc1-415c-8219-a05d6ee721d7.gif)  
4. 你可以自定义 Live Templates，定义好了以后，当你输入对应的关键字或者使用 `ctrl + j`就能看到自己定义好的模板直接使用。选择使用场景以后，可以在输入 class 的时候自动提示生成一大段代码块。输入 html 时会输入很多就是使用的 live template。  
 ![image.png](http://testingpai.com/upload/file/2019/70bd2ba5-bdba-47b6-b406-6f6d3a235e32.png)  
  
## 四、代码提示  
  
1. 额外代码提示 coding attentions；  
2. 每种代码都有额外的提示，使用快捷键`alt + enter`可以出现。  
  
比如光标放到字典上，使用快捷键或者点击左侧小黄灯出现额外提示：  

![image.png](http://testingpai.com/upload/file/2019/cd3f429c-0001-4cad-a077-db6dc7c12ba0.png)  
  
- 可以将双引号换成单引号，有时候需要单引号换成双引号，符合 json 转化标准；  
- 也可以将字典表示形式转化成构造器形式：  
- 放到函数上可以添加函数注解和函数的文档字符串。  
- 放到类 class 上可以动态创建 self.name = name  
  
![image.png](http://testingpai.com/upload/file/2019/3d6cfcc8-e7c7-4fac-976a-e3cdd773baf4.gif)  
  
## 五、提取函数 extract method  
  
场景：事先定义了一个函数，后来发现里面很多的步骤都可以封装成各种小方法。可以通过`ctrl + alt + m`动态生成。  
  
```python  
def run(a, b):  
 print("a is {}".format(a)) print("b is {}".format(b))     print(a + b)  
```  
  
希望将第1、2 行封装成一个函数 print_a_b， 第三行封装成另一个函数 sum_a_b：  
  
![image.png](http://testingpai.com/upload/file/2019/409bc67d-b9af-44e2-801a-5efb69982301.gif)