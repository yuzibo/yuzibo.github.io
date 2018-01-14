---
title: "内核代码静态分析工具"
layout: article
category: kernel
---

# smatch

自己在本机的 ~/maintree/linux目录下，已经git remote add linux-next树，只需获得linux-next最新的tags。在创建kernel代码数据库后，使用命令smatch_scripts/test_kernel.sh 就可以产生一个内核的warn.txt文件，这里就是他的分析工具。

# coccinelle

这一个工具就目前而言，比smatch要好用一些，下面简要的基于一下规则;

[这里](https://kernelnewbies.org/JuliaLawall)

```c

static ssize_t bus_kobj_attr_store(struct kobject *kobj, struct attribute *attr,
                                   const char *buf, size_t count)
{
        ssize_t ret;
        struct medialb_bus *bus =
                container_of(kobj, struct medialb_bus, kobj_group);
        struct bus_attr *xattr = container_of(attr, struct bus_attr, attr);

        if (!xattr->store)
                return -EIO;

        ret = xattr->store(bus, buf, count);
        return ret;
}
```

在这行代码中，最后两行可以合并为一个语句;

```c
static ssize_t bus_kobj_attr_store(struct kobject *kobj, struct attribute *attr,
                                   const char *buf, size_t count)
{
        ssize_t ret;
        struct medialb_bus *bus =
                container_of(kobj, struct medialb_bus, kobj_group);
        struct bus_attr *xattr = container_of(attr, struct bus_attr, attr);

        if (!xattr->store)
                return -EIO;

        return xattr->store(bus, buf, count);
}
```

那么，怎么发现这个问题呢，你需要自己先写一个coccinelle的系统文件，

```bash
@@
local idexpression ret;
expression e;
@@

-ret =
+return
     e;
-return ret;
```

1. 保存为 ret.cocci

2. 下载staging-testing

3. 在对行的目录下运行这个脚本

最后一部就是


```bash
spatch --sp-file ret.cocci --no-includes --dir /home/yubo/maintree/staging/drivers/staging > ret.out
```

当然，前提是要安装coccinelle这个软件，可以通过发行版的包安装命令。也就是说，当执行完上面的命令，所有的毛病就会输出到ret.out这个文件。

perfect!!!

说的简单些，这个工具的最难之处就是.cocci的编写，当你有自己的想法并实现时，别忘了给[coccinelle](https://github.com/coccinelle/coccinelle)提交你的系统文件。
