---
title: "perl-lwp简单应用"
layout: post
category: perl
---

* content
{:toc}

简单记录LWP的应用。

### get

$document = get("URL");
这个函数没有返回码。

### getstore
这个函数就是将访问到的URL内容保存下来。 两个参数哈
在这里面有两个状态值is_success()和is_error()判断上面的正确与否；

```perl
#!/usr/bin/perl -w
use strict;
use LWP::Simple;
my $url = 'http://www.baidu.com';
my $file = '/tmp/baidu.html';
my $status = getstore($url,$file);
die "Error $status on $url" unless is_success($status);
open(IN,"<$file") || die "Can't open $file: $!";
while(<IN>){
	if (m/百度/){

		print "hello,baidu,$url";
		last;
	}
}
close(IN);
```

### getprint
这个函数抓取接着打印，后面的参数是URL；

```perl
perl -MLWP::Simple -e "getprint('http://cpan.org/RECENT') || die" | grep Apache
```
url很重要，这样子你就可以了解相关软件的perl模块的最新情况。


# 面向对象

```perl
#!/usr/bin/perl -w
use strict;
use LWP;

my $url = 'http://www.baidu.com/';
my $browser = LWP::UserAgent->new();
my  $response = $browser->get($url);
print $response->header("Server"), "\n";
```
这段代码很有用，它可以让你知道你所测的主机的服务器使用的什么服务器。
最关键的是面向对象的思想在里面
