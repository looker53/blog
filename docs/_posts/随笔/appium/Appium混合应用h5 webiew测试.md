---
title: Appium混合应用h5 webiew测试
date: 2022-03-24 20:57:37
permalink: /pages/169d48/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
# Appium混合应用h5 webiew测试

# 什么是混合应用 Hybrid App

原生应用是使用系统原生的组件开发的 app，需要特定的语言，比如 android 的 java/kotlin， ios 的 swift/object-c。

H5 技术可以使用 web 技术开发 app，原生和 h5 的组合就成了混合应用。混合应用不是在app上直接写 HTML 页面，而是把 H5 页面放在一个 webview 控件当中。

webview 是原生应用的一种控件，还有其他 ImageView 等等。Webview 能做到和 web 页面交互的功

# 如何判断一个页面是 web

- **web dev 调试工具 uc-tools 或者 chrome inspect可以查看到**
- 响应速度，如果很快加载完成，大半是原生，如果加载比较慢，多半H5
- 元素的 class 为 webview
- 有 x 图标
- uiautomatorviewer 等辅助工具难以定位
- 进度条。

# 混合应用测试准备条件

- apk 设置，找开发开启 webview 调试模式。app 设置 setWebContentsDebuggingEnabled=True
- Webdriver / chromedriver.exe
- 调试工具

**资料**

- [Hybrid Apps Doc](http://appium.io/docs/en/writing-running-appium/web/hybrid/index.html)
- [chrome://inspect 调试](https://developers.google.com/web/tools/chrome-devtools/remote-debugging/webviews)
- [chromedriver 路径设置](http://appium.io/docs/en/writing-running-appium/web/chromedriver/)

# webview 测试步骤

- 通过 uiautomatorviewer 定位原生应用控件
- appium 操作到 web 页面
- 上下文切换
- 通过 uctool 定位 web 页面
- 退回原生页面，切换回原生。

**切换上下文**

1、driver.switch_to.context(context)

2、切换至默认的：driver.switch_to.context(None)

- driver.contexts.last
- driver.contexts.first
- driver.context
- driver.switch_to.context()
- 如果一开始就是在 webview ，可以设置 desired_caps["autoWebview"] = True

**chromedriver.exe**

- 路径配置
- chromedriverExecutableDir： r"D:\chrome_driver"
- chromedriverExecutable: r"D:\chrome_driver\chromedriver.exe"

# 网页定位

- uc-devtools，
- 设置改成 本地 Dev.
- 手机上的chrome浏览器版本要和driver驱动对应。否则会说没有 chromedriver，放到 appium 对应的目录下面。
- adb shell dumpsys activity | find "mFocusedActivity"

# 案例

```python
from appium.webdriver import Remote

caps = {
    "platformName": "Android",
    "chromedriverExecutableDir": r"D:\data\chromedriver",
    "deviceName": "Android Emulator",
    "appActivity": ".activity.MainActivity",
    "appPackage": "com.lemon.lemonban",
}

driver = Remote(desired_capabilities=caps, command_executor='http://127.0.0.1:4723/wd/hub')
driver.implicitly_wait(10)

# 点击师资团队进入 web 页面
driver.find_element('xpath',"//*[@text='师资团队']").click()
# 打印所有的上下文
print(driver.contexts)
# 上下文切换
driver.switch_to.context('WEBVIEW_com.lemon.lemonban')
# 注意：有时候一个页面会包含多个标签
print(driver.window_handles)
# 点击菜单
driver.find_element('id','m-header__nav').click()

```

案例2：