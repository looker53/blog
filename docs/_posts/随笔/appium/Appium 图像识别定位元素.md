---
title: Appium 图像识别定位元素
date: 2022-05-31 15:17:53
permalink: /pages/d37d2f/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
# Appium 图像识别元素定位

# 安装 opencv

下载地址：[https://opencv.org/releases/](https://opencv.org/releases/)

配置环境变量

- `OPENCV_BIN_DIR`: `C:\tools\opencv\build\x64\vc15\bin`
- `OPENCV_INCLUDE_DIR`: `C:\tools\opencv\build\include`
- `OPENCV_LIB_DIR`: `C:\tools\opencv\build\x64\vc15\lib`
- `Path`中新建: `%OPENCV_BIN_DIR%`

# 安装 opencv4nodejs

1、取消自己构建

`set OPENCV4NODEJS_DISABLE_AUTOBUILD=1`

2、安装

```
npm i opencv4nodejs
```

# 运行 appium

```
appium --use-plugins images
```

[https://www.ruiqima.com/zh/posts/appiumposts/install-opencv4nodejs/](https://www.ruiqima.com/zh/posts/appiumposts/install-opencv4nodejs/)

[http://testingpai.com/article/1597824416789](http://testingpai.com/article/1597824416789)