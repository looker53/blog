

## 一、确认环境


自动化测试涉及到手机、电脑以及Appium服务等多端交互，在正式开始之前，首先我们要确认一下环境是否正确安装：

-   连接手机或者打开模拟器
-   adb devices 确认手机被识别
-   启动 Appium 服务，并设置端口
-   运行 Python 脚本

如果没有安装appium环境请参考：[[Appium环境搭建保姆级教程]]


## 二、编写Appium启动脚本

启动Appium程序的代码：
```python
from appium.webdriver import Remote
caps = dict(platformName="Android")
driver = Remote(desired_capabilities=caps)
```

打开手机，如果需要访问具体的App，将App的安装包路径也放到 caps 中：
```python
caps = dict(platformName="Android",
			app="/path/iBiliPlayer-bilibili.apk")
```

电脑上也有可能连接多个手机，如果有多个手机，需要指定想操作的手机设备，使用 udid 参数，设备号可以输入adb devices 获取。通常情况下，要对某个app进行自动化测试，这三个启动参数是最常见的。
```python
caps = dict(platformName="Android",
			app="/path/iBiliPlayer-bilibili.apk",
			udid='emulator-5554')
```


当这些数据准备好了之后，我们可以直接通过给 Appium 提供的 Remote类，连接对应的app。操作完成之后，通过 quit 方法来退出整个会话。

**一定要记得quit，否则后面在进行元素定位的时候，可能会出现无法获取页面源码的错误。**

```python
from appium.webdriver import Remote

file = '/path/iBiliPlayer-bilibili.apk'

caps = dict(platformName="Android",
			app=file,
			udid='emulator-5554')

driver = Remote(desired_capabilities=caps)
driver.quit()

```


  

## 三、通过包名启动 App

通常情况下，我们可以通过apk的路径来直接操作指定的app。但是又是不方便拿到 apk 文件，而我们的手机上已经装好了要测试的 app, 那么可以通过 app 的包名来启动。

```python
from appium.webdriver import Remote

caps = {  
    "platformName": "Android",  
    "udid": "emulator-5554",  
    "appPackage": "com.bilibili.app.blue",  
    "appActivity": "tv.danmaku.bili.ui.splash.SplashActivity"  
}

driver = Remote(desired_capabilities=caps)
driver.quit()
```


## 四、如何获取App包名和Activity名称

通过下面的命令可以直接得到启动 app 的 appPackage 参数和 appActivity 参数。
```bash
adb logcat | findStr -i displayed
```

这行命令可以显示手机最近打开了哪些页面，最近打开的页面会显示在最下方，从而我们得到了需要的参数。
![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323164850.png)


其他的还有很多启动参数，可以在官方的 [Desired Capbility](https://appium.io/docs/en/writing-running-appium/caps/) 中查看。只有 platformName 是必填的，其他都是可选。

  

常用启动参数：
-   platformName 必选
-   deviceName / udid 必选
-   app 安装路径
-   appActivity 和 appPackage,
-   platformVersion 可选，版本不匹配会报错
-   noReset 不重置， True
-   automationName
-   browserName， 直接测web用, Chrome
-   autoWebview， 开机进入webview模式
-   chromedriverExecutable
-   chromedriverExecutableDir
-   unicodeKeyboard
-   resetKeyboard
-   autoGrantPermissions


## 五、一个完整的自动化脚本

通过一个完整的脚本说明一下。

1、连接手机，启动 app

2、元素定位，执行操作

3、退出程序

每一次执行操作之前都会有一个 find_element 过程，这个过程叫元素定位。

```python
from appium.webdriver import Remote

caps = {  
    "platformName": "Android",  
    "udid": "emulator-5554",  
    "appPackage": "com.bilibili.app.blue",  
    "appActivity": "tv.danmaku.bili.ui.splash.SplashActivity"  
}

driver = Remote(desired_capabilities=caps,
                command_executor = 'http://127.0.0.1:4723/wd/hub')
driver.implicitly_wait(10)
driver.find_element('id', 'com.bilibili.app.blue:id/agree').click()
driver.quit()
```



