---
layout: post
title: "nginx config"
category: tools
---


# nginx config summary

Maybe in 2024 we use nginx heavily to distribute some Debian packages or something like this. But unfortunately, today I found I have forgotsome configs about it. So let's take it on here now.

## port and project config

```bash
/etc/nginx$ ls sites-enabled/
default  file.conf  repo.conf
```

cotent of file.conf is:

```
a@debian:/etc/nginx$ cat sites-enabled/file.conf
server {
        listen 81;
        listen [::]:81;

        #server_name ;

        location / {
                root /home/a/files/ ;
                autoindex on;
        }
}

```
