---
title: Appium uiautomator2 server无法找到
date: 2022-05-31 15:16:28
permalink: /pages/55601f/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
# Appium uiatumator2 server 服务无法启动

在启动 appium 程序中，有时候会出现 uiautomator2 服务无法启动的错误，appium 的日志截图如下：

![https://i.loli.net/2020/05/12/XUJCs9x5ywimnjz.png](https://i.loli.net/2020/05/12/XUJCs9x5ywimnjz.png)

错误信息如下：

ActivityManager: Unable to find instrumentation info for:  ComponentInfo{io.appium.uiautomator2.server.test/android.support.test.runner.AndroidJUnitRunner}

### 问题解决

步骤1：先通过以下命令查找 uiautomator 服务

```
adb shell pm list package | grep uiautomator
```

步骤2：得到结果类似这样：

```
package:io.appium.uiautomator2.server
package:io.appium.uiautomator2.server.test
```

也可以查看 instrumentation:

```
adb shell pm list instrumentation
```

得到结果类似这样：

```
instrumentation:io.appium.uiautomator2.server.test/android.support.test.runner.AndroidJUnitRunner (target=io.appium.uiautomator2.server)
```

步骤3：卸载 uiautomator2 服务：

```
adb uninstall io.appium.uiautomator2.server
adb uninstall io.appium.uiautomator2.server.test
```

重启 appium 。