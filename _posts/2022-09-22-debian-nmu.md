---
title: Debian QA packages
category: debian-riscv
layout: post
---
* content
{:toc}

这篇文章记录NMU。

# code example

## title

```bash
RFS: electrum/4.3.2-0.1 [NMU] [RC] -- Easy to use Bitcoin client
```
## d/changelog
```bash
electrum (4.3.2-0.1) unstable; urgency=medium
 .
   * Non-maintainer upload.
   * New upstream release (Closes: #1001064).
   * Switch to new "sourceonly" upstream tarball (see the upstream changelog
     for release 4.3.1).
   * debian/compat: Create file and set version to debhelper v13.
   * debian/control: Update debendencies.
   * debian/control: Bump Standards-Version to 4.6.1 (no changes).
   * debian/copyright: Update and reformat copyright and license information.
   * debian/electrum.install: Include the new electrum.png in
     usr/share/icons/hicolor/128x128/apps/.
   * debian/patches: Refresh 0001-Improve-message-about-PyQt5.patch.
   * debian/rules: Build paymentrequest_pb2.py from the .proto file and
     remove redundant license files from the binary packages.
   * debian/source: Remove unneeded include-binaries file.
   * debian/upstream: Strip extra signatures from signing-key.asc
   * debian/watch: Update to version 4 and refactor for "sourceonly" tarball.

```