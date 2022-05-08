---
title: debian nmu upload
category: debian-riscv
layout: post
---
* content
{:toc}

因为自己的登记所限，目前还不具备nmu upload的权限，但是这个在不久的未来一定会遇到。故现在就把list中大佬的message摘录下来，以方便后期查看。

Some thoughts about procedures:
Jan is generally active (uploaded a package last month), but is in the
LowNMU list [1] and the package is in the salsa Debian group [2].
Using the "LowNMU" procedure means that your package needs to be a NMU [3],
but an NMU requires that the upload fixes bugs reported in the Debian BTS and a
NMU limits the changes you are allowed to do in a package. You can of course
file the bugs you fix in your changes in the Debian BTS (including a "please
package the new upstream version where you can list all the problems with the
old version.), but some changes will still be out of scope for an NMU.

The salsa Debian group is technically a Team upload [4] and team-uploads do not
have restrictions on what to upload, so I guess this is an viable approach.

The third option is to adopt the package -- either by an explicit OK to do from Jan
or via the ITS procedure [5]. With that, you will become  (co-)maintainer of
the package, but that implies some kind of promise to also look after the package in
the future. This is of course the best outcome for Debian and your project, but
also means a commitment in maintaing the package.

[1] https://wiki.debian.org/LowThresholdNmu

[2] https://wiki.debian.org/Salsa/Doc#Collaborative_Maintenance:_.22Debian.22_group
    https://www.debian.org/doc/manuals/developers-reference/pkgs.en.html#collaborative-maint␆bib
[3] https://wiki.debian.org/NonMaintainerUpload
 https://www.debian.org/doc/manuals/developers-reference/pkgs.en.html#non-maintainer-uploads-nmus

[4] https://wiki.debian.org/TeamUpload
[5] https://www.debian.org/doc/manuals/developers-reference/pkgs.en.html#package-salvaging
    https://wiki.debian.org/PackageSalvaging
    (The "conservative" criterias are imho fulfilled:
    -::q open bugs, missing upstream releases, sourceful upload required, no visible activity on
      the package >6months)
