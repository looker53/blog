
Selenium 封装了现成的文件上传操作。但是随着现代前端框架的发展，文件上传的方式越来越多样。而有一些文件上传的控件，要做自动化控制会更复杂一些，这篇文章主要讨论在复杂情况下，如何通过自动化完成文件上传。


## 1. input 元素上传文件
如果页面需要文件上传，那么在大多数情况下，都能在页面源代码中找到一个input的元素。
```html
<input type="file" name="file_name">
```
如果能直接在页面当中看到这个input元素，那么通过 selenium 的 send_keys 方法就能完成文件的上传，在参数中传入本地文件的路径。

```python
driver.get('https://testpages.herokuapp.com/styled/file-upload-test.html')

el = driver.find_element('id', "fileinput")
el.send_keys('/path/of/file.png')
```


## 2. input 元素隐藏

opacity,  hidden,  display

## 3. 文件选择对话框

对于有一些元素，直接通过 selenium 自带的 send_keys 方法上传文件并不会成功。如果不想对input元素进行过多的分析，那么比较直接的方式是采用文件上传对话框来处理。

一般来说，如果需要上传文件，那么当你点击这个元素之后，会出现一个文件上传的对话框，要求你选择文件，并点击确定。这个对话框是属于系统的，因此selenium 无法直接控制它。我们可以采用系统的自动化工具或者直接调用键盘来操作这种对话框。

在操作对话框之前，首先我们通过 selenium 点击文件上传的元素。

```python
el = driver.find_element('id', "fileinput")
ActionChains(driver).click(el).perform()
```

input 元素并不能点击，所以不能用元素的 el.click() 方法，需要使用 ActionChains 下面的 click 方法。他们之间的区别在于元素的 el.click 方法更加严格，会对元素是否可见，是否可点击进行检测，在点击事件完全生效后，再执行下面的操作，如果不满足这些条件，可能会报错。 而 Action 下的 click 方法则粗暴得多，它几乎不对对元素进行检测，直接把鼠标移动到元素上方，执行点击操作，至于点击是否生效，根本不管。



## 4. 使用 pywinauto 上传文件
pywinauto 是Windows系统下的一个自动化工具,它可以直接获取到Windows系统下面的弹框,因此当文件上传的窗口出现之后，我们可以使用这个工具传入文件的路径,然后点击打开按钮。
```python
from pywinauto import Desktop

app = Desktop()
dialog = app['打开']  # 根据名字找到弹出窗口
dialog["Edit"].type_keys('/path/of/file.md')  # 在输入框中输入值
dialog["Button"].click()
```

另一种系统自动化工具叫做 pyautogui。这个工具最大的特点在于使用坐标系统定位元素，可以轻而易举的做到跨平台。不管你是Windows，mac还是Linux，都可以使用这款工具实现自动化。

但是这款工具目前不支持中文的输入，因此我们需要借助剪切板来实现中输入。首先我们把对应的中文复制到剪切板当中，然后再通过 ctrl + v 热键粘贴到文件路径输入框当中。

## 5. pyautogui

```python
 import pyperclip
 
 pyperclip.copy('D:\\用户.html')
 pyautogui.hotkey('ctrl', 'v')
 pyautogui.press('enter', presses=2)
```



## 6. 并发问题

通过系统窗口上传文件简单粗暴，但是当你的程序需要并发执行时，使用这种方式实现文件上传就比较麻烦了。如果你的程序需要并发执行，最好还是通过控制input元素，使用 send_keys 方法实现文件上传。

todo:
隐藏元素案例
pykeboard 上传