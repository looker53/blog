---
title: Appium环境搭建保姆级教程
date: 2022-03-22 16:30:29
permalink: /pages/7baea1/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
APP自动化测试运行环境比较复杂，稍微不注意安装就会失败。我见过不少朋友，装了1个星期，Appium 的运行环境还没有搭好的。

搭建环境本身不是一个有难度的工作，但是 Appium 安装过程中确实存在不少隐藏的比较深的坑，如果一不小心踩中了其中的一个，那可能会花费比较长的时间来解决。

今天出一个 Appium 安装的详细教程，只要你照着这个做，并且注意我标出来的每一个注意事项，就可以轻松地装好 Appium 运行环境。

我们以安卓自动化测试环境为例，APP自动化测试需要安装的环境主要有以下几个：

- Appium 服务；
- Appium 客户端；
- Java JDK
-  Android SDK
- 手机

<a name="P38g0"></a>
## 一、安装 Appium 服务

Appium 服务安装有 2 中形式：带 GUI 界面版和命令行版本。界面版和命令行版在功能上没什么区别，只是它带了操作界面，可以让你比较方便的填写Appium运行的参数。

直接找到 [Appium GitHub下载地址](https://github.com/appium/appium-desktop/releases)，选择操作系统的版本。如果你的操作系统是windows，那你就直接选择 windows的安装包，如果你的操作系统是MAC就选择对应的MAC安装包。因为我的电脑是windows系统，所以就以windows来演示吧的。GitHub 在国内的下载速度比较慢，可能需要等几个小时，如果你没有「快速访问GitHub」的条件，**可以直接私信我，我把我本地的安装包发给你**。<br />
![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135416.png)



安装包下载完成之后，我们直接点击安装，这儿需要注意一个问题，在安装的时候选择**只给本人安装，而不要选择 All Users**，否则后面可能你会因为权限的问题而导致APP的运行失败。

安装完成之后，我们直接打开对应的Appium图标，然后点击开启服务。此时APP会监听一个本地的端口，默认是 4723 端口，你可以自己修改成其他没有被占用的端口号。等有新的操作指令进来之后，Appium服务会转发这些操作指令到连接的手机。<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135430.png)


命令行版本的 Appium 首先需要安装 Node.js 的运行环境，直接打开 [Node.js官网](https://nodejs.org/zh-cn/)下载 LTS 长期支持版。下载完成后，指定目录安装，并且记住安装路径，把 Node.js 的执行路径设置到电脑的环境变量 Path 中。<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135446.png)


在配置好 Path 环境变量后，接下来使用 Node.js 的包管理工具 npm 安装 Appium 命令行工具。 npm 不需要单独安装，装好 Node.js 之后，可以直接使用。
```bash
npm install -g appium
```

Appium 安装完成之后，我们可以直接在命令行当中输入`appium`启动服务。命令行提供了很多运行参数，可以使用 -p 修改服务监听的端口，也可以将运行日志保存到指定的文件路径可以直接通过 --help 获取每一个命令行参数的说明。
```bash
C:\Users\jiubing>appium -p 4444
[Appium] Welcome to Appium v1.22.0
[Appium] Non-default server args:
[Appium]   port: 4444
[Appium] Appium REST http interface listener started on 0.0.0.0:4444
```

<a name="fVEbG"></a>
## 二、安装 Appium 客户端

Appium 客户端安装相对来说比较简单，它支持主流的编程语言，我目前用的是Python语言，所以我们直接安装 Python的客户端，打开命令行工具，使用 Python 的包管理工具完成 Appium 客户端的安装。
```bash
pip install Appium-Python-Client
```

<a name="sfUBD"></a>
## 三、安装 Java JDK

Appium 需要 Java 8 以上的开发环境，我们在 [Oralce 官网](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)能直接下载到，最新的版本是 8u202。由于网络影响，你可能无法正常进入oracle官网下载，那么你可以选择通过国内镜像下载也是可以的，我经常会通过[华为镜像](https://mirrors.huaweicloud.com/java/jdk/8u202-b08/)地址下载，下载后点击安装，设置好安装路径。<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135500.png)


JDK 下载安装好后，同样需要配置环境变量。打开环境变量设置窗口，开始菜单 -> 右键计算机 -> 系统属性 -> 高级系统设置 -> 高级  -> 环境变量。<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135529.png)


点击新建，变量名填 JAVA_HOME， 变量值是 JDK 的安装目录。在弹出框中变量值填写 JDK 安装的根目录，即上面记录下来的 C:\Program Files\Java\jdk1.8.0_141)，如下图示：<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135544.png)


