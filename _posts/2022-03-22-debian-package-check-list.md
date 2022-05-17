---
title: debian packages checklist
category: debian-riscv
layout: post
---
* content
{:toc}

如果打包完成后，需要在本地进行测试ok后再上传ftp，那么，需要做哪些check呢？

# [testing package](https://www.debian.org/doc/manuals/developers-reference/pkgs.html#testing-the-package)

Copy:

1. Run lintian over the package. You can run lintian as follows: lintian -v package-version.changes. This will check the source package as well as the binary package. If you don't understand the output that lintian generates, try adding the -i switch, which will cause lintian to output a very verbose description of the problem.Normally, a package should not be uploaded if it causes lintian to emit errors (they will start with E).For more information on lintian, see lintian.

2. Optionally run debdiff (see debdiff) to analyze changes from an older version, if one exists.

3. Install the package and make sure the software works in an up-to-date unstable system.

4. Upgrade the package from an older version to your new version.

5. Remove the package, then reinstall it.

6. Installing, upgrading and removal of packages can either be tested manually or by using the piuparts tool.

7. Copy the source package in a different directory and try unpacking it and rebuilding it. This tests if the package relies on existing files outside of it, or if it relies on permissions being preserved on the files shipped inside the .diff.gz file.

# lintian
最大的得到lintian的输出:
```bash
Try lintian -I -E -v --pedantic
or set up .lintianrc file with these option enabled
```