既然是新用法，肯定是在其他地方不会随处见到的，搞不好还是独一份。



Appium 的放大缩小操作经历了几次大的改版，已经改的面目全非，绝大多数的老教程现在已经失效。最开始 Appium 提供了现成的方法可以直接调用，后来又全部转移到 MultiAction 这个类中，大多数的教程都是基于 MultiAction 这个类实现放大缩小功能。



但是在新版的 Appium 中，MultiAction 这个类被移除了，甚至 TouchAction 这个类也移除了，直接导致现有的教程全部失效。从 2.0 版本后，全部都要使用 w3c action 来代替。
![img](https://img-blog.csdnimg.cn/27e159e797074d5a8fec7c23d0aa9f29.png)



# w3c 操作



所谓的 w3c action，是 w3c 给 webdriver 提供的一套底层接口，用于向web浏览器提供虚拟设备输入。从概念上讲，本地发送一系列动作，这些动作对应于每个输入设备在每个时期的状态变化。
![img](https://img-blog.csdnimg.cn/5972300901764a8f9473dd9c5c9f450d.png)



例如，click 点击由一个输入设备(鼠标)和两个记号组成的动作序列（pointerDown、pointerUp）表示，第一个包含按键向下动作（pointerDown），第二个包含按键向上动作（pointerUp）。



而不论是缩小和放大，都是由两个输入设备（手指1，手指2）和三个记号组成的动作序列表示，每个手指依次执行：



- pointerDown，两个手指按下
- pointerMove，两个手指向相反方向移动

- pointerUp，两个手指抬起。
  ![img](https://img-blog.csdnimg.cn/d1cb52e3d9fc4334a1dc6a61575a3f28.png)



# 现成的参考案例



Appium 本身已经基于 w3c action 封装了两个常用的方法，一个是 swipe ，另一个是 tap 方法，在实现放大缩小功能时，我们不需要自己从 0 到 1 实现，而是借助这两个已经封装完成的方法，修改一下。



首先看 tap 操作的源码：
![img](https://img-blog.csdnimg.cn/f8c62296088a4dc6a4ec0665260c37b3.png)



- 第 134 行，初始化了一个虚拟设备，也就是触屏操作当中的一个手指，如果有多个手指，就初始化多次。
- 第 135 行，手指移动到一个坐标位置

- 第 136 行，手指按下屏幕
- 第 137-140 行，手指停顿

- 第 141 行，手指抬起。



可以发现，tap 的操作完全是基于流程图中的 3 个子操作完成的。因此我们可以使用同样的思路实现方法功能。



# 如何完成放大



- 1、使用 add_point_input 添加手指，放大需要用到两个手指。
- 2、使用 create_pointer_move 移动到屏幕的正中间

- 3、使用 create_pointer_down 按下手指
- 4、使用 create_pointer_move 往屏幕相反方向移动

- 5、使用 create_pointer_up 松开手指



具体实现放大功能的代码如下：

```python
def zoom(driver: Remote, step=0.5, duration=None):
    actions = ActionChains(driver)
    actions.w3c_actions.devices = []
    finger1 = actions.w3c_actions.add_pointer_input('touch', f'finger1')
    finger2 = actions.w3c_actions.add_pointer_input('touch', f'finger2')

    width = driver.get_window_size()['width']
    height = driver.get_window_size()['height']

    for finger in [finger1, finger2]:
        finger.create_pointer_move(x=width*0.5, y=height*0.5)
        finger.create_pointer_down(MouseButton.LEFT)
        if duration:
            finger.create_pause(duration / 1000)
        else:
            finger.create_pause(0.1)

    finger1.create_pointer_move(x=width*0.5, y=height*(0.5+step/2))
    finger2.create_pointer_move(x=width * 0.5, y=height * (0.5-step/2))

    finger1.create_pointer_up(MouseButton.LEFT)
    finger2.create_pointer_up(MouseButton.LEFT)

    actions.perform()
```



调用 zoom 方法实现图片放大操作：

```python
caps = {
    'platformName': 'Android',
    'udid': 'emulator-5554',
    'appPackage': 'com.android.gallery3d',
    'appActivity': '.app.GalleryActivity'
}

driver = Remote(desired_capabilities=caps,
                command_executor='http://127.0.0.1:4723/wd/hub')
driver.implicitly_wait(8)
driver.find_element('id', 'com.android.gallery3d:id/gl_root_view').click()

zoom(driver,step=0.5)
driver.quit()
```



# 如何完成缩小



实现缩小的时候，代码完全可以使用放大功能的代码，只是两个手指先移动到屏幕两端，往中间缩，整个移动的过程相反。

```python
def pitch(driver: Remote, step=0.5, duration=None):
    actions = ActionChains(driver)
    actions.w3c_actions.devices = []
    finger1 = actions.w3c_actions.add_pointer_input('touch', f'finger1')
    finger2 = actions.w3c_actions.add_pointer_input('touch', f'finger2')

    width = driver.get_window_size()['width']
    height = driver.get_window_size()['height']

    finger1.create_pointer_move(x=width * 0.5, y=height*(0.5+step/2))
    finger2.create_pointer_move(x=width * 0.5, y=height * (0.5-step/2))

    for finger in [finger1, finger2]:
        finger.create_pointer_down(MouseButton.LEFT)
        if duration:
            finger.create_pause(duration / 1000)
        else:
            finger.create_pause(0.1)
        finger.create_pointer_move(x=width * 0.5, y=height *0.5)
        finger.create_pointer_up(MouseButton.LEFT)

    actions.perform()
```







# 总结



随着 Apppium2.x 发布的临近，appium 很多的操作 API 都有比较大的变化，很多之前很有用的教程可能会逐渐失效。



我在之前也是使用 MultiAction 实现放大缩小，但是为了和新版匹配，还是尽早切换成新用法。在编写这套代码前，我也翻阅了很多资料，想找到现成的代码直接套用，但是没有找到，因此才自己实现。



在实现之前，我首先从源代码的警告提示中获得线索，阅读了appium官方提供的 w3c actions 说明。但我发现这个说明不详细，于是又从官方文档摸到了 w3c actions spec 文档阅读，终于理清楚了它的运行机制。



有了理论的支撑，我便尝试在现有框架的源码实现中找灵感，我发现 tap 方法和 swipe 方法都有非常大的借鉴意义。通过这两个方法的源码，我搞清楚了触控操作的大概实现思路和代码编写套路。



之后如果遇到类似的问题，也有一套行之有效的方法可以照着做了。