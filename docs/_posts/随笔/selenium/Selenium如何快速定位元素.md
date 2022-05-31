---
title: Selenium如何快速定位元素
date: 2022-05-26 19:28:05
permalink: /pages/65fe82/
sidebar: auto
categories:
  - 日记
tags:
  - 
---
我们在浏览器中的操作主要分为两大类。第一类是对浏览器自身的操作，这类操作在任何的界面都是通用的，比如说控制页面前进、后退、刷新、最小化、最大化、关闭、打开新标签、输入 URL 等等。第二类是对页面元素的操作，这类操作是在被打开的页面上进行，主要针对页面中某个具体的元素或控件，比如在某个特定的输入框中写入内容，或者在某张图片和按钮上施行点击操作。

![img](https://cdn.nlark.com/yuque/0/2022/png/104618/1645780254383-019e73de-aa2e-41f2-a20f-e9e5be16f830.png)

因为页面元素操作往往是在一个具体的元素上执行，所以必须要先找到这个元素，才能执行操作。在手工测试过程中，这基本上不是一个问题，因为我们使用浏览器的经验非常丰富，条件反射就能辨别哪里是输入框，哪里是图片。但是在自动化测试中，我们是使用程序操作页面元素，工具不会有任何经验，所以测试员需要提前说明被操作元素在页面中的路径，并且把这个路径告诉程序，程序再通过这个路径在网页中去寻找。

![img](https://cdn.nlark.com/yuque/0/2022/png/104618/1645780254147-876a9392-45f9-4a88-aab3-271f718abfdd.png)

元素路径是寻找该元素的依据，目前可以使用三种方式来表示，**第一种是页面的DOM结构路径，第二种是坐标，第三种是通过图像识别技术**，Selenium 主要使用 DOM 结构路径来查找元素。这种方式的好处是兼容性强，不管是在电脑端还是手机端，也不管窗口的大小如何设置，只要这个 DOM 结构不变，就能找到元素。不好的地方在于需要学习网页的这种 DOM 结构，以及如何编写元素定位器。

首先我们来看看什么 DOM。

**文档对象模型 (DOM) 是HTML和XML文档的编程接口**。它提供了对文档的结构化的表述，并定义了一种方式可以使从程序中对该结构进行访问，从而改变文档的结构，样式和内容。DOM 将文档解析为一个由节点和对象（包含属性和方法的对象）组成的结构集合。简言之，它会将web页面和脚本或程序语言连接起来。---来自 [MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/Document_Object_Model/Introduction)

网页是由 HTML 文档编写的，在浏览器中，通常可以通过 F12 快捷键查看网页的 HTML 源代码。一个 HTML 文档是由标签组成的，标签之间可以并行排列，也可以嵌套排列。一个标签由标签名称、标签属性以及文本构成，被嵌套的标签被称为子标签。 ![img](https://cdn.nlark.com/yuque/0/2022/png/104618/1645780254256-cc05e2e5-ab91-490c-8e90-e2acb79218f2.png)

## HTML

- input
- checkbox
- radio
- submit
- file
- form
- a
- img
- iframe

每个元素都有自己喜欢用的属性，比如 input 通常会有 name 属性， a 标签通常有 src 属性和链接文本。

HTML 标签的构成决定了 selenium 元素定位的方式：

- id
- name
- class name
- tag name
- link text
- partial link text

## DOM

HTML 这些标签归根结底就是字符串，不方便被程序访问和控制，因此浏览器通过 DOM 这种方式把文档转化成了对象，方便程序进行访问。现在我们通过 F12 快捷键打开浏览器的控制台，对打开的网页进行一些简单的 DOM 操作。在控制台当中输入document，浏览器当中将会显示整个 HTML 标签内容，输入 document.body 显示打开页面的整个body标签。这样，**通过DOM面向对象的编程方式能非常方便的获取到想要的元素，也能非常方便的执行浏览器操作**。

![img](https://cdn.nlark.com/yuque/0/2022/png/104618/1645780254265-289ef965-eb9d-4b63-af90-dffcd497d1ae.png)

上面我们编写的代码是 JavaScript 代码，实际上 DOM 和编程语言没有直接关系，使用其他语言同样是可以操作 DOM 的，比如使用 Python 语言操作 DOM 类似于：

```python
 # Python DOM example
 import xml.dom.minidom as m
 doc = m.parse("C:\\Projects\\Py\\chap1.xml");
 doc.nodeName # DOM property of document object;
 p_list = doc.getElementsByTagName("para");
```



然后我们来看看怎么编写元素定位器。

HTML 是由标签组成的，一个网页中包含的标签非常多，他们会形成很深的嵌套关系，因此我们会从最外层的 html 标签开始，沿着 body 以及其他子标签的嵌套顺序，一直找到需要操作的标签，沿途经过的标签就形成了查找元素需要的完整路径。我们还会根据属性和文本在路径上做一些标签，让程序更快捷的找到需要的元素，在一个完整的定位表达式中通常包含了标签之间的嵌套关系、标签属性以及文本内容等信息。

![img](https://cdn.nlark.com/yuque/0/2022/png/104618/1645780254276-47465897-b554-47c4-87a9-66ce4b9d0e73.png)

知道元素定位表达式的作用之后，我们来看看 Selenium 当中具体是如何进行元素定位的。Selenium 支持的元素定位方法有很多，其中功能最强大的是 CSS 选择器和 xpath，之后我们会详细介绍。现在让我们使用css选择器这种方法来做一个简单的例子。

首先，我们需要编写 CSS 选择器的元素定位器 #kw，它表示需要找一个属性 id 等于 kw 的元素，然后我们将元素定位器传给 Selenium 提供的 find_element 方法，让他帮我们去查找这个元素，将得到的元素对象存储在变量当中，如果程序没有找到符合要求的元素，将会抛出异常；如果通过表达式找到不止一个元素，find_element 方法只会返回第一个元素，如果想得到所有符合要求的元素，使用 find_elements 方法，所有结果会存放到一个列表当中。

```python
 # 元素定位表达式
 locator = '#kw'
 # 将表达式作为参数传给浏览器程序
 element = browser.find_element('css selector', locator)
 # 获取符合要求的所有元素
 elements = browser.find_elements('css selector', locator)
```



## CSS 选择器

CSS 选择器是使用最广泛的元素定位方式，它可以组合元素关系、元素属性以及索引来查找元素，几乎所有的页面定位工具都会支持这种方式。在任意的浏览器控制台当中，通过 document.querySelector 方法可以直接输入 CSS 选择器来定位元素。

![img](https://cdn.nlark.com/yuque/0/2022/png/104618/1645780254736-793d2fad-1ca6-4b98-90e3-0484ef04d2bc.png)

CSS 选择器分为基本选择器、组合选择器、分组选择器以及伪选择器。

基本选择器匹配单个要素，主要有：

- 元素选择器， 用elementName 表示，比如 input 表示匹配标签名为 input 的元素。
- ID 选择器， 用#id 表示，比如 #kw 表示匹配 id 等于 kw 的元素。
- class 选择器，用.className 表示，比如 .container 表示匹配 class 属性中包含 container 的元素。
- 属性选择器
- 通用选择器

## xpath

xpath 和 css 选择都可以组合多个条件定位元素，更加强大和灵活。如果通过某种方式找到了多个元素，需要进一步去删选， 加条件。

- 1、支持所有的元素属性
- 2、支持 text 文本
- 3、可以通过 标签名
- 4、 可以通过元素之间的关系
- 5、要素和要素可以进行任意形式的组合。

xpath 长什么样呢？可以在浏览器中找到元素复制 xpath 表达式，这也是在做测试时会采取的策略；另一种策略是使用 chropath 这样的定位插件。

复制出来的xpath 有绝对路径和相对路径。

如何自己编写和验证xpath ? 浏览器源码中按 F12 快捷键。

1、 浏览器右击复制、chropath 第三方库2、 检查xpath好的xpath: 层级比较少 1-23、 xpath 找到元素验证：ctrl + f4、 //input[@id='kw'] 基本5、 //input[@id='kw' and @name='wd'] and6、 //input[@id='kw' and text()='wd'] text7、 //input[contains(text(), '')] contains8、 (//*[contains(text(), '')])[1] 索引9、 //form//input[] 通过祖先找子孙

轴运算：找找哥哥姐姐： //input[@name='wd']/preceding-sibling::span找找弟弟妹妹： //input[@name='wd']/following-sibling::span找祖先： //input[@name='wd']/ancestor::span

- css 选择器定位元素
- xpath

- - css vs xpath

- 其他元素定位方式id、class、name、link text、partial link text、tagname



## 网络超时



**隐性等待**



```python
def test_implicitly_wait(self, browser):
    # 隐性等待
    browser.implicitly_wait(10)
    
    browser.get("http://www.baidu.com")
    browser.find_element(By.XPATH, '//input[@id="kw"]').send_keys('明天再学')
    browser.find_element(By.ID, 'su').click()
    browser.find_element(By.LINK_TEXT, '知乎').click()
```



**显性等待**



```python
def test_webdriverwait(self, browser):
    browser.get("http://www.baidu.com")
    browser.find_element(By.XPATH, '//input[@id="kw"]').send_keys('明天再学')
    browser.find_element(By.ID, 'su').click()
    # 显性等待
    locator = (By.LINK_TEXT, '知乎')
    condition = when.element_to_be_clickable(locator)
    WebDriverWait(browser, timeout=5).until(condition).click()
```