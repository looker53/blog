---
title: Selenium关键字驱动：Python装饰器实现
date: 2022-03-17 19:28:59
permalink: /pages/b482e1/
sidebar: auto
categories:
  - 测试
tags:
  - 关键字驱动
  - selenium
  - pytest
  - 装饰器
---



关键字驱动比较核心的问题有两个：

- 用户如何调用
- 关键字如何注册和绑定



用户维护一张关键字表格，代码需要执行的测试步骤，每一步包含浏览器需要执行的操作以及需要用到的参数。

```
访问  https://jiubing.site
点击  id为su的元素
输入  name为accout的元素   输入“my name"
输入  name为pass的元素     输入“secret"
```

可以用yaml文件存储表格数据，还算方便。

```yaml
# login.yaml
-
  action: 访问
  params:
    url: "https://petstore.octoperf.com/actions/Account.action?signonForm="
-
  action: 输入
  params:
    locator: ['name', 'username']
    words: 'yuze'
-
  action: 输入
  params:
    locator: ['name', 'password']
    words: '1234'
-
  action: 点击
  params:
    locator: ['name', 'signon']
```



## 关键字和浏览器操作映射

用户选择关键字时，浏览器执行这个操作，一种直接的方式是让关键字和浏览器方法同名。 当用户使用「访问」关键字时，调用浏览器的「访问」方法，此时浏览器的封装类似于这样：

```python
class Browser:
    def 访问(url):
        pass
    def 输入(locator, words):
        pass
    def 点击(locator):
        pass
```

这种方式没什么问题，当时如果想让这种映射关系更灵活一点，可以使用装饰器来注册关键字。

```python
class Browser:
    
    @keyword('访问')
    def goto(url):
        pass
    
     @keyword('填写')
     @keyword('输入')
    def fill(locator, words):
        pass

    def click(locator):
        pass
```

这么写有2点好处：

1.  一个浏览器方法支持对应多个关键字，有利于后期维护；
2. 有些浏览器操作不想暴露给外部，则可以不注册关键字。



## 装饰器实现关键字封装

定义 bind 函数，实现关键字和浏览器操作的绑定。

```python
keywords = dict()

def bind(keyword, action):
    keywords.setdefault(keyword, action)
```

比如用户选择「访问」关键字，调用 goto 方法，则调用 `bind('访问', Browser.goto)`， 如果不用装饰器，这样手工绑定是完全没问题的，只是缺少一点灵活性，现在编写一个装饰器，把 bind 函数嵌在里面：

```python
def keyword(name=None):
    def wrapper(func):
        nonlocal name
        # 没传关键字时，默认用方法名称绑定
        if name is None:
            name = func.__name__
        bind(name, func)
        return func
    return wrapper
```

有了关键字，就可以像这样注册关键字了。

```python
class Browser:

    @keyword('点击')
    @keyword()
    def click(self, locator):
        print(f"{self.driver} is clicking {locator}")
```



## 通过关键字执行用例

关键字表格就是一个列表嵌套字典的表格，通过 for 循环能直接得到每一步的浏览器操作和需要的参数。 step['name'] 表示选择的关键字操作，通过 keywords.get() 可以获取到对应的浏览器操作 action，step['args'] 表示需要的参数。

```python
def run_events(browser, keywords_sheet):
    """使用浏览器调用关键字"""
    for step in keywords_sheet:
        action = keywords.get(step['name'])
        if not action:
            raise ValueError(f'关键字未注册:{step["name"]}')
        action(browser, **step['args'])
```

比如，选用的关键字表格如下：

```python
kw_sheet = [
        {'name': '点击', 'args': {'locator': ['id', 'idvalue']}}
    ]
```

- 通过 action = keywords.get(step['name']) 从已经注册的关键字中查询「点击」关键字对应的方法是 click， 
- click(browser, locator=['id', 'idvalue']) 就会调用 browser 对象的click 方法执行浏览器操作。



为了规范，最好通过模型类规范用户传入的数据只有 name 和 args 两段数据，通过模型更容易让人理解，可以使用 namedtuple 声明用户传入的表格信息。

```python
class KeywordInfo(NamedTuple):
    name: str 
    args: dict
```



将 run_events 函数稍微改一下，调用过程只需要一步：

```python
def run_events(browser, keywords_sheet):
    for step in keywords_sheet:
        keyword_info = KeywordInfo(**step)
        action = keywords.get(keyword_info.name)
        action(browser, **keyword_info.args)
        
kw_sheet = [
        {'name': '点击', 'args': {'locator': ['id', 'idvalue']}}
    ]
run_events(Browser(), kw_sheet)
```



## yaml 关键字

用户的关键字最终通过 yaml 形式存储，我们直接从yaml中读取数据转化成 kw_sheet 这种数据类型，最终的调用过程就是这样：

```python
sheet = load(yaml_file)
run_events(browser, sheet)
```

而yaml的读取非常容易实现：

```python
def load(yml_file):
    with open(yml_file, encoding='utf-8') as f:
        return yaml.safe_load(f)
```



## 最终代码

```python
from typing import NamedTuple
import yaml

keywords = dict()


def bind(keyword, action_name):
    keywords.setdefault(keyword, action_name)


def keyword(name=None):
    def wrapper(func):
        nonlocal name
        if name is None:
            name = func.__name__
        bind(name, func)
        return func
    return wrapper


def load(yml_file):
    with open(yml_file, encoding='utf-8') as f:
        return yaml.safe_load(f)


def run_events(browser, keywords_sheet):
    """运行事件。 使用浏览器调用事件"""
    for step in keywords_sheet:
        keyword_info = KeywordInfo(**step)
        action = keywords.get(keyword_info.name)
        action(browser, **keyword_info.args)


class Browser:
    def __init__(self, driver):
        self.driver = driver

    @keyword('访问')
    def goto(self, url):
        print(f"{self.driver} is going to {url}")

    @keyword('点击')
    def click(self, locator):
        print(f"{self.driver} is clicking {locator}")

    @keyword('输入')
    def fill(self, locator, words):
        print(f"{self.driver} is filling {locator} with {words}")

class KeywordInfo(NamedTuple):
    name: str
    args: dict


if __name__ == '__main__':
    sheet = load('login.yaml')
    run_events(Browser('driver'), sheet)
```



login.yaml 的内容：

```yaml
-
  name: 访问
  args:
    url: "https://petstore.octoperf.com/actions/Account.action?signonForm="
-
  name: 输入
  args:
    locator: ['name', 'username']
    words: 'yuze'
-
  name: 输入
  args:
    locator: ['name', 'password']
    words: '1234'
-
  name: 点击
  args:
    locator: ['name', 'signon']
```

