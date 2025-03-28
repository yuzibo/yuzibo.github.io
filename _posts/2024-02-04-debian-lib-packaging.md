---
layout: post
title: "Debian lib symbols 文件生成"
category: debian
---

* content
{:toc}

# wiki

[debian wiki](https://wiki.debian.org/UsingSymbolsFiles)

# instance

```bash
 dpkg-deb -x ../libzlog1_1.2.18-1_amd64.deb libzlog1
 dpkg-gensymbols -v1.2.18 -plibzlog  -Olibzlog1.symbols -elibzlog1/usr/lib/x86_64-linux-gnu/zlog/libzlog.so.1
```

结合 [pkgkde wiki](https://qt-kde-team.pages.debian.net/symbolfiles.html)



打包 -dev 包含 so文件的包需要注意的事情
[1]: https://stackoverflow.com/questions/41383039/debian-package-naming-policy-for-soname
包名与so命名需要一致。
新的 需要总结：

# aemu packaging
[gfxstream on fedora spce](https://elmarco.fedorapeople.org/gfxstream.spec)
[aemu on spec](https://src.fedoraproject.org/rpms/aemu/blob/rawhide/f/aemu.spec)




libhx [可以参考 symsbols 怎么生成的]
lib 的test如何使用
[libhx test](https://git.jff.email/cgit/libhx.git/tree/debian/tests/build)
[libgav1](https://tracker.debian.org/pkg/libgav1) 还有看这个，但是明显不应该这么做， 在 包名后加1，原因是 upstream 自带的

```bash
vimer@dev:~/build/rfs/ocaml/package/for-debian/2_linksem/old/tmp/libgav1-0.18.0$ dpkg -c ../libgav1-1_0.18.0-1_amd64.deb
drwxr-xr-x root/root         0 2022-07-28 04:50 ./
drwxr-xr-x root/root         0 2022-07-28 04:50 ./usr/
drwxr-xr-x root/root         0 2022-07-28 04:50 ./usr/lib/
drwxr-xr-x root/root         0 2022-07-28 04:50 ./usr/lib/x86_64-linux-gnu/
-rw-r--r-- root/root    956432 2022-07-28 04:50 ./usr/lib/x86_64-linux-gnu/libgav1.so.1.0.0
drwxr-xr-x root/root         0 2022-07-28 04:50 ./usr/share/
drwxr-xr-x root/root         0 2022-07-28 04:50 ./usr/share/doc/
drwxr-xr-x root/root         0 2022-07-28 04:50 ./usr/share/doc/libgav1-1/
-rw-r--r-- root/root       938 2022-07-28 04:50 ./usr/share/doc/libgav1-1/changelog.Debian.gz
-rw-r--r-- root/root      2658 2022-07-17 02:07 ./usr/share/doc/libgav1-1/copyright
lrwxrwxrwx root/root         0 2022-07-28 04:50 ./usr/lib/x86_64-linux-gnu/libgav1.so.1 -> libgav1.so.1.0.0

```
也就是需要有这两个文件libgav1.so.1 -> libgav1.so.1.0.0

```bash
https://packages.debian.org/sid/amd64/libgav1-1/filelist
/usr/lib/x86_64-linux-gnu/libgav1.so.1
/usr/lib/x86_64-linux-gnu/libgav1.so.1.0.0
/usr/share/doc/libgav1-1/changelog.Debian.amd64.gz
/usr/share/doc/libgav1-1/changelog.Debian.gz
/usr/share/doc/libgav1-1/copyright
```
确实可以参考一下这个： [librandom]https://tracker.debian.org/pkg/librandomx



test again:
   
[libraw](https://salsa.debian.org/debian-phototools-team/libraw/-/blob/master/debian/tests/smoketest?ref_type=heads)

[policy](https://www.debian.org/doc/manuals/maint-guide/advanced.en.html#librarysymbols)   

    
[深入阅读](https://stackoverflow.com/questions/41383039/debian-package-naming-policy-for-soname)

4.2
 [gl4es](https://bugzilla.redhat.com/show_bug.cgi?id=1788327)
 [cmake + multiarch](https://sources.debian.org/src/libbtbb/2018.12.R1-1/debian/ [cmake + multiarch])


