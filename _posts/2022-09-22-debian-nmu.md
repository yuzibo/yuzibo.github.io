---
title: Debian NMU packages
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

## Update upstream

```bash
# 1. import orig packages
gbp import-dsc elektra_0.8.14-5.1.dsc

# 2. push repo
# 一般来说这个时候是没有 repo的，所以需要自己新建一个repo
# http://marquiz.github.io/git-buildpackage-rpm/gbp.import.html

# 3. 
 gbp pq import

# 4.
git checkout master

# 5. import the new upstream into upstream
gbp import-orig ../elektra-0.9.11.tar.gz
What is the upstream version? [0.9.11]
gbp:info: Importing '../elektra-0.9.11.tar.gz' to branch 'upstream'...
gbp:info: Source package is elektra
gbp:info: Upstream version is 0.9.11
gbp:info: Replacing upstream source on 'master'
gbp:info: Successfully imported version 0.9.11 of ../elektra-0.9.11.tar.gz


# 6. 
gbp pq export
gbp pq drop
```

## ack nmu

Generally speaking, if others DD NMUed your package(s), you have to acknowledge this num in your next upload.

```bash
You should incorporate the changes from the NMU first.
Something like this:

$ dget https://deb.debian.org/debian/pool/main/j/jimtcl/jimtcl_0.82-4.1.dsc

change directory to your jimtcl repository:

$ cd jimtcl/

import the .dsc:

$ gbp import-dsc ../jimtcl_0.82-4.1.dsc

```
