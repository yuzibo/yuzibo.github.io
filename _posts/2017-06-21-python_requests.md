---
title: "python之Requests的使用笔记"
category: python
layout: post
---

### send a Request

```python
re = requests.get('https://api.github.com/events')

re = requests.post('http://httpbin.org/post', data = {'key':'value'})
print re
## This is a HTTP POST

payload = {'keys1': 'val1','keys2': 'val2'}
r = requests.get('http://httpbin.org/get', params=payload)
print r.url
## http://httpbin.org/get?keys1=val1&keys2=val2

```

哈哈，不得不说这个库真的很厉害，一下子就解决我的问题了，所以我只能高兴的使用汉语表达我的喜悦之情了。

### Request Content
这个库的使用和BS的用法差不多少，[MY BS note](http://www.aftermath.cn/python_beautifulsoup.html), 一开始都是依靠自己的猜测，当然，大多数是认为Unicode,看下面：

```python
print re.text
```

这里当然是指在你不知道网页源代码字符集的情况下默认编码为*Unicode*,如果，而且必须做的是，你知道正确的编码格式就得改正过来, 使用 *re.encoding=''* 指明它：

```python
print re.encoding
re.encoding
```
所以，这里的思路应该是使用*re.content*去发现源代码的编码方式，然后使用*re.encoding*去定义原本的编码格式而不是考猜，最后使用*re.text*打印出你想使用的东西。

#### JSON 请求
还是以上面的例子，比如：

```python
re.json()
```

#### 返回码
上面有几个的内容我忽略掉了，现在只需要几个我认为自己能够需要的，其他的后来慢慢补上。


```python
re.status_code

## @2
re.headers

re.headers['Content-Type']
```
嘿，有意思了，4xx是客户端错误然而5XX是服务端错误。

#### cookies

在一些含有cookie的网页中，你可以快速进入cookies:

```python
re.cookies['example_cookie_name']

##  If you send your own cookies to the server, you can use the *cookies* parameter:

    url = 'http://httpbin.org/cookies'
    cookies = dict(cookies_are='working')

    re = requests.get(url, cookies=cookies)
    print re.text
#{
#  "cookies": {
#      "cookies_are": "working"
#	        }
#}
```
