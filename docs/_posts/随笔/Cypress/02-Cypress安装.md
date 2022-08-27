使用 Cypress，只需要装两个依赖环境。



**第一个依赖环境是 Node.js。**



Cypress 是用 JS 开发的一个自动化测试框架，如果我们想去编写 cypress 的代码，我们首先需要有 JS 的环境。 JS 这门语言非常的奇特。以前编写 JS 的代码，一般是放到浏览器当中去运行。因为在浏览器里面执行安装了一个 JS 的解释器，通过这个解释器能够在浏览器端去执行各种各样不同的效果和交互操作。



但是如果想在浏览器外面执行 js 呢？那就要安装独立的js运行环境。在这个里面最典型的是由谷歌开发的这个叫做 node.js 。这个框架提供了一个叫做 v8 引擎的东西，这个 v8 引擎能够让我们在浏览器外面去执行 JS 的代码。



现在如果我们想去使用 cypress 这样的一个框架，首先我们要去安装  [Node.js](https://nodejs.org/zh-cn/) 的环境 。 直接进入 node 的官网。然后直接下载对应的版本，这里我推荐大家去下载长期支持版，当前发布版，有一些功能不太稳定。

![image-20220827174529247](C:/Users/muji/AppData/Roaming/Typora/typora-user-images/image-20220827174529247.png)

下载好以后要确保 node 命令可以使用，最好是设置操作系统的环境变量。以 windows 为例：首先进入我的电脑，右击属性，点击高级系统设置在下面有个环境变量。把 node 的安装目录设置到 Path 变量中，重新启动电脑让环境变量生效。



重启之后在命令行输入node命令，如果能显示命令提示，就代表安装成功了。

![image.png](https://s2.loli.net/2022/08/27/LWraATXS2wp3szN.png)

**第二个需要安装的依赖环境是 Cypress 包。**



Node 有一个包管理工具 npm， 使用这个工具完成 Cypress 包安装。在需要创建工程的目录下安装，比如我需要在 CypressNotes 下安装。先进入目录，运行 npm init -y 使用默认值得到 package.json来记录安装的包, 再 npm install cypress 安装。

```bash
cd CypressNotes
npm init -y
npm install cypress
```



需要注意的是，npm 有时候安装比较慢。如果出现网速慢无法安装成功，可以先通过 npm 安装 cnpm, 再通过 cnpm 安装 cypress。 cnpm 是国内镜像版，下载速度非常快。解压安装需要等待一段时间，耐心点。 

```bash
npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm install cypress
```



**好了，现在环境都准备就绪了，接下来看看怎么打开 Cypress 工程。**



安装好 cypress 以后，可以通过 cypress open 指令打开项目。 cypress 命令是没有直接添加到系统变量当中的，需要进入 node_modules 目录下去手工启动，但是这种操作方式有点复杂。

```
./node_modules/.bin/cypress open
```



**另一种更好更快捷的方式是通过 npx 运行。**



首先确认 npx 有没有安装，没有安装的话通过 npm install -g npx 安装。 安装完成后可以通过 npx cypress 直接运行 cypress 指令。



如果既不想用 npx, 又不想太麻烦，也可以在 package.json 中配置脚本命令：

```json
"scripts": {
    "cy": "node_modules/.bin/cypress"
}
```


  可以通过 npm run cy 运行了。        







 js 命令是否在我们 pass 目录里面。比如说现在我们去浏览现在系统变量。大家可以看到，在这里有一个叫做 node js 环境，我们直接点击确定就 OK 了。如果这里没有 node js 相关的环境变量，我们就需要把 node js 环境路径添加到环境变量当中。
点击确定。确定完了，我们可以重新启动我们的电脑。好，现在我们可以输入 cmd 命令。在这里去输入 1 个note。如果没有报错，基本上就说明我们这个note，已经正确安装成功了，我们可以查看一下 note 的版本，我的版本目前是十点15。我们可以再次去确认另外的一个指令这个指令，就叫做 m p mmpm 主要是 node js 当中的包管理工具之后，我们需要下载 cypress 这样的一个工具，其实就是由 mpm 区进行管理的。现在我们获取到 mpm 以后，我们可以去创建 1 个 cypress 自动化测试的项目。我们先 cd desktop。进入桌面这样的一个目录。然后我们输入mpm。 In it. Done what. 这样它就会给我去创建 1 个 node js 的项目。大家可以看到，他说我写了一个 package to jason，到了木，下面，我们现在可以到桌面去检查一下，看有没有package。很明显，这里，她就生出了jian。但是，现在我们没有创建成自己的项目，所以，我们要把 package jason，移动到 cypress day mole 这个文件下面。当然我也可以直接在命令行里面进入。 Cypress 这个目录然后运行M。Pm。 In it. 港外现在当我进入这 1 个界面以后，大家可以看到在这个里面多了一个 package 之间 jason 的文件好。
接下来我们就需要去安装 cypress 软件了。我们可以通过命令行 n p m install cypress。然后写一个 save 保存到我们现在的 package jason 这样的一个目录下面这个时候，他就会在这个地方去给我们去装 cypress 软件。好，直到等待它安装完成。这里我们可以先取消掉。
因为使用 mpm 这个工具去安装 cypress 在国内是非常慢的，所以我们需要使用一些在国内加速的这个操作，使用cmpm。这个 cm pm 可以给我们去提供 1 个镜像地址。然后我们使用 cmpm 去进行安装的时候，就会变得比较快。我们直接复制这一段代码去安装这段代码，主要是去安装 cmpm 这个软件的。这个时候我们用的工具还是mpm，当我们安装 cnpm 安装完成以后，我们可以使用 cmpm 去代替 mpm 工具。我们等待他安装完成。现在它已经安装了cmpm，我们就可以直接去使用。 C n p m install cypress. 尴尬safe。好，此时我们就可以使用 cmpm 这样的一个软件去安装cypress。安装完成了以后，在我们现在的这一个目录就会多 1 个叫做 no 的。 Models 这下面就会有很多的文件夹，这些文件讲大多数，这上面都是和 cypress 软件相关的。好这个过程可能会花费比较长的时间，因为，它需要解包的效率，比较慢，需要解刨的操作有一点点多，耐心等待完成就 OK 了。
当我们这个 cypress 安装以后，我们就可以直接进入 node package 里面去启动我们的cypress。我们直接输入 note 病。 Cypress 我们可以先用一个 help 查看 cypress 的香宦官的指令。然后我们可以用一个 open 指令去打开它的界面。 OK， 现在我们可以看到这个， cypress 的界面，我们先把提示框取消掉。
好这里面 examples 下面这个框架给我们列举的一些小势力，我们可以直接点击去运行。然后当你点击这一个文件的时候，他就是运行这里面的自动化测试的用例，当我们去点击这里，它就会运行所有的自动化测试的用例。而在上面有一些菜单栏供我们去选择。我们先去点击单个用例执行。既完成以后，在这里他会给我们去开一个谷歌浏览器，去帮我们去跑自动化测试的代码。左边是它的执行日志。右边是我们，整个去输入界面去控制浏览器的一个界面。好这个里面，因为我们访问的是国外的战，所以，速度会稍微有点慢。我们可以看到现在，它会把我们这一个浏览器的界面加载完成，左边他会在这里执行对应的指令。好，我们可以看到现在第一个用力，就已经通过了下面，他还会去接着执行其他的指令 OK 好，现在两个用例，都已经通过了，我们可以点击去查看每一步的效果。当我们把鼠标放到上面以后，大家会看到对应的操作，它就会变成这种灰色的。好，这是我们 cypress 的基础使用。



​     




​        
​         

```
  
```

​        
  系统会打开一个类似于编辑器的 cypress 界面:        
  ![image.png](https://i.loli.net/2020/10/09/mfbU5GQ3nHB1K4c.png)        
​         
  所有的测试用例存放在 integration tests 中，cypress 会默认生成一些 examples 示例，如果需要编写其他的测试用例，在 integration 目录下建立 js 文件就可以了。        
​         
  ![image.png](https://i.loli.net/2020/10/09/DiVZUKlY7sNjtyL.png)        
​         
​         
​         
  运行可以点击单个文件运行，也可以运行所有的。        
​         
  ![image-20201106172501535](file:///C:/Users/muji/AppData/data/typora-pic/image-20201106172501535.png)        
​         
  默认用例看效果，左边可以点击查看运行步骤，右边是屏幕显示：        
​         
  ![image-20201106172332542](file:///C:/Users/muji/AppData/data/typora-pic/image-20201106172332542.png)        
​         
​         
​         
  **cypress 的其他指令可以通过 --help 查看**：        
​         

```
  ./node_modules/.bin/cypress --help
```

- ## npx 运行


    npx 可以更加快捷的运行 cypress 命令，首先确认 npx 有没有安装，没有安装的话通过 npm install -g npx 安装。 安装完成后可以通过 npx cypress 直接运行 cypress 指令。        
  ​         
  ​         
  ​         
    还有一种方式是再 package.json 配置 npm 命令。        
  ​         

  ```
    "scripts": {
    "cy": "node_modules/.bin/cypress"
    },
  ```


    可以通过 npm run cy 运行了。        

- ## Cypress 的代码结构说明

  ​        
    ![image-20201106174622811](file:///C:/Users/muji/AppData/data/typora-pic/image-20201106174622811.png)        

- ## 编写第一个测试用例

  ​        
    打开 vscode， 在 interation 目录下创建一个 hello.js 文件。 在 cypress 的交互界面点击这个文件就可以运行。        
  ​         
    运行结果会报错 No tests found in your file, 因为我们还没有编写任何的测试步骤。        
    ![image.png](https://i.loli.net/2020/10/09/dAI1gehEDCQijWb.png)        
  ​         
  ​         
    在 hello.js 中编写测试代码：        
  ​         

  ```
    describe('这是我的第一条用例', () => {
    it('1等于1', () => {
        assert(1==1, "1 not equal to 1")
    });
    it('1不等于2', () => {
        assert(1 != 2, "1 not equal to 2")
    });
    })
  ```

- describe 表示测试用例场景

- it 表示详细的测试点

- assert 是断言

- 这里用到了 es6 的箭头函数，也可以写成 function() 的形式      

  ​        
    这些语法是 JavaScript 中的测试框架 [Mocha](https://mochajs.org/#bdd) 的用法。 Mocha 除了可以用 describe 这些 bdd 的形式，还可以用 suite 和 test 这样的 tdd 形式，但是在 Cypress 中不直接支持。        
  ​         
    断言使用的是 [Chai](https://docs.cypress.io/guides/references/assertions.html#Chai), 同样支持 bdd 和 tdd, 现在暂且用这种断言，后面可以换用其他的形式。        
  ​         
  ​         
    编写代码完成以后，再次点击 cypress 界面中的 hello.js， 就可以出现测试页面了。        
  ​         
    ![image.png](https://i.loli.net/2020/10/09/pi2sjIMLEUa1SA6.png)        
  ​         
  ​         
    再编写一个断言不成功的情况：        
  ​         

  ```
    it('1等于3', () => {
          assert(1==3, "1 not equal to 3")
      });
  ```

  ​        
    则断言失败的部分会用红色标明：        
    ![image.png](https://i.loli.net/2020/10/09/jBIWCQGYt29sHrm.png)        

- ## 代码提示

  ​        
    cypress 封装的方法默认是没有代码提示的。如果需要代码提示，最简单的方式是在文件的开头加一个特殊注释：        
  ​         

  ```
    /// <reference types="Cypress" />
  ```

  ​        
    这时候就可以看到 cy 下面的 api 了哦：        
  ​         
    ![image-20201106175754325](file:///C:/Users/muji/AppData/data/typora-pic/image-20201106175754325.png)        
  ​         
  ​         
  ​         
    在 vscode 里面，如果你不想每次都在文件开头加注释，可以新建一个 jsconfig.json 文件，加上以下配置，效果是一样的。        
  ​         

  ```
    {
    "include": [
        "/node_modules/cypress",
        "cypress/**/*.js"
    ]
    }
  ```


  ​         
  ​         
    你也可以在 vscode 中安装 cypress snippets 插件，安上以后，可以自动完成 it 等语法规则：        
  ​         
    ![image-20201106175945629](file:///C:/Users/muji/AppData/data/typora-pic/image-20201106175945629.png)