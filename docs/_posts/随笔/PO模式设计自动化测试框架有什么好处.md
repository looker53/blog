---
title: PO模式设计自动化测试框架有什么好处
date: 2022-03-12 13:46:46
permalink: /pages/c52342/
sidebar: auto
categories:
  - 随笔
tags:
  - 
---





PO模式是在UI自动化测试过程当中使用非常频繁的一种设计模式，使用这种模式后，可以有效的提升代码的复用能力，并且让自动化测试代码维护起来更加方便。



PO模式的全称叫page object model（POM），有时候叫做 page object pattern。最开始由马丁福勒提出，这个模式受到selenium自动化测试框架大力推广，因而成为一种非常主流的自动化测试设计模式。



在PO模式当中，每一个UI页面使用编程语言当中的类来表示。在这个类当中，通过函数形式定义页面的行为和操作。这让调用方不需要关注具体执行的操作到底是点击还是拖动，而是关注具体的业务，比如登录、购物等等，甚至如果程序员直接把代码给产品经理看，他也是能看懂的。

![image-20220314141318377](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220314141318377.png)



### 没有使用PO模式时

在测试用例中直接编写浏览器操作API，对于代码编写者并没有多高的难度，因为他自己已经对这些API非常熟悉，但是这些浏览器操作并不能体现业务，至少没有产品经理那么熟悉，因此他很难和产品经理进行沟通，也难和开发沟通，甚至在半个月之后，他已经忘记了自己到底写了什么东西。

```python
def test_login_mail(self):
    driver = self.driver
    driver.get("http://www.xxx.xxx.com")
    driver.find_element_by_id("idInput").clear()
    driver.find_element_by_id("xxxxxxx").send_keys("xxxxx")
    driver.find_element_by_id("xxxxxxx").clear()
    driver.find_element_by_id("xxxxxxx").send_keys("xxxxxx")
    driver.find_element_by_id("loginBtn").click()
```





## 使用PO模式

使用PO模式有利于梳理业务，也有利于和其他人进行沟通。当你把下面这段代码拿给产品经理看的时候，他也大概能知道你测的是什么业务，能帮你纠正你的测试流程是否正确，或者提出一些更有建设性的意见，这对于大型项目需要频繁沟通和梳理业务时非常有用。

```python
def test_login_mail(self):
    LoginPage(driver).login()
```



而浏览器本身的操作，就会被分离到一个更底层的模块，这些代码你可以不对调用方暴露，产品经理并不关心你这个页面中什么元素定位，他也不懂。 

```python
class LoginPage:
	username_loc=(By.ID,"idInput")
    password_loc =(By.ID,"pwdInput")
    submit_loc =(By.ID,"loginBtn")
    span_loc=(By.CSS_SELECTOR,"div.error-tt>p")
    dynpw_loc =(By.ID,"lbDynPw")
    userid_loc =(By.ID,"spnUid")
    
    
    def __init__(self, driver):
        self.driver = driver
        
    def login(self):
        self.driver.find_element(*self.username_loc).clear()
        self.driver.find_element(*self.username_loc).send_keys("xxxxx")
        self.driver.find_element(*self.password_loc).clear()
        self.driver.find_element(*self.password_loc).send_keys("xxxxxx")
        self.driver.find_element(*self.submit_loc).click()
```



这种方式把元素定位方式也分离了。但是这种元素定位的表达式可读性也不是很强，可以换用 property 方式来表示元素，所有的元素统一放在一起，修改起来也比较方便。

```python
class LoginPage:
    def __init__(self, driver)
    	self.driver = driver
        
    @property
    def username_element(self):
        return self.driver.find_element('id', 'idInput')
    
    @property
    def password_element(self):
        return self.driver.find_element('id', 'pwdInput')
    
    @property
    def submit_element(self):
        return self.driver.find_element('id', 'loginBtn')
    
    def login(self, name, password):
        self.username_element.send_keys(name)
        self.password_element.send_keys(password)
        self.submit_element.click()
```



第三种方式可以充分利用Python的描述符特性，你会发现很多序列化库或者ORM框架都有类似的用法。

```python
class LoginPage:
    def __init__(self, driver)
    	self.driver = driver
        
    username = Element(css='#idInput', desc='用户名输入框')
    password = Element(css='#pwdInput', desc='密码输入框')
    confirm = Element(css='#loginBtn', desc='登录确认按钮')
    
   	def login(self, name, password):
        self.username.send_keys(name)
        self.password.send_keys(password)
        self.confirm.click()
        
```



而 Element 类可以通过 Python 描述符实现，这里为了方便，只定义了xpath的元素定位方法：

```python
class Element:

    def __init__(self,xpath=None,desc=''):
        self.xpath = xpath
        self.desc = desc

    def __get__(self, instance, owner):
        driver = instance.browser
        el = driver.find_element('xpath', self.xpath)
        return el
```





## PO模式和DDD



PO模式是DDD(领域驱动设计)的一个简单实现，但是还不够彻底。如果要在自动化测试中贯彻DDD，我觉得还有一些可以优化的空间。



首先某一个业务不一定只是单个页面的操作，比如登录不一定只涉及到LoginPage这个页面，因此直接在LoginPage中编写login函数就不是很合理。对于调用方来说，应该明确说明的是谁在登录，而不是指某个页面。像这样：

```python
user.login()
# or
login(user)
```

我们编写的代码就像是自然语言，任何懂英语的人都知道代码在做什么，在DDD中，叫做领域特定语言（DSL）， 要实现这种逻辑，在Page类和调用中间应该还会有一个层级来封装user。



其次，Page页面会依赖更底层的资源，比如组件，元素类型。因此在 Page 类的下方应该会使用 InputElement， ButtonElement 、SelectElement 这样的元素类和 HeaderComponent、FooterComponent 这样的组件类。

```python
class LoginPage:
	username_filed = InputElement('xxx')
	password_filed = PasswordElement('xxx')
```



领域驱动设计对于大型项目梳理业务、同步业务、沟通业务是非常有帮助的，是一种以业务为中心的设计范式。PO模式对于DDD的小范围应用，以及具体了足够多的好处：

- 便于维护。每一个页面的操作都被单独的存放在一个类文件中，当前端页面被修改之后，只需要找到对应类文件进行修改，其他的代码并不需要进行修改，这符合单一职责原则。
- 便于重复使用。在进行自动化测试的时候，一个测试由多个测试步骤组成，这些测试步骤可能涉及到多个页面的操作。而用例与用例之间的操作可能重合。PO模式可以重复利用这些测试步骤，简化代码的编写。
- 提高了可读性。页面的操作都被以函数的形式封装起来了。函数名就具备注释的作用，其他人阅读代码时可以通过函数了解业务。