在系统变量找到 Path 变量，点击新建，增加配置 `%JAVA_HOME%\bin`，点击确认，重启电脑，让环境变量生效。<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135556.png)


打开 Windows 的 cmd 窗口，输入 Java 命令查看是否正确安装。 如果安装没问题，会显示正常的版本，否则会提示错误。
```bash
C:\Users\jiubing>java -version
java version "1.8.0_301"
Java(TM) SE Runtime Environment (build 1.8.0_301-b09)
Java HotSpot(TM) 64-Bit Server VM (build 25.301-b09, mixed mode)
```

<a name="B2Ezy"></a>
## 四、安装 Android SDK

目前安卓的运行环境主要集成在一个叫做 Android Studio 的软件当中，这个软件非常的庞大，是用于安卓软件的集成开发环境。

这个软件非常吃内存，作为自动化测试，也不会用到里面的巨大多数功能，所以我们会尝试更轻量级的ADT Bundle，号称安卓的新手开发礼包，这里面提供了必要的安卓运行需要的工具以及环境。

官网下载地址：[linux 64 bit]()、[linux 32 bit](http://dl.google.com/android/adt/adt-bundle-linux-x86-20140702.zip)、[MacOS X](http://dl.google.com/android/adt/adt-bundle-mac-x86_64-20140702.zip)、[Win32](http://dl.google.com/android/adt/adt-bundle-windows-x86-20140702.zip)、[Win64](http://dl.google.com/android/adt/adt-bundle-windows-x86_64-20140702.zip)

[国内下载地址](https://www.androiddevtools.cn/)，都是免安装版本，直接解压放到目录下就可以。如果觉得麻烦，也可以私信我领取最新的版本，我下载好的升级到了最新的系统版本工具。![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135610.png)


安卓环境和 JDK 一样，也需要配置环境变量。解压完成后进入到对应的 adt-bundle-windows-x86_64-20140702\sdk\platform-tools 目录，这个目录有存放 appium 自动化所需要的相关组件和工具，接下来我们需要来将platform-tools这个目录配置到系统环境变量中，方便全局使用。

进入到系统环境变量设置中 -> 新建 ANDROID_HOME，变量值为你的 SDK 对应的目录，比如我的 ADT 软件包解压之后是在 D 盘，那么 SDK 对应的目录就是：D:\adt-bundle-windows-x86_64-20140702\sdk<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135619.png)


接下来我们把 SDK 对应的 platform-tools 目录以及 tools 配置到系统变量 Path 里面去：Path 里面点击新建，添加`%ANDROID_HOME%\platform-tools` 以及 `%ANDROID_HOME%\tools`2 个变量，其他需要用到的可以自行添加。设置好，重启电脑让环境变量生效。打开系统的 cmd 窗口输入 adb version 来检测是否安装成功。<br />![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220326135631.png)


<a name="mgCOc"></a>
## 五、手机连接

手机可以是模拟器、真机和云设备。

如果你只是个人使用，不太方便把自己的真机做成测试机来使用，那么我建议大家安装模拟器，目前来说在国内手机模拟器非常非常多，常用的有雷电、夜神、逍遥、网易 mumu 以及腾讯手游助手等等。

任何一个公司的模拟器都是可以满足自动化测试的需求，设置上会稍微有一点区别，不过不明显。目前来说，我会使用雷电模拟器跟大家演示。（如果会鼓捣，官方的模拟器更清爽，启动也更快）

直接从雷电的官网下载最新的模拟器版本，然后像安装其他普通软件一样安装，安装完成之后，打开命令行工具，然后在命令行当中输入 adb devices，如果能够正常发现模拟器，那么就会显示以下信息。
```bash
C:\Users\jiubing>adb devices
* daemon not running; starting now at tcp:5037
* daemon started successfully
List of devices attached
emulator-5554   device
```

<a name="s53cJ"></a>
## 六、总结

到这里，Appium 运行环境就设置好了，注意事项再提醒一下。

1、Appium 服务分为界面版和命令行版本，新手可直接使用界面版，上手快一些，Appium 下载的速度非常慢，自备工具或者做伸手党，向别人要也可以。

2、SDK 和 ADT Bundle 都需要设置环境变量，设置完成后重启电脑。

3、不管是模拟器还是真机，都需要被 adb 命令识别到。


（完）

参考资料

- [android sdk manager 下载地址](https://androidsdkmanager.azurewebsites.net/)