---
layout: article
title: "github不能访问、加载css、js的解决办法"
category: tools
tags: [setting,github]
---


因为GFW的问题，github的cdn经常被污染而导致访问异常。表现症状是页面加载慢，并且页面样式明显错乱。


## 解决方法

修改hosts文件，直接通过IP访问github的CDN fastly.net，不用域名解析。

hosts文件的位置分别是:

    Windows  C:\Windows\system32\drivers\etc\hosts

    Linux    /etc/hosts

通过 `www.ipaddress.com` 这个网站查询 `github.global.ssl.fastly.net` 的IP地址，然后在hosts中增加一条。

    #fix github cdn problem because of GFW
    185.31.17.184  github.global.ssl.fastly.net

然后访问github.com首页，就可以进来了。

此种方法对windows和Linux通用。
