---
title: 11-Python函数应该怎么写
date: 2022-08-26 19:18:38
permalink: /pages/87dbc4/
sidebar: auto
categories:
  - 日记
tags:
  - 
---
## Python函数的定义
函数是代码封装的一种手段，函数中包含一段可以重复执行的代码，在需要用到这些代码时，只需要调用函数，就会运行函数中的代码。

python 函数这么定义：

```python
def 函数名称(参数1, 参数2)：
	函数体（要运行的代码）
```


比如一个很简单的函数定义：

```
def add(a, b):
	return a + b
```



现在我们举个例子说明函数的作用。

```
print('打开高级车门')
print('开发动机')
print('安全带')
print('踩油门')
print('掌握方向')
```
如果要开很多次车，那么每次都需要敲相同的 5 行代码，这样会造成几个问题：

- 很容易编写不同的代码，或者代码出现错误
- 代码冗余，可读性不强
- 不容易维护，当需要修改某个步骤时，要修改多处。



## Python函数的调用


现在我们可以把上述代码封装在函数中，当需要运行这些代码时，调用函数就可以了，这样减少了很多复制粘贴或者手工编写多行代码的步骤，函数的名称也表明了代码的作用，当需要修改部分逻辑，只需要修改函数体就可以了。

```python
def run_car():
    print('打开高级车门')
    print('发动发动机')
    print('系上安全带')
    print('踩油门')
    print('掌握方向')

run_car()
# 其他代码
run_car()
```


## Python函数的返回值

return 表示当函数执行完之后，想让函数外面的程序得到函数执行的结果， return 的值可以任意的数据类型。

```
def add(a, b):
	return a + b

result = add(3,4)
print(result)
```
- 函数体当中的代码， 遇到 return 会终止运行。
- 函数的返回结果可以是任意类型，包括 None
- 当函数体当中没有 return ，默认返回 None



Python函数可以返回多个值， 只需要在多个值之间加上逗号，得到的是元组类型。

```python
def add(a, b):
	return a, b
```





## 参数的四种类型
return 表示函数返回给外部的值，而参数表示函数从外部接收的值。在函数定义时候的参数叫做形式参数，它其实就是一个变量名称，在函数调用时候的参数叫做实际参数，相当于给变量赋值。

```python
def get_coffee(suger):
    if suger > 100:
        return '甜咖啡'
    elif suger < 1:
        return '美式'
    else:
        return '莫名其妙的咖啡'

result = get_coffee(100)
print(result)
```



注意，形式参数的个数和实际参数的个数要一样，而且顺序要一致，这种方式叫做位置参数。（和领导吃饭做位置）如果形式参数和实际参数的个数不一致，会导致程序无法分别赋值：

```python
def add(a, b):
    c = a + b - 1
    return c

add(5, 7, 8) # NO
```



关键字参数：在调用函数的时候，做一个关键字标记，以防传参错误，造成损失。主要是当参数很多的情况，你记不清顺序，关键字去标识数据的意思。



默认参数：在函数定义的时候，给某个变量直接赋值，成为默认值。 就是使用默认值直接赋值，在调用函数的时候，可以少传参数。关键字参数，默认参数也好，都必须放到位置参数的后面。



```python
def add(a, b=0):
    c = a + b - 1
    return c

add(a=4, b=6)
add(3)
```


自动化测试场景：添加多个数据，运行多个用例

```python
def write_case(number):
    for _ in range(number):
        username = input("请输入用户名:")
        password = input("请输入密码:")
        age = input("请输入年龄:")

        user = dict()
        user.update(username=username,
                    password=password,
                    age=age)
        yield user

def run(case):
    print(f"运行用例-用户名{case['username']}")

    cases = write_case(2)
    for case in cases:
        run(case)
```


