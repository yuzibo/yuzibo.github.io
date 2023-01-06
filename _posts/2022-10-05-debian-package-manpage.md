---
title: debian 添加 manpage 
category: debian-riscv
layout: post
---
* content
{:toc}

From [So](https://stackoverflow.com/questions/21019144/how-to-create-manual-entry-for-deb-package)

dh_installman works by reading the file debian/manpages, or debian/nameofyourpackage.manpages. This file has a list of paths pointing to the man pages of your package. The paths are relative to the root of your package. Here you have an example of a real package. Then, this program will properly install your man pages in the right directory.

So, to sum up, you only have to create the debian/package.manpages and fill it with the paths to your man pages. These paths have to be relative to the root of your package. If you, the packager, are writing the man pages, then they have to be placed in the Debian/ directory.

---

Hello Bo!

If you look when running sbuild/debuild, in the debian/python3-whey/usr/bin directory there is a binary called whey.
When usptrem doesn't give the manual on the command line, we have to.

In that case, you:
1. create a directory: mkdir debian/manpage
 
2.create a file
called whey.txt
with the manual.

follow this example here:
https://salsa.debian.org/nilsonfsilva/cplay-ng/-/blob/debian/master/debian/manpage/cplay-ng.txt

Whey commands are available here:
https://whey.readthedocs.io/en/latest/cli.html
It's just you adapt to whey.



3. we need to generate the file in roff with the name whey.1

see this one here:
https://salsa.debian.org/nilsonfsilva/cplay-ng/-/blob/debian/master/debian/manpage/cplay-ng.1

Do this with the txt2man program inside the debian/manpage directory
using the following command: txt2man whey.txt > whey.1

obs: download txt2man first.

4. create a file in the debian directory
called manpages, and inside it put: debian/manpage/whey.1




When ready, upload it to your namespace and let me know. Then we can fix something. Next, let's go to the python namespace in salsa.

