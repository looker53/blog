看过网上很多对Web Service的解释，有些文章写得通俗易懂，但是缺少深度解读；有的文章图文并茂，但是没有现成案例；有的文章非常详细，但是没有直观感受。



于是，我想从测试一个web service接口的角度，写一篇比较系统的文章，来进一步认识web  service。



## Web Service服务是什么

首先要知道什么是Service，才能理解 Web Service。

服务（Service）是计算机提供的某种功能，在以前的计算机中，通常以后台程序（Daemon)的形式存在。比如，在计算机中可以安装MySQL服务，提供访问数据库的功能；在计算机中安装SSH服务，提供远程连接的功能。



服务可以分为两种：本地服务和网络服务。本地服务是在当前计算机上能访问的服务，其他计算机无法访问；网络服务是在另一台计算机上提供服务，其他计算机通过网络连接访问服务，网络既可以是远程的web服务，也可以是局域网服务。

（图）



举个例子，我想做一个书籍阅读的App，我已经把书籍的展示页面，收藏书籍这些功能都实现了，但是我既不是写作者，也不是出版社，我根本就没有任何的新闻内容可以展示到 App 上。



我想了两个办法：第一个办法就是把我现在已经有的书籍录入到App中，用户安装我的App后，不需要联网也是可以阅读书籍的，我提供的书籍数据这种服务就是本地服务。



第二个办法是我直接和出版社合作，直接通过出版社提供的网络服务获取书籍内容，我的App只负责展示，当用户需要某本书籍时，通过访问出版社提供的服务就能得到书籍内容。



这种通过网络去获取其他电子内容的服务就是Web Service。通过这种方式，我还可以实现服务聚合（Service Mashup），同时和多个出版社合作，我可以自己实现一套统一的 Web Service接口，对接不同的出版社内容。任何形式的网络服务，不管返回HTML、JSON、XML还是图片，都是Web Service。





## Web Service原理

本质上来说，Web Service就是提供一个数据服务，而其他客户端应用通过网络来获取数据，这些客户端可以是浏览器，可以是手机App，可以是桌面应用，可以是电视盒子，可以是智能手表。

请求服务和响应服务的数据格式由双方制定（实际上一般由服务方指定，客户端按照要求操作），可以是 HTML，可以是 JSON，也可以是XML等其他格式。

![image-20220316165341398](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220316165341398.png)



实现Web Service的技术架构主要有两种方式：

- REST，使用统一的无状态操作集来表示web资源，目前的主要数据格式是JSON，但也可以使用XML。
- 非REST，服务可以不使用统一的指令集，进行任意的组合操作，比如RPC。

广义上的 Web Service 几乎包括了所有的网络服务，而我们平时谈论的Web Service，是特指 W3C 定义的概念。

> A Web service is a software system designed to support interoperable machine-to-machine interaction over a network. It has an interface described in a machine-processable format (specifically WSDL). Other systems interact with the Web service in a manner prescribed by its description using SOAP messages, typically conveyed using HTTP with an XML serialization in conjunction with other Web-related standards.

概括下重点就是说：Web Service通过WSDL描述了一个网络通讯接口，其他的系统可以使用SOAP协议和web service交互数据，SOAP基于HTTP实现，并且使用XML来组织数据。



有点难理解对不对，接下来我们一一解释。



## Web Service协议

接下来谈论的Web Service都是指 W3C Web Service，不再是广义上的。要理解这个定义，需要先弄清楚几个概念：WSDL、SOAP、HTTP、XML。



## WSDL文件详解



**WSDL 是Web Service 的接口文档，和你在 Swagger 中看到的接口描述作用完全一样。通过WSDL，客户端知道该发送什么格式的请求数据，才能被服务正确解析。**



WSDL（Web服务描述语言，Web Services Description Language）读作wiz-dəl，用来描述Web服务的公共接口。它描述了如何调用服务，需要什么参数，以及返回什么数据结构，它的用途大致类似于编程语言中对接口（interface)的类型说明。

![image-20220316172507408](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220316172507408.png)



