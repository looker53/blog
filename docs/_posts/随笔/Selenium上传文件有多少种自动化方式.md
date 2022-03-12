---
title: Selenium上传文件有多少种自动化方式
date: 2022-03-11 17:02:49
permalink: /pages/cd7e5c/
sidebar: auto
categories:
  - 随笔
tags:
  - 
---




## 1. input 元素上传文件

```python
driver.get('https://testpages.herokuapp.com/styled/file-upload-test.html')

el = driver.find_element('id', "fileinput")
el.send_keys()
```



## 2. input 元素隐藏

opacity,  hidden,  display

## 3. 文件选择对话框

```python
el = driver.find_element('id', "fileinput")
ActionChains(driver).click(el).perform()
```

不能用 el.click() , why





## 4. pywinauto

```python
from pywinauto import Desktop

app = Desktop()
dialog = app['打开']  # 根据名字找到弹出窗口
dialog["Edit"].type_keys('/path/of/file.md')  # 在输入框中输入值
dialog["Button"].click()
```



## 5. pyautogui

```python
 import pyperclip
 
 pyperclip.copy('D:\\用户.html')
 pyautogui.hotkey('ctrl', 'v')
 pyautogui.press('enter', presses=2)
```



## 6. 多并发

选择 对话框
