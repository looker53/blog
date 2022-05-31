---
title: Appium通过元素坐标点击
date: 2022-05-31 15:12:22
permalink: /pages/8de913/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
# 获取元素坐标点击

有一些元素通过已有的属性不方便定位，则使用坐标定位。

比如我发现一个元素，他的坐标展示如下：

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e4339f3e-ebf0-410d-a766-45d1d3625017/Untitled.png)

那么我可以计算出他的中心坐标：

```java
startx = 792
endx = 900
starty = 49
endy = 137
center_x = (startx + starty) / 2
center_y = (endx + endy) / 2
```

接下来我们就可以用 tap 方法去点击

```java
postions = ((center_x, center_y),)
driver.tap(postions)
```

这种方式目前没有什么问题，但是如果手机像素变化了，这个坐标就会失效，这时候就要用坐标的比例了。比如我们在元素定位时看到的屏幕宽度为 900， 高度为 1600

```java
x = center_x / 900
y = center_y / 1600
```

当到了一个新手机上时，获取新手机的宽度和高度。

```java
width = driver.get_window_rect()['width']
height = driver.get_window_rect()['height']

real_x = x / width
real_y = y / height
```

看一下完整的示例：