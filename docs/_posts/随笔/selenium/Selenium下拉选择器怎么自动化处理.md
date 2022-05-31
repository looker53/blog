---
title: Selenium下拉选择器怎么自动化处理
date: 2022-03-11 15:56:10
permalink: /pages/425e08/
sidebar: auto
categories:
  - 测试
tags:
  - selenium
---
## 1. 点击 Select 下拉框选项元素

```python
url = 'https://testpages.herokuapp.com/styled/basic-html-form-test.html'
driver.get(url)

select = driver.find_element('name', "dropdown")
option = select.find_element('xpath', '(//option)[2]')
option.click()
```



## 2. 使用 Select 类

## 3. 如何多选

```python
option1 = driver.find_element('xpath', '//option[@value="ms1"]')
option1.click()

option2 = driver.find_element('xpath', '//option[@value="ms2"]')
option2.click()
```



## 4. input 元素的选择器

```python
url = 'https://element.eleme.cn/#/zh-CN/component/select'
driver.get(url)

s = driver.find_element(By.XPATH, '//input[@placeholder="请选择"]')
driver.execute_script('arguments[0].readOnly=false; arguments[0].value="双皮奶"', s)
```



## 5. input 选择器如何多选

点击

## 其他元素的选择器

```python
url = 'https://bulma.io/documentation/components/dropdown/#'
driver.get(url)

option1 = driver.find_element(By.XPATH, '//span[text()="Dropdown button"]/..')
option1.click()

option1 = driver.find_element(By.PARTIAL_LINK_TEXT, 'Other dropdown it')
option1.click()
```



## 6. 需要 Ctrl 键的选择

https://letcode.in/selectable



下拉框， 选择器， dropdown, 下拉选择框