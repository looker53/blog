---
title: Appium API操作教程
date: 2022-03-24 15:27:00
permalink: /pages/5329c0/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
## 点击
```python
el = driver.find_element('id', 'com.bilibili.app.blue:id/agree')
el.click()
```

## 输入
```python
el.send_keys('words')
```


## 等待页面跳转
app很多操作比较耗时，比如进入首页就要很长的时间。如果还没等页面跳转完成就运行代码，大概率是无法操作成功的。

在执行操作之前，一定要确保已经进入该页面，判断已经进入页面的方法是 wait_activity 方法，传入 activity 名称和超时时间，等待该 activity 出现再执行其他操作

```python
driver.wait_activity('tv.danmaku.bili.MainActivityV2', 10)
...
do_something_else()
```


## 快速进入页面
```python
driver.start_activity('pkg', 'activity')
```
获取 pkg 和 activity
```bash
adb logcat | findStr -i displayed
```

## 滑动
```python
driver.swipe(startx, starty, endx, endy)
```

appium提供的 swipe 有一个比较大的问题：用起来不方便，每次都要获取坐标传参，而且每个手机的分辨率不同，坐标也不一样，在这个手机上执行可以，换一个手机代码就不一定能正确滑动了。

因此我们要自己提供一种更方便的方法滑动。思路是这样的：通过appium获取当前手机的分辨率，然后根据分辨率的比例计算滑动距离。

适配手机：

```python
time.sleep(2)

size = driver.get_window_rect()

startx = size['width'] * 0.9
endx = size['width'] * 0.1
starty = size['height'] * 0.1
endy = size['height'] * 0.1

driver.swipe(startx, starty, endx, endy)
```

封装：

```python
class Swiper: 
    def __init__(self,driver: Remote):
        self.driver = driver

    @property
    def width(self):
        return self.driver.get_window_size().get('width')

    @property
    def height(self):
        return self.driver.get_window_size().get('height')

    def swipe_left(self, duration=2000):
        return self.driver.swipe(
            self.width*0.9,
            self.height*0.5,
            self.width*0.1,
            self.height*0.5,
            duration=duration
        )

    def swipe_right(self, duration=2000):
        return self.driver.swipe(
            self.width*0.1,
            self.height*0.5,
            self.width*0.9,
            self.height*0.5,
         duration = duration
        )

    def swipe(self, direction, duration=2000):
        if direction == 'left':
            self.swipe_left(duration)
        elif direction == 'right':
            self.swipe_right(duration)
				...
```



## flink
flink 的作用基本和 swipe 差不多。


## 进入指定页面
app 的路径依赖是很严重的，如果需要测试某个单独的页面，但是进入这个页面有很长的路径，则会严重影响效率，而且路径过长，会让测试程序不稳定。

start_activity 可以快速进入指定界面，只需要指定 activity 的名称。

获取当前页面的名称：

```python
adb shell dumpsys activity | find "mResumedActivity"
driver.start_activity('com.lemon.lemonban','.activity.LoginActActivity')
```


## 放大
参考： [Appium实现图片放大缩小](https://jiubing.site/pages/8f8a52/)




以前的封装

```python
def zoom_screen(rect):
    print(rect)
    width = rect['width']
    height = rect['height']
    x = rect['x']
    y = rect['y']

    m = MultiAction(driver)
    a1 = TouchAction(driver)
    a2 = TouchAction(driver)

    # a1.press(x=x+width/2, y=y+height/2).move_to(x=x+width, y=y+height/2)
    # a2.press(x=x+width/2, y=y+height/2).move_to(x=x, y=y+height/2)
    print()

    a1.press(x=width / 2, y=height / 2).move_to(x=width, y=height / 2).release()
    a2.press(x=width / 2, y=height / 2).move_to(x=0, y=height / 2).release()

    m.add(a1,a2)
    m.perform()
def zoom(self, offset):
        """放大"""
        action_1 = TouchAction(self.driver)
        action_1.press(x=self.width / 2, y=self.height / 2).move_to(
            x=self.width / 2, y=self.height / 2 - offset).release()
        action_2 = TouchAction(self.driver)
        action_2.press(x=self.width / 2, y=self.height / 2).move_to(
            x=self.width / 2, y=self.height / 2 + offset).release()

        m = MultiAction(self.driver)
        m.add(action_1, action_2)
        m.perform()

    def pinch(self, offset):
        """缩小"""
        action_1 = TouchAction(self.driver)
        action_1.press(x=self.width / 2, y=self.height / 2 - offset).move_to(
            x=self.width / 2, y=self.height / 2).release()
        action_2 = TouchAction(self.driver)
        action_2.press(x=self.width / 2, y=self.height / 2 + offset).move_to(
            x=self.width / 2, y=self.height / 2).release()

        m = MultiAction(self.driver)
        m.add(action_1, action_2)
        m.perform()
```

安卓图片放大（只能在控制台生效）

```python
caps = {
        "deviceName": "emulator-5554",
        "platformName": "Android",
        "appPackage": "com.android.gallery3d",
        "appActivity": ".app.GalleryActivity",
        "newCommandTimeout": 1200
}

driver = Remote(command_executor='<http://127.0.0.1:4444/wd/hub>',
              desired_capabilities=caps)

time.sleep(3)
rect = driver.get_window_rect()
m = MultiAction(driver)
a1 = TouchAction(driver)
a2 = TouchAction(driver)
width = rect['width']
height = rect['height']
a1.tap(x=width / 2, y=height / 2).perform()

a1.long_press(x=width / 2, y=height / 2).move_to(x=width, y=height / 2).release()
a2.long_press(x=width / 2, y=height / 2).move_to(x=0, y=height / 2).release()
m.add(a1, a2)
m.perform()
```



## 后台执行
```python
driver.backgroud_app(10)
driver.active_app('com.android.settings')
```


## 按键操作

```python
# 发数字
driver.press_keycode(8)
driver.press_keycode(9)
driver.press_keycode(10)

# 浏览器
EXPLORER = 64
# 电源键
POWER = 26
# 音量键
VOLUME_UP = 24
VOLUME_DOWN = 25
# 输入数据之前还需要点击。
ENTER = 66
# 可能出现的问题：
#首页
HOME = 3
# 模拟器拨号、拍照用不了
```

[https://www.jianshu.com/p/f7ec856ff56f](https://www.jianshu.com/p/f7ec856ff56f)

[https://blog.csdn.net/qq_14908027/article/details/78880578](https://blog.csdn.net/qq_14908027/article/details/78880578)



## Toast 弹框处理

**前提**

登录：Toast,是 viewer 识别不到的。但是我们需要确认文本是否正确。

1. appium server 1.6.3 以上
1. 代码中必须制定 automationName为：UiAutomator2
1. UIAutomator2只支持安卓版本 5.0+
1. jdk1.8 64位以上。配置 JAVA_HOME 环境变量；

**定位**
```python
driver.find_element('xpath', '//android.widget.Toast')
driver.find_element('xpath', " //*[contains(@text, '手机号码不能为空')]")
```
显性等待用 presence， 不要用 visibility。

**实战**
- 注意：轮询周期非常短。
- 确保你的信息只有你有，其他的元素没有。

**UiAutomator2 报错**

- 1、安装到 user 此用户，不是所有用户；(一定要哦)
- 2、加上参数 noSign。[https://testerhome.com/topics/15224](https://testerhome.com/topics/15224)
- 3、升级 build-tools。[https://testerhome.com/topics/15250](https://testerhome.com/topics/15250)


## 输入中文

在b站搜索关键字的例子：
```python
driver.find_element('id', 'com.bilibili.app.blue:id/agree').click()  
driver.find_element('id', 'com.bilibili.app.blue:id/expand_search').click()  
driver.find_element('id', 'com.bilibili.app.blue:id/search_src_text').send_keys('老照片')  
driver.press_keycode(66)
```

在真机中输入中文时，可能需要使用支持 unicode 的键盘，加上这两个参数。
```python
caps = dict(
	unicodeKeyboard=True,
	resetKeyboard=True
)
```


## 隐藏键盘

## 发短信

## 打电话

## 其他操作

所有的 api 都在 [官网](http://appium.io/docs/en/commands/interactions/touch/tap/) 很方便的查看到。

- driver.hide_keyboard(), 隐藏键盘
- driver.get_screenshot_as_file()
- shake，摇一摇。可以
- lock
- unlock


### 截屏 
```python
driver.get_screenshot_as_base64()
```

### 录屏
```bash
Screen recording does not work on emulators running Android API level less than 27
```
换成真机或者高于27 API 的安卓模拟器。


## TODO:九宫格绘制


## TODO: Commands Appium 指令

[Commands 列表](http://appium.io/docs/en/about-appium/api/)

[Desired Caps 说明](http://appium.io/docs/en/writing-running-appium/caps/)


