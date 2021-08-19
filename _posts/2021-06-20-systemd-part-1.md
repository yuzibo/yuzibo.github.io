---
title: systemd unit 解读
category: unix
layout: post
---
* content
{:toc}

systemd已经是大部分发行版的主流了，我们今天的这个问题是，解读其中的一个关键字眼。

# unit
 systemd的unit是一个sections, [这篇文章](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)
 介绍的非常详细。

 就拿rc.local的实例来讲：

 ```bash
[Unit]
Description=/etc/rc.local Compatibility
Documentation=man:systemd-rc-local-generator(8)
ConditionFileIsExecutable=/etc/rc.local
After=network.target
```

其中我们常见的还有 `wants`字段，这个字段是一个弱强制性，也就是，当你的条件不满足时，不会影响到这个systemd的work。
但是还有一个`requires`的字段就没有这么友善了，需要强制满足。

network.target has very little meaning during start-up. It only indicates that the network management stack is up after it has been reached.
Whether any network interfaces are already configured when it is reached is undefined. Its primary purpose is for ordering things properly at shutdown: since the shutdown ordering of units in systemd is the reverse of the startup ordering, any unit that is order After=network.target can be sure that it is stopped before the network is shut down if the system is powered off.
This allows services to cleanly terminate connections before going down, instead of abruptly losing connectivity for ongoing connections, leaving them in an undefined state. Note that network.target is a passive unit: you cannot start it directly and it is not pulled in by any services that want to make use of the network. Instead, it is pulled in by the network management service itself. Services using the network should hence simply place an After=network.target dependency in their unit files, and avoid any Wants=network.target or even Requires=network.target.


# service

```bash
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
RemainAfterExit=yes
GuessMainPID=no
```

`Type=` Configures the process start-up type for this service unit. One of simple, exec, forking, oneshot, dbus, notify or idle:

`ExecStart=`
Commands with their arguments that are executed when this service is started. The value is split into zero or more command lines according to the rules described below (see section "Command Lines" below).
