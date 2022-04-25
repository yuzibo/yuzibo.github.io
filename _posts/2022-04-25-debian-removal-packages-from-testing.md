---
title: debian Automatic removal of packages from testing
category: debian-riscv
layout: post
---
* content
{:toc}

目前的Debian有一个机制，就是如果影响了RC的package，在一定时间内没有修复ftbfs的issue，会自动从testing 队列中删除，具体的邮件参考[这里](https://lists.debian.org/debian-devel-announce/2013/09/msg00006.html)

摘抄如下 ：

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Auto-removals
=============

As we announced, we are going to start automatic removals from testing
of some RC buggy packages, to help lower the number of outstanding RC
bugs which affect the jessie release. We would like to emphasise that
we obviously prefer to have fixes for the outstanding RC bugs, and
that (auto)removing packages is only used as a last resort.

Packages which have RC bugs that are present in both testing and
unstable, and which have no recent activity (currently this means no
activity in the last 14 days) will be checked for removal.

If the packages are on the list of "key packages"[KEY-PACKAGES], they
will be excluded from automatic removal.  Also packages which have
reverse (build-)dependencies in testing, will currently also be
excluded from automatic removal.

Should your package suffer from an RC bug which needs more time to get
fixed, the specific bug can be temporarily whitelisted.  Please file a
bug against release.debian.org with an explanation for the delay;
these exceptions will granted on a case-by-case basis.

For packages which are marked for autoremoval 10 days in a row,
removal hints will be added. These packages will usually be removed
from testing fairly soon after that.  You can see if any of your
packages might be candidates for removals at [AUTO-RM-CANDIDIATES].
We activated the auto-removals at the time of this announcement,
however until the 2013-10-15, the usual autoremoval delay of 10 days
will be extended to 15 days, so you have some time to fix any
outstanding issues.

If packages get autoremoved from testing, they can get back in when
the RC bugs are fixed, using the same rules that apply to other
packages. In most cases, this means that the fix can get back into
testing after the usual 10-day waiting period.

Please note that packages which are excluded from automatic removal
could still be manually removed from testing.

We would like to thank Ivo De Decker writing the actual implementation
for finding these auto-removable packages.

Niels, on behalf of the Release Team.

[KEY-PACKAGES]
http://udd.debian.org/cgi-bin/key_packages.yaml.cgi

[AUTO-RM-CANDIDATES]
http://udd.debian.org/cgi-bin/autoremovals.cgi
"dd-list"-like of packages considered for auto removals.

For automatic processing, use 
http://udd.debian.org/cgi-bin/autoremovals.yaml.cgi
-----BEGIN PGP SIGNATURE-----

Debian有很多资料没有document，但是他们开发者自己还是很清楚的，差别就在于他们一直在伴随着DEbian的开发。

其实，开源社区的进展，什么都遵循上面的原理。