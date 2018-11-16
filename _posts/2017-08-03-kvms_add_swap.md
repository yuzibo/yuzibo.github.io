---
title: "linux扩充swap容量"
category: kvms
layout: post
---

* content
{:toc}

This is a new post and it is sister message for http://www.aftermath.cn/kvms-resize.html

# How to add Swap space
First, we can see if the filestsyem has any swap, you can type:

	sudo swapon --show

If any thing does not display, this means your system does not have any swap space.

You can verify there is no active swap using `free` utility:

	free -h

total        used        free      shared  buff/cache   available
Mem:           2.0G        105M        262M         11M        1.6G        1.7G
Swap:            0B          0B          0B

Via `df -h` to check disk space


# Create a swap file

	sudo fallocate -l 2G /swapfile

The program `fallocate` to create a file named `swapfile` in our (/) directory.

Because we have a RAM is 1024MB, so we create a swapfile which space is 2G.

	ls -hl /swapfile

You can verify it now.

# Enable the swap file

Now, we do not turn this into swap space.Make the file only accessible to `root` by typing:

	sudo chmod 600 /swapfile

Next, type:

	sudo mkswap /swapfile

Then, to start utilizing it:

	sudo swapon /swapfile

So, we have finished it.

	sudo df -h

	sudo free -h


# Make swap permanent
Yes, it is in use on this start,you have to add it into `/etc/fstab`
First, back up your `/etc/fstab`. Then,

	echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Tweak your swap setting
The `swappiness` parameter configures how often your system swaps data out of RAM to the space. This is a value between 0 ans 100 that represents a percentage.
If you have a deskop machine, the `60` is ok, but for server, it is better 0.

	cat /proc/sys/vm/swappiness

It will show on my machine:

	60

We can set the swappiness to a different value by using the `sysctl` command.

	sudo sysctl.swappiness=10

If you want to it persent permenant , edit `/etc/sysvtl.conf` file to add:

	vm.swappiness = 10

