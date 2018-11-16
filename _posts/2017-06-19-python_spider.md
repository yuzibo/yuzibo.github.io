---
title: "python之爬虫简介"
category: python
layout: post
---

* content
{:toc}

基本的知识架构为python基础->urllib2库基本用法或者requests基本用法->正则表达式，这样你的爬虫的效果才会更好，更进一步。

# urllib2

```python
import urllib2
response = urllib2.urlopen("http://www.baidu.com")
print response.read()
```

将这段代码保存为demo.py,运行之后你就会看到满屏的内容，哈哈，这就是第一个爬虫代码.
首先我们调用的是urllib2库里面的urlopen方法，传入一个URL，这个网址是百度首页，协议是HTTP协议，当然你也可以把HTTP换做FTP,FILE,HTTPS 等等，只是代表了一种访问控制协议，urlopen一般接受三个参数，它的参数如下：

	urlopen(url, data, timeout)

第二个参数data是访问URL时要传送的数据，第三个timeout是设置超时时间。第二三个参数是可以不传送的，data默认为空None，timeout默认为 socket._GLOBAL_DEFAULT_TIMEOUT.第一个参数URL是必须要传送的，在这个例子里面我们传送了百度的URL，执行urlopen方法之后，返回一个response对象，返回信息便保存在这里面。

	print response.read()

response 对象有一个read方法，可以返回获取到的网页内容。

这段代码可以改进一下:*构造Request*
这里可以传入一个request请求，这就是一个Request类的实例，构造时需要传入Url,Data等等的内容，比如，上面的两行代码，我们可以这么改写:

```python
import urllib2
request = urllib2.Request("http://www.aftermath.cn")
response = urllib2.urlopen(request)
print response.read()
```

### post 和　get  方式
[IMPORTANT]，这块后来补充
先上一张正则表达式的图片

![sp_1.png](http://yuzibo.qiniudn.com/sp_1.png)


# requests 库的使用

requests的方法如下:

![reguests.png](http://yuzibo.qiniudn.com/reguests.png)

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import requests

if __name__ == '__main__':
    target = 'http://gitbook.cn/'
    req = requests.get(url=target)
    print(req.text)
```

现在你可以看一下这个代码，这样你就将很多文本型的内容打印出来了.
下面这段代码与上面的代码是一样的，我这里只是想探究一下字符编码的问题。

```python

import requests

if __name__ == '__main__':
    target = 'http://www.biqukan.com/1_1094/5403177.html'
    req = requests.get(url = target)
    print(req.text)
```
效果:

![requests_1.png](http://yuzibo.qiniudn.com/requests_1.png)

注意源码中的编码字符集，这个对于以后的中文处理字符有很大的作用.
也就是说从这里开始，requests得到的字符可以在我的电脑上显示出来，在你的电脑上不一定显示出来，这一点在我一开始处理代码时就这样。

# Beautiful Soup

目前这种方法的编码有问题.(应该新开一篇单独讲这个问题)
```python
from bs4 import BeautifulSoup
import requests
if __name__ == '__main__':
    target = 'http://www.biqukan.com/1_1094/5403177.html'

    req = requests.get(url=target)
    content = req.text
    #html = urllib2.urlopen(target)
    #content = html.read().decode('gbk', 'ignore')
    #下面可以不指定fromEncoding，bs 可以自己搞定
    bf_1 = BeautifulSoup(content,'lxml')
    print "------------\n\n"
    texts = bf_1.find_all('div', class_ = 'showtxt')
    print "type(texts)=", type(texts)
    print "len(texts)=", len(texts)

    for each_div in texts:
        print "type(each_div)=", type(each_div)
        print "each_div.string=", each_div.string # 输出soup的属性
        print "type(each_div.string)=", type(each_div)
        print "each_div=", each_div
        print "each_div.renderContents()=", each_div.renderContents()
        print "each_div.__str__('GBK')=", each_div.__str__()
```
为什么这么啰嗦呢，关键问题在于字符编码的问题影响了事情的发展。BeautifulSoup将输入的内容自己转换为unicode的编码了，需要我们在输出的时候，人为的指定输出格式.

效果如下:

![sp_1.png](http://yuzibo.qiniudn.com/sp_1.png)

参考这篇[文章](https://www.crifan.com/beautifulsoup_already_got_unicode_soup_but_print_messy_code/)

在上面的效果中，你会发现还有<br>标签什么，下面是去掉<br>的代码，
```python
import sys
reload(sys)
sys.setdefaultencoding('gbk')
# 这一个对于编码的工作也是至关重要

import urllib2
from bs4 import BeautifulSoup
import requests
if __name__ == '__main__':
    target = 'http://www.biqukan.com/1_1094/5403177.html'

    req = requests.get(url=target)
    content = req.text
    bf_1 = BeautifulSoup(content,'lxml')
    texts = bf_1.find_all('div', class_ = 'showtxt')
    print "type(texts)=", type(texts)
    print "len(texts)=", len(texts)
    print(texts[0].text.replace('\xa0'*8,'\n\n'))
```
这一段代码与前面的代码的区别在哪里相信大家一定能够看出来，其实，上面的代码后面几行代码就是测试使用的。

如果不加入最前面的三行代码，python会报出unicodedecodeerror error,这里面不知道大家有没有看出门道，就是你要抓取的网页源代码是什么样的编码格式，在最前面的sys.setdefaultencoding()就要指定python的编码格式，这样在传递给BeautifulSoup处理的时候就是gbk了(这里是我自己的推断，不一定正确)

总结如下：

不能再对Unicode编码再进行解码(decode)了，这时候你应该对其进行对应于你的终端上的编码格式进行编码(encode)

效果如下：

![request_2.png](http://yuzibo.qiniudn.com/request_2.png)

### 关于编码的问题
这里有一篇好的文章，请参考一下[here](http://www.cnblogs.com/huxi/archive/2010/12/05/1897271.html)

(ascii编码)[http://blog.csdn.net/songjinshi/post/details/7868866]

正则表达式:

![04.png](http://yuzibo.qiniudn.com/04.png)

