遇到网页加载慢，selenium运行效率降低，可以通过修改页面加载策略提升自动化效率。

## selenium加载很慢

通过URL导航到新页面时，默认情况下，Selenium将等待文档完全被加载才会执行下面的操作，此时网页的加载状态为 complete。

这种状态可以在浏览器中通过document.readyState获取，当网页没有完全加载时，显示为interactive，加载完成后显示complete。页面加载完成后，再试图访问其他JavaScript 动态加载的内容。

![image-20220314175512786](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220314175512786.png)



如果网页打开速度很慢，可能是由于加载了一些非常耗时的内容，比如图像、css文件和JS文件，此时会在页面中出现正在加载的圈圈。

![image-20220314174833035](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220314174833035.png)



## 修改pageLoadStrategy

Selenium 会等待这些内容加载完成，才会执行下面的操作。如果每个页面都这么慢，无疑很影响自动化测试的效率。

此时，我们可以修改Selenium的加载策略，让浏览器不加载图片、CSS和JS等文件，就执行之后的操作。

```python
def start_chrome():
    option = ChromiumOptions()
    #修改加载策略为eager
    option.page_load_strategy = 'eager'
    driver = webdriver.Chrome(options=option)
    return driver
```



浏览器的加载策略可以设置成以下的方式：

| 策略   | Ready State | 备注                                                  |
| ------ | ----------- | ----------------------------------------------------- |
| normal | complete    | 默认值，等待所有资源加载完成。                        |
| eager  | interactive | DOM已经准备完成，但是图片等其他外部文件资源未被加载。 |
| none   | Any         | 不等待任何资源加载                                    |



## 应用

在网页加载比较慢的情况下，把加载策略pageLoadStrategy设成eager或者none能有效提升自动化脚本的速度，但是这种方式不是十全十美的，由于还有资源没有加载完成，它可能会导致之后的元素定位失败，从而造成脆弱的测试。在实践中还是应该结合具体情况来设置。

一般使用默认加载策略，只有部分页面确实非常耗时，并且未加载的元素不会影响后面的定位才会视图修改加载策略。