一个WSDL的描述一般类似这样，实际编写时一般不需要手工填写，也不需要去深入看里面的构成，由工具生成就可以了。 在这个[Demo网页](https://www.crcind.com/csp/samples/SOAP.Demo.cls)中可以看到更多示例，之后会有具体的案例说明。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<description xmlns="http://www.w3.org/ns/wsdl" 
             xmlns:tns="http://www.tmsws.com/wsdl20sample" 
             xmlns:whttp="http://schemas.xmlsoap.org/wsdl/http/"
             xmlns:wsoap="http://schemas.xmlsoap.org/wsdl/soap/"
             targetNamespace="http://www.tmsws.com/wsdl20sample">

<documentation>
    This is a sample WSDL 2.0 document. 
</documentation>

<!-- Abstract type -->
   <types>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.tmsws.com/wsdl20sample"
                targetNamespace="http://www.example.com/wsdl20sample">
                 
         <xs:element name="request"> ... </xs:element>
         <xs:element name="response"> ... </xs:element>
      </xs:schema>
   </types>

<!-- Abstract interfaces -->
   <interface name="Interface1">
      <fault name="Error1" element="tns:response"/>
      <operation name="Get" pattern="http://www.w3.org/ns/wsdl/in-out">
         <input messageLabel="In" element="tns:request"/>
         <output messageLabel="Out" element="tns:response"/>
      </operation>
   </interface>

<!-- Concrete Binding Over HTTP -->
   <binding name="HttpBinding" interface="tns:Interface1" 
            type="http://www.w3.org/ns/wsdl/http">
      <operation ref="tns:Get" whttp:method="GET"/>
   </binding>
   
<!-- Concrete Binding with SOAP-->
   <binding name="SoapBinding" interface="tns:Interface1" 
            type="http://www.w3.org/ns/wsdl/soap" 
            wsoap:protocol="http://www.w3.org/2003/05/soap/bindings/HTTP/"
            wsoap:mepDefault="http://www.w3.org/2003/05/soap/mep/request-response">
      <operation ref="tns:Get" />
   </binding>

<!-- Web Service offering endpoints for both bindings-->
   <service name="Service1" interface="tns:Interface1">
      <endpoint name="HttpEndpoint" 
                binding="tns:HttpBinding" 
                address="http://www.example.com/rest/"/>
      <endpoint name="SoapEndpoint" 
                binding="tns:SoapBinding" 
                address="http://www.example.com/soap/"/>
   </service>
</description>
```



## SOAP协议

SOAP 是一组标准的XML数据格式，通常在 HTTP 请求中传递。但其实除了HTTP以外，它也可以在SMTP、UDP、TCP等协议上传输，自然也可以用在web service上。也就是说，作为一种组装数据的格式，它是独立的。



看一个具体的例子，下面表示访问 `InStock`服务中的`GetStockPrice`接口，并且传递参数 `StockName`为 T。

```xml
POST /InStock HTTP/1.1
Host: www.example.org
Content-Type: application/soap+xml; charset=utf-8
Content-Length: 299
SOAPAction: "http://www.w3.org/2003/05/soap-envelope"

<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:m="http://www.example.org">
  <soap:Header>
  </soap:Header>
  <soap:Body>
    <m:GetStockPrice>
      <m:StockName>T</m:StockName>
    </m:GetStockPrice>
  </soap:Body>
</soap:Envelope>
```

从这个例子中可以看出，SOUP 消息内容是由 XML 编写的，主要分为几个部分：

- Envelope，将XML文档标识为SOAP消息，必须
- Header，消息头，可以不填。
- Body, 包含需要调用的接口，参数以及响应信息，必须。
- 还有一个 Fault，表示调用过程出错后的展示信息。





## Web Service接口测试

根据上面的内容，大致梳理了 WSDL、SOUP、XML和HTTP的关系。





现在可以开始测试web service服务了。

1、在浏览器中查看[一个WSDL描述文件](https://www.crcind.com/csp/samples/SOAP.Demo.CLS?WSDL=1)， 也可以访问[parasoft的示例网站](https://parabank.parasoft.com/parabank/services.htm)获取更多WSDL文件。

![image-20220316174555318](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220316174555318.png)



2、在chrome浏览器中安装 [Wizdler](https://chrome.google.com/webstore/detail/wizdler/oebpmncolmhiapingjaagmapififiakb?hl=zh-CN) 插件或者 [Boomerang](https://chrome.google.com/webstore/detail/boomerang-soap-rest-clien/eipdnjedkpcnlmmdfdkgfpljanehloah?hl=zh-CN)，可以从WSDL中解析服务提供的接口，以及访问接口需要填写的参数类型。

![image-20220316175115586](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220316175115586.png)



3、点击接口名称，跳转到测试页面，修改请求参数。比如在 addInteger 接口中插入 12和13两个参数。

![image-20220316175315053](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220316175315053.png)



4、点击 Go 就可以往 Web Service 发送请求，得到响应结果。

![image-20220316175441512](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220316175441512.png)





## Postman测试web service

使用Postman测试Web Service并无太大区别，还是读取WSDL文件，从中解析出每个接口需要传递的参数格式。

- 在URL中填入服务地址
- 请求方法选择POST请求
- 请求格式选在 application/xml
- 把WSDL生成的请求数据复制到body参数中

![image-20220316181511208](https://yuztuchuang.oss-cn-beijing.aliyuncs.com/img/image-20220316181511208.png)





web service服务

web service原理

web service协议

web service接口

web service调用

web service教程

web service测试

web service例子

web service案例

web service示例

web service入门

web service报文



参考：

- [阮一峰：web service是什么](https://www.ruanyifeng.com/blog/2009/08/what_is_web_service.html) 
- [wiki百科：web service](https://en.wikipedia.org/wiki/Web_service)
- [REST](https://restfulapi.net/)
- [wiki百科：REST](https://en.wikipedia.org/wiki/Representational_state_transfer)
- [wiki百科：WSDL](https://en.wikipedia.org/wiki/Web_Services_Description_Language)
- [W3C WSDL 2.0](https://www.w3.org/TR/2007/REC-wsdl20-20070626/)
- [wiki百科：SOUP](https://en.wikipedia.org/wiki/SOAP)
- [w3c: SOUP](https://www.w3.org/TR/soap/)

