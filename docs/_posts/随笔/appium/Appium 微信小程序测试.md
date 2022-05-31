---
title: Appium 微信小程序测试
date: 2022-05-31 15:20:49
permalink: /pages/cdf83d/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---

# Appium微信小程序自动化测试

# 小程序测试

小程序和公众号页面其实都是 H5 页面，本质上都是混合应用测试。 只是这些页面都是运行在 x5 内核上，而不是 chrome 内核。

x5 内核是在 chrome  内核上研发的，小程序和公众号打开只能在这个内核上，用普通的 chrome 浏览器无法开启。所以进行小程序测试必须要开启 x5 内核的调试模式。

- 在任意的聊天窗口输入 [x5debug.qq.com](http://x5debug.qq.com/) 就可以进入内核调试窗口，点击开启 x5 内核的调试模式。
- 在任意聊天窗口输入 [debugmm.qq.com/?forcex5=true](http://debugmm.qq.com/?forcex5=true) 强制启动

![https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903194017388.png](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903194017388.png)

![https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903194032983.png](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20210903194032983.png)

**准备 caps**

```python
#支持X5内核应用自动化配置
desired_caps["recreateChromeDriverSessions"] = True

desired_caps["automationName"] = "UiAutomator2"
desired_caps["platformName"] = "Android"
desired_caps["platformVersion"] = "8.1"
desired_caps["deviceName"] = "Android Emulator"
desired_caps["appPackage"] = "com.tencent.mm"
desired_caps["appActivity"] = "com.tencent.mm.ui.LauncherUI"
# 微信使用的不是系统的chrome内核，而是自己定制的
desired_caps["chromedriverExecutableDir"] ='D:\\chromedriver'
desired_caps["noReset"] = True

# ChromeOptions使用来定制启动选项，因为在appium中切换context识别webview的时候,
# 把com.tencent.mm:toolsmp 或者 appbrand0 的webview识别成com.tencent.mm的webview.
desired_caps["chromeOptions"] = {"androidProcess":"com.tencent.mm:appbrand0"}
# 这一行必须写
desired_caps["browserName"] = ""
```

**获取微信的 package 和 activity**

```
adb shell dumpsys activity top | findstr ACTIVITY

adb shell dumpsys activity | find "mResumedActivity"
```

**微信 chromedriver 设置**

微信当中用的浏览器驱动和手机自带的不一样，都放在 chromedriverExecutableDir 下就可以。

**chromeOptions 设置 webview 进程**

- desired_caps["chromeOptions"] = {"androidProcess":"com.tencent.mm:appbrand0"}
- 获取 webview 进程

**如何获取 webview 进程**

微信当中除了启动主进程，还会给其他子程序分配进程。在小程序等 webview 当中会分配。

先手工点击进入微信小程序 webview, 然后通过 `adb shell dumpsys activity top | findstr ACTIVITY` 指令得到进程号

```
ACTIVITY com.miui.home/.launcher.Launcher c79627 pid=1273
ACTIVITY com.android.systemui/.recents.RecentsActivity 5b7cf2 pid=1136
ACTIVITY com.tencent.mm/.ui.LauncherUI 9249e8c pid=2426
ACTIVITY com.tencent.mm/.plugin.appbrand.ui.AppBrandUI 5244c48 pid=26720
```

拿到进程号，运行：

```
adb shell ps 26720 # 26720 是根据上面的动态变化的。
```

# 脚本

```python
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from appium.webdriver.common.mobileby import MobileBy as MB
from appium import webdriver
import time

desired_caps = {}
# 支持X5内核应用自动化配置
desired_caps["recreateChromeDriverSessions"] = True
# android 4.4以下的版本通过Selendroid来切换到webview
desired_caps["automationName"] = "UiAutomator2"
desired_caps["platformName"] = "Android"
desired_caps["deviceName"] = "Android Emulator"
desired_caps["appPackage"] = "com.tencent.mm"
desired_caps["appActivity"] = "com.tencent.mm.ui.LauncherUI"
desired_caps["chromedriverExecutableDir"] = r'D:\data\chromedriver'
desired_caps["noReset"] = True
desired_caps["chromeOptions"] = {"androidProcess": "com.tencent.mm:appbrand0"}

driver = webdriver.Remote('http://127.0.0.1:4723/wd/hub', desired_caps)
driver.implicitly_wait(10)

wait = WebDriverWait(driver, 30)

# 主页的元素
loc = (MB.ID, 'com.tencent.mm:id/baj')
wait.until(EC.visibility_of_element_located(loc))
size = driver.get_window_size()
driver.swipe(size["width"] * 0.5, size["height"] * 0.1, size["width"] * 0.5, size["height"] * 0.9, 100)

# 下拉列表当中，点击  柠檬班软件测试 小程序
locator = ('xpath', '//*[contains(@text, "柠檬班软")]')
el = WebDriverWait(driver, 30).until(EC.visibility_of_element_located(locator))
el.click()
time.sleep(3)

# ==================  进入了 柠檬班软件测试  小程序界面===============

# 获取所有的上下文
cons = driver.contexts
print("当前所有的上下文为：", cons)

# 切换到小程序webview
driver.switch_to.context('WEBVIEW_com.tencent.mm:appbrand0')

time.sleep(3)
driver.quit()
```

# 公众号测试