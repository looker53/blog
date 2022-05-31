---
title: Appium元素定位
date: 2022-03-23 16:17:10
permalink: /pages/1c5728/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
无论想在 app 页面中进行怎样的操作，我们先得找到那个要操作的元素。比如你想直接点击一个按钮，那么你就必须要先找到这个按钮。如果你想在输入框当中去输入一些内容，那么你就必须要先找到这个输入框。

这个寻找需要操作的元素的过程，叫做元素定位。

## 一、元素定位函数

在大多数的APP操作过程当中，首先必须先找到需要操作的元素，这个过程就叫元素定位。

在Appium当中进行元素定位的函数叫 find_element，他传递两个参数。第1个参数是定位元素的方式， 第二个参数是这个方式的值。 举个例子，通过 ID 定位一个元素，第1个参数就填 id，第2个参数表示ID的值。 
```python
el = driver.find_element('id', 'value')
```

得到的 el 是一个元素对象，获取元素的属性都很简单：
```python
el.text  #获取元素文本
el.rect  #获取元素坐标
el.get_attribute('clickable')  #获取元素clickable属性
```

## 二、元素定位工具：uiautomatorviewer
那么，id 的值到哪里去获取呢？在 SDK 中有一个 tools 目录，这个目录有一个叫 uiautomatorviewer 的工具，能查看每个元素的属性，当然也包括 id 属性。直接找到对应的文件，点击就能看到它的界面。


要查看一个元素的属性，只需把鼠标移动到元素上，右侧就会显示每个元素的属性。每一次点击 uiautomatorviewer 这个工具呢会比较麻烦对吧，去创建一个快捷访问方式，放到我们的桌面上，需要用到的时候，就直接在桌面上点击这个快捷方式就可以打开了。

## 三、元素定位工具：Appium Inspector

![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323162126.png)


## 四、元素定位工具：weditor

在 web 测试中，可以使用 F12 辅助元素定位，app 中没有这样的工具，需要安装第三方的工具，目前主流的工具有：

-  android uiautomatorviewer 
-  weditor 
-  appium inspect 

weditor 安装：

```python
pip install weditor
```

界面：




- 左边是手机的截图
- 中间是定位元素的属性
- 右边是生成的代码已经元素结构

**weditor 可以显示元素的 xpath 表达式，直接复制 xpath 表达式进行元素定位，非常方便。**

需要注意的是：weditor 也是通过 adb 连接手机的，和 appium 服务会冲突。他们不能同时运行，在运行 appium 之前先通过 weditor 把所有需要的元素表达式复制出来，然后运行 appium， 并把手机上的 atx 服务卸载掉。 下次再使用 weditor 时 atx 会自动装上的。




## 五、通过 XPath 定位元素

如果没有元素定位，ui 自动化测试将寸步难行。如果元素定位不精准，自动化测试就很难稳定运行。也许你经常听前辈们讲解如何提高自动化程序运行的稳定性，我得说，一个精准的元素定位表达式，是一切自动化测试程序正常执行的基础。

什么是元素定位呢？无论自动化程序想要操作网页的任何按钮、链接或者输入框，都必须先找到要操作的网页元素，这个过程就是元素定位。

现如今，我们会运用机器学习等智能化手段提高元素定位的精准性，但不是每个公司和测试员有精力研究机器学习。实际上，你只需要编写一个良好的 xpath 表达式，就能做到精准控制想要操作的网页元素。

### 如何在浏览器中定位元素

定位元素的方式有很多，有基于网页 DOM 的元素定位方式，有基于图像识别的元素定位方式，甚至有基于坐标的定位方式。通常会使用 DOM 解析的方式来获取元素。

首先，打开浏览器，在任意网页中按快捷键 F12 打开开发者工具，在 element 标签中能看到网页的源代码。任何网页元素，不管是连接，按钮还是输入框，都由一个个 HTML 标签组成。 标签包含了标签名、属性、文本、嵌套子标签等组成部分。

定位元素时，就是根据这些组成部分的特征来查找元素。比如想定位一个输入框：
![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323173429.png)

那么可以作为定位依据的特征有标签名 input、size 属性、name 属性、type 属性等等。 在浏览器的控制台中，可以输入`document.getElementsByName`指令获取到这个元素。
![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323173419.png)

获取方式可以通过 name 属性、id 属性，class 属性等等。
![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323173404.png)

本篇所有示例都使用同一个网址，你可以直接打开进行练习。 网址：[https://petstore.octoperf.com](https://petstore.octoperf.com/actions/Catalog.action)

### 为什么要用 xpath

上面这些方式都是通过单个属性定位定位元素，一旦元素中没有这些属性，方法就失效了。还有就是在一个网页中，使用同一个属性值可能找出来多个元素，不够精准。

xpath 和 css 选择器都能提供更精准的元素定位服务。他们可以组合多个属性和特征，进一步筛选元素的范围，直到找到唯一的那个元素。

### 在浏览器中如何编写 xpath

在浏览器中调试xpath。
**第一种方式是在开发者工具中按 ctrl + f**，输入 xpath 表达式后可以通过上下箭头查看效果。
![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323173323.png)


**第二种方式在控制台中输入 **`**$x("//div")**`** ，更推荐使用**，谷歌浏览器和火狐浏览器都可以。 输入 xpath 表达式后，在控制台中直接显示定位到的元素。在接下来的所有的语法讲解中，都可以通过打开浏览器练习。
![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323173346.png)


### 核心用法

接下来是使用 xpath 必须掌握的核心知识点，只要掌握好这些知识点，基本上能定义到想要的元素。

```
//input[@name='accout']
```

- // 开头表示相对路径， 也可以用 / 开头表示绝对路径，一般用相对路径。
- [] 内表示属性条件
- [@name='accout'] 表示获取name属性等于accout 的元素

### 属性选择器

网页元素的任何属性都可以用来定位元素，常见的 name 属性、id 属性、type 属性、class 属性等等。需要注意的是，如果需要用 text 文本定位，则使用 text() 表示。

```
//input[@type="submit"]
//a[text()="Sign In"]
```

### 组合多个属性

多个属性之间可以相互组合，从而更精准的定位到想要的元素。组合可以使用 and 连接，也可以直接在第一个 [] 后继续加第二个 []

```
//a[1 and contains(@href, "FISH")]
//a[1][contains(@href, "FISH")]
```

### 索引

当通过表达式取出来多个元素时，可以通过索引指定获取第几个。

```
//div[@id="QuickLinks"]/a[position()=1]
//div[@id="QuickLinks"]/a[position()>3]
//div[@id="QuickLinks"]/a[1]
//div[@id="QuickLinks"]/a[last()]
```

### 函数

某些属性的值很长，用等于符号会让表达式看起来很长，因此有时候我们可以使用 contains,  starts-with 等函数来精简。

```
//a[contains(@href, 'FISH')]
```

### 通过祖先找后代

```
//div//input
//div/input
//div/*
```

### 通过后代找祖先

```
//a[.//img[@src="../images/sm_fish.gif"]]
//a[img[@src="../images/sm_fish.gif"]]
//img[@src="../images/sm_fish.gif"]/../..
```

### 轴

基本上以上的操作就可以满足95%的使用场景了，还有就是同级元素的查找，尤其是像表格、菜单选项这样的元素经常会用到同级元素。 此时可以使用轴，会更加方便一些。 经常用到的轴有 follow-sibling 和 preceding-sibing。

```
//div[@id="QuickLinks"]/a[1]/following-sibling::a[1]
```

### 直接获取文本

xpath 也支持直接在表达式内获取 text 文本。

```
//div[@id="MenuContent"]/a[2]/text()'
```

![](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20220323173237.png)


### 获取元素的属性

xpath 也支持直接在表达式内获取属性。

```
$x('//a[text()="Sign In"]/@href')
```

参考

- [https://en.wikipedia.org/wiki/XPath](https://en.wikipedia.org/wiki/XPath)
- [https://developer.mozilla.org/en-US/docs/Web/XPath](https://developer.mozilla.org/en-US/docs/Web/XPath)
- [https://devhints.io/xpath](https://devhints.io/xpath)

**weditor 支持直接复制 xpath, 优先使用 xpath 更加便捷**。

```python
from appium.webdriver import Remote

default_caps = dict()
default_caps['platformName'] = 'Android'
default_caps['deviceName'] = ''
default_caps['app'] = r'D:\\data\\柠檬班环境\\app测试环境\\应用apk包\\lemon_app_webview_debug.apk'
# 设置超时时间退出
default_caps['newCommandTimeout'] = 1200

driver = Remote(command_executor='<http://127.0.0.1:4444/wd/hub>', desired_capabilities=caps)

xpath_my = '//*[@resource-id="com.lemon.lemonban:id/navigation_my"]'
driver.find_element('xpath', xpath_my).click()

xpath_avatar = '//*[@resource-id="com.lemon.lemonban:id/fragment_my_lemon_avatar_title"]'
driver.find_element('xpath', xpath_avatar).click()

username_avatar = '//*[@resource-id="com.lemon.lemonban:id/et_mobile"]'
driver.find_element('xpath', username_avatar).send_keys("yu")

password_avatar = '//*[@resource-id="com.lemon.lemonban:id/et_password"]'
driver.find_element('xpath', password_avatar).send_keys('hey')
```

**其他的元素定位方式：**

- MobileBy.XPATH
- [MobileBy.ID](http://MobileBy.ID)
- MobileBy.ACCESSIBILITY_ID
- MobileBy.ANDROID_UIAUTOMATOR
- MobileBy.CLASS_NAME

**安卓元素的 id 属性不一定是唯一的，并不能作为标识。**

UiSelector 是通过安卓代码定位，比较容易出错， 参考 [官网](https://developer.android.com/reference/android/support/test/uiautomator/UiSelector) 的用法。

```python
# 我
e = driver.find_element_by_android_uiautomator('new UiSelector().text("我")')
e.click()

# 手机号码
phone_s = 'new UiSelector().resourceId("com.xxzb.fenwoo:id/et_phone")'
e = driver.find_element_by_android_uiautomator(phone_s)
e.send_keys('123')

# 下一步
next_s = 'new UiSelector().resourceId("com.xxzb.fenwoo:id/btn_next_step")'
e = driver.find_element_by_android_uiautomator(next_s)
e.click()
```

## 六、其他元素定位方式


## 七、获取元素属性
#### location 元素的位置

- element.location_in_view
- location

- el.rect
- text
- el.get_attribute()

## 八、元素等待

和 selenium 一样，三种等待方式通用：

- 显性等待
- 隐性等待
- 强制等待

