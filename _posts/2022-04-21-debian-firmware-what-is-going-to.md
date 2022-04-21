---
title: debian Firmware - what are we going to do about it
category: debian-riscv
layout: post
---
* content
{:toc}

这与debian riscv不相关，但是我把它记录在这里了。

之前在使用一些闭源的驱动时，可以安装firmware的方式去做，目前，debian社区对这一议题的讨论再次热闹起来。当然，站在新手的角度看，只能慢慢消化他们在讨论的什么东西  ：（

# wiki

There is a list of libre firmware projects on this page:

https://wiki.debian.org/Firmware/Open

# 起源

最开始的[mail](https://lists.debian.org/debian-devel/2022/04/msg00130.html)来自这里。

Debian支持non-free的劣势是:
```bash

 1. Building, testing and publishing two sets of images takes more effort.
 2. We don't really want to be providing non-free images at all, from a
    philosophy point of view. So we mainly promote and advertise the preferred
    official free images. That can be a cause of confusion for users. We do
    link to the non-free images in various places, but they're not so easy to
    find.
 3. Using non-free installation media will cause more installations to use
    non-free software by default. That's not a great story for us, and we may
    end up with more of our users using non-free software and believing that
    it's all part of Debian.
 4. A number of users and developers complain that we're wasting their time by
    publishing official images that are just not useful for a lot (a majority?)
    of users.
```
开发者给出了几个options:

```bash
 1. Keep the existing setup. It's horrible, but maybe it's the best we can do?
    (I hope not!)

 2. We could just stop providing the non-free unofficial images altogether.
    That's not really a promising route to follow - we'd be making it even
    harder for users to install our software. While ideologically pure, it's
    not going to advance the cause of Free Software.

 3. We could stop pretending that the non-free images are unofficial, and maybe
    move them alongside the normal free images so they're published together.
    This would make them easier to find for people that need them, but is
    likely to cause users to question why we still make any images without
    firmware if they're otherwise identical.

 4. The images team technically could simply include non-free into the official
    images, and add firmware packages to the input lists for those images.
    However, that would still leave us with problem 3 from above (non-free
    generally enabled on most installations).

 5. We could split out the non-free firmware packages into a new
    non-free-firmware component in the archive, and allow a specific exception
    only to allow inclusion of those packages on our official media. We would
    then generate only one set of official media, including those non-free
    firmware packages.

```