---
title: Appium 多设备运行
date: 2022-05-31 15:19:58
permalink: /pages/c64f6f/
sidebar: auto
categories:
  - 测试
tags:
  - appium
---
# Appium多设备运行

# appium 自动化测试并发执行用例

在网上有很多关于 appium 并发执行自动化测试用例的文章，但是很少有在实际工作场景中正确运行起来的。

先看一下在 youtube 上播放很高的 2 个教学视频：

- [https://www.youtube.com/watch?v=QcMCfdE_AmE](https://www.youtube.com/watch?v=QcMCfdE_AmE)
- [https://www.youtube.com/watch?v=HCe0hu8VMs8](https://www.youtube.com/watch?v=HCe0hu8VMs8)

这两个视频都是兼容性测试，一个用例用两个设备执行。

还有国内其他的教程，只是上面两个教程的复杂版本。代码变复杂了，但是功能还是兼容性测试。我们来看下这些教程有哪些可以优化的空间。

第一点，有些教程需要根据设备自动启动 appium 服务。大多数的教程通过自己封装命令行的形式启动启动。

```
class ManageAppiumServer:
    def start_appium_server(self,port=4723):
        command = "node {0} -p {1} -g {2} " \
                  "--session-override " \
                  "--local-timezone " \
                  "--log-timestamp & ".format(self.server_apth, port, appium_log_path)
        subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE,shell=True).communicate()
```

这样其实不利于 appium 服务的管理，有时候你需要判断服务的状态等等操作，在 python 的库中早就已经封装了对应的 AppiumService 类来实现。

```
from appium.webdriver.appium_service import  AppiumService
def start_server():
    service = AppiumService()
    # 启动
    service.start(args=['-p 3723'])
    # 判断是否在运行
    service.is_running()
    # 关闭
    service.stop()
```

第二点，需要手动编写多线程或者多进程程序运行代码。

第三点，需要编写 pytest 命令行配置参数指定 caps 信息运行。

# 多设备单进程兼容测试

我自己通过 pytest-xdist 实现了一个简单版本的兼容性测试。假设现在电脑上连接了 2 台设备，我可以在 fixture 中配置参数，指定 2 台手机的名称，然后通过在 desired_caps 中设置 udid 来指定设备的唯一识别号。

```
import pytest
from appium.webdriver import Remote

@pytest.fixture(params=['emulator-5554', 'emulator-5556'])
def appium_driver(request):
    """获取 app 的driver"""
    desired_caps = dict()
    desired_caps['app'] = 'D:\lemon_app_webview_debug.apk'
    desired_caps['platformName'] = 'Android'
    desired_caps['udid'] = request.param
    driver = Remote(desired_capabilities=desired_caps,
                    command_executor='http://127.0.0.1:4723/wd/hub')
    driver.implicitly_wait(10)
    yield driver
    driver.quit()
```

这样，每个用例都会使用这两个设备运行一遍。但是现在没有开启并发，所以会先通过第一个设备运行用例，再通过第二个设备运行用例，同时只有一个设备启动。

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5b844977-87b1-4d82-8886-73c2de9fa150/Untitled.png)

# 多设备多进程兼容测试

自动化测试的用例，多复制几个，每个用例函数会被执行 2 次， 使用 `pytest -n 2` 执行用例：

```
from appium.webdriver.common.mobileby import MobileBy

def test_device1(appium_driver):
    """测试设备"""
    appium_driver.find_element(MobileBy.ID, "com.lemon.lemonban:id/navigation_my").click()
    appium_driver.find_element(MobileBy.ID, "com.lemon.lemonban:id/fragment_my_lemon_avatar_layout").click()
    appium_driver.find_element(MobileBy.ID, "com.lemon.lemonban:id/et_mobile").send_keys('1111')
    appium_driver.find_element(MobileBy.ID, "com.lemon.lemonban:id/et_password").send_keys('1111')
    appium_driver.find_element(MobileBy.ID, "com.lemon.lemonban:id/btn_login").click()

    toast = appium_driver.find_element(MobileBy.XPATH, "//android.widget.Toast")
```

![https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20210902_appium%E5%A4%9A%E8%AE%BE%E5%A4%87%E5%A4%9A%E8%BF%9B%E7%A8%8B%E7%9A%84%E5%85%BC%E5%AE%B9%E6%80%A7%E6%B5%8B%E8%AF%95.gif](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20210902_appium%E5%A4%9A%E8%AE%BE%E5%A4%87%E5%A4%9A%E8%BF%9B%E7%A8%8B%E7%9A%84%E5%85%BC%E5%AE%B9%E6%80%A7%E6%B5%8B%E8%AF%95.gif)

注意，这种兼容性测试不能和 parametrize 参数化同时使用，因为是同时把一个设备号分配给了多个 worker 执行，这显然是不行的。

# 多设备多进程并发测试

appium 并发测试， 使用 `pytest -n 2` 执行用例：

```
devices = ['emulator-5554', 'emulator-5556']

@pytest.fixture
def appium_driver_parallel(worker_id):
    """获取 app 的driver"""
    desired_caps = dict()
    desired_caps['app'] = 'D:\lemon_app_webview_debug.apk'
    desired_caps['platformName'] = 'Android'
    index = int(worker_id[2:])
    desired_caps['udid'] = devices[index]
    driver = Remote(desired_capabilities=desired_caps,
                    command_executor='http://127.0.0.1:4723/wd/hub')
    driver.implicitly_wait(10)
    yield driver
    driver.quit()
```

可以直接使用参数化：

```
import  pytest
@pytest.mark.parametrize('data', [111,222,333])
def test_device1(appium_driver_parallel, data):
    pass
```

但是现在的情况是，用户使用的夹具是限定死的，如果用户不想使用并发执行，又需要把所有的夹具都换掉。所以我们用一个统一的夹具，如果用单进程，则默认选择第一个设备，如果是多进程，根据索引获取对应设备。

```
devices = ['emulator-5554', 'emulator-5556']

@pytest.fixture
def appium_driver(worker_id):
    """获取 app 的driver"""
    desired_caps = dict()
    desired_caps['app'] = 'D:\lemon_app_webview_debug.apk'
    desired_caps['platformName'] = 'Android'

    if worker_id == 'master':
        # 不使用并发，默认获取第一个设备
        desired_caps['udid'] = devices[0]
    else:
        # 并发，第一个 worker 分配第一个设备
        # 第二个 worker 分配第二个设备
        index = int(worker_id[2:])
        desired_caps['udid'] = devices[index]

    driver = Remote(desired_capabilities=desired_caps,
                    command_executor='http://127.0.0.1:4723/wd/hub')
    driver.implicitly_wait(10)
    yield driver
    driver.quit()
```

如果没有用 pytest-xdist，会默认选择第一个设备，通过 master 来工作，如果使用 pytest-xdist, 则根据 worker 来分配设备执行，hw0, 使用第一个设备， hw1 使用第二个设备...

这种方式你可以改变夹具的 scope 照样适用。

```
@pytest.fixture(scope='class')
def appium_driver(worker_id):
	...
```

![https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20210902_appium%E5%A4%9A%E8%AE%BE%E5%A4%87%E5%A4%9A%E8%BF%9B%E7%A8%8B%E5%B9%B6%E5%8F%91%E6%89%A7%E8%A1%8C%E7%94%A8%E4%BE%8B.gif](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/20210902_appium%E5%A4%9A%E8%AE%BE%E5%A4%87%E5%A4%9A%E8%BF%9B%E7%A8%8B%E5%B9%B6%E5%8F%91%E6%89%A7%E8%A1%8C%E7%94%A8%E4%BE%8B.gif)

# 参考

- [运行效果视频](https://www.aliyundrive.com/s/WKNMoZrGSv7)