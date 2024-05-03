---
layout: post
title: "munin on ssh jump"
category: tools
---

munin 是一个优秀的监控工具。不过网上对于如何通过跳板机连接目标机的资料不多，本篇文章是一个当时的试验记录，先放在这里，方便后面如果再次查阅的话.


1. Ensure you can access workers/nodes with your pubkey on munin master side.

2. On nodes, ensure installing `munin-node`(that's all done on all
debci workers)

3. On munin master, to install `munin` and then:
     a. `sudo -u munin -s bash` # enter into munin namespace. `-s `
can avoid permission issue, but forget which link
           `cd ` # return munin's default home : /var/lib/munin/
     b. copy private key to `/var/lib/munin/.ssh/`
          In my case is `/var/lib/munin/.ssh/vimer_id_ed25519`. The
key is the one we mentioned above. chown `munin` to all files.
     b. Configure .ssh/config

```bash
Host debian-10
    HostName 127.0.0.1
    Port 22
    User vimer
    ProxyCommand ssh jump-host -W %h:%p
    IdentityFile /var/lib/munin/.ssh/vimer_id_ed25519

Host jump-host
    HostName lab.com
    Port 22
    ServerAliveInterval 120
    User vimer
    IdentityFile /var/lib/munin/.ssh/vimer_id_ed25519
```

This is identical to your ~/.ssh/config except ` IdentityFile` arg
forcely. Image under munin namespace, you have to log in on jump host
and workers with `user name`.

On another terminal, we need to configure `/etc/munin/munin.conf`
which is conf file of munin. Adding something like below:

```bash
[debian-01]
        address ssh://vimer.7766.org:12345 -W localhost:4949
        use_node_name yes

[debian-10]
        address ssh://vimer@debci-10:12345 -W localhost:4949
        use_node_name yes
```
then
`sudo systemctl restart munin`.

Backing to the previous terminal, you can test it by manual:

```bash
munin@debian:~$ /usr/share/munin/munin-update --debug --nofork --host
debian-06 --service df
```
the `--host` is what you want to debug. If everything is okay, you will see log:

```bash
munin@debian:~$ /usr/share/munin/munin-update --debug --nofork --host
debian-06 --service df
2024/04/19 02:42:51 [DEBUG] Creating new lock file
/var/run/munin/munin-update.lock
2024/04/19 02:42:51 [DEBUG] Creating lock :
/var/run/munin/munin-update.lock succeeded
2024/04/19 02:42:51 [INFO]: Starting munin-update
2024/04/19 02:42:52 [DEBUG] Creating new lock file
/var/run/munin/munin-debian-06.lock
2024/04/19 02:42:52 [DEBUG] Creating lock :
/var/run/munin/munin-debian-06.lock
succeeded
2024/04/19 02:42:52 [DEBUG] Reading state for
debian-06 in
/var/lib/munin/state-debian--06.storable
2024/04/19 02:42:52 [INFO] starting work in 1387300 for
debian-06 (ssh://vimer@debian-06:13321 -W localhost:4949).
2024/04/19 02:42:52 [DEBUG] open3(ssh -o
ChallengeResponseAuthentication=no -o StrictHostKeyChecking=no -p
13321 vimer@debian-06  -W localhost:4949)
2024/04/19 02:42:53 [INFO] node debian-06 advertised itself
as debci-bj-06 instead.
2024/04/19 02:42:53 TLS set to "disabled".
2024/04/19 02:42:53 [DEBUG] Negotiating capabilities

```
If you have error generated, you can execute `ssh -o
ChallengeResponseAuthentication=no -o StrictHostKeyChecking=no -p
13321 vimer@debian-06  -W localhost:4949 -vvv` by hand to see what
happened on both side.

All steps are done as my testing. Two usefully log:
`/var/log/munin/munin-update.log` for munin master and the other is
`/var/log/munin/munin-node.log` for munin node.
```
