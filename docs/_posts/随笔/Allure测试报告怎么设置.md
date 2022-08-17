---
title: Allure测试报告怎么设置
date: 2019-07-15 16:42:11
permalink: /pages/170ed3/
sidebar: auto
categories:
  - 日记
tags:
  - 
---



Allure 测试报告环境搭建

allure 的测试报告是老板喜欢的样子。如果能用上 allure，干嘛还选择其他的测试报告类型呢？python 的 pytest 单元测试框架有 allure 的插件，可以很方便的在 python 自动化测试过程中使用 allure 测试报告。

![image-20220715172101290](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172101290.png)

### 1、Allure 安装依赖

- Java8 +, JDK1.8+
- 下载 allure 安装包
- 配置环境变量
- python 库 pytest-allure

### 2、安装 Java 的 JDK

- 下载 Java 的 [JDK](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)。
  
  *如果安装了 Jenkins, 可以用 Jenkins 的 Java 环境，通常在 Jenkins 安装目录下的 jre/bin 目录下。*

- 在 window 平台下运行

![image-20220715172212394](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172212394.png)

更改并记住安装的路径：

![image-20220715172221951](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172221951.png)

配置环境变量。在我的电脑里界面右击，点击属性，选择高级系统设置：

![image-20220715172231394](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172231394.png)

点击环境变量：

![image-20220715172240379](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172240379.png)

配置环境变量：

![image-20220715172851104](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172851104.png)

cmd 命令判断 sdk 是否安装成功：

![image-20220715172249679](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172249679.png)

### 3、安装 allure

- 下载 allure 安装包：https://github.com/allure-framework/allure2/releases/tag/2.11.0
- 把安装包接下放到想要的安装目录下。
- 配置环境变量。和 Java 一样，把出现 allure 的路径放到环境变量。

![image-20220715172258819](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172258819.png)

cmd 输入命令 allure 判断是否安装成功：

![image-20220715172308507](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172308507.png)

### 4、安装 pytest allure

```
pip install allure-pytest
```

生成测试报告：

```
pytest -s -q --alluredir report/allure/path
```

查看 allure，这一步会开启对应的 allure 服务，可以在浏览器上查看已经生成的测试报告：

```
allure serve report\allure
```

### 5、在 Jenkins 上配置 Allure

- 在 Jenkins 的插件市场安装 Allure 插件；
- 在 Jenkins 全局工具配置中配置 Allure 命令行。

![](https://i.loli.net/2019/03/20/5c91ddcebd584.jpg)

- 项目中配置 Allure 报告路径。

现在 Jenkins 上会多一个 allure 的图标：

![image-20220715172326576](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172326576.png)

构建以后会有历史记录出现：

![image-20220715172335785](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220715172335785.png)

190511
