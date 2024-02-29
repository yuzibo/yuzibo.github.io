---
title: Debian autopkgtest code/debug
category: debian
layout: post
---
* content
{:toc}

为了后面修复一些debci的bug，故把maintainer的一些嘱咐放在这里。后面再来反复看。

```bash
---
17:16 < vimer> I know what it's like. Because I also want to know which packages can trigger system's crash.:)
17:19 < vimer> how to implement the code for monitoring purposes? I mean, I can try it but I maybe need some help
17:21 -KGB-2:#debci- autopkgtest pipeline Simon McVittie 555974 * [26 minutes and 48 seconds] failed (quicktests: success; tests-sid:
          failed; tests-stable: success; test-docker: success; test-lxc: success; test-podman: success; test-schroot: success;
          test-unshare: success)
17:21 < elbrus> vimer: to be honest, I don't know exactly; we use munin and the main node in our infrastructure connects to the workers to
                retrieve the data (if I'm correct). The munin code on the main node would need to know how to connect via the proxy somehow
17:22 < elbrus> terceiro: your new test for the global timeout seems flaky; it has failed already three times since you merged the code
17:22 < vimer> elbrus: fair enough. thanks.
17:22 < elbrus> you know where our deploy code lives, right?
17:23 < elbrus> salsa.debian.org/ci-team/debian-ci-config/
17:23 < elbrus> https://salsa.debian.org/ci-team/debian-ci-config/
17:23 < elbrus> I *think* all munin stuff is here: https://salsa.debian.org/ci-team/debian-ci-config/-/tree/master/cookbooks/munin
17:25 < elbrus> *Probably* this needs more intellegence:
                https://salsa.debian.org/ci-team/debian-ci-config/-/blob/master/cookbooks/munin/templates/hosts.conf.erb
17:25 < elbrus> to be fair, we currently also can't monitor armhf and armel
17:25 < elbrus> because they are on IP6 and our main node only has IP4
17:26 < elbrus> also there we could proxy, because they are VM's on an host that has IP4
17:29 < vimer> ok, I'll take a closer look at the code you gave me. thanks again
---
```