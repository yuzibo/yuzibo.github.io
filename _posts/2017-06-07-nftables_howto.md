---
title: "nftables简介"
category: nft
layout: article
---

# howtos
## install

First :

# Needed libraries
libmnl:
libnftnl
libmnl: git://git.netfilter.org/libmnl
libnftnl: git://git.netfilter.org/libnftnl

```bash
./autogen.sh
./configure
make
make install
ldconfig
```

If you have error as below:

```bash
./configure: line 3960: syntax error near unexpected token `LIBMNL,'
./configure: line 3960: `PKG_CHECK_MODULES(LIBMNL, libmnl >= 1.0.0)'
```

please refer to here:

http://blog.anarey.info/2014/08/pkg_check_moduleslibmnl-libmnl-1-0-0-error/



# nftables

```bash
sudo apt-get install libgmp-dev libreadline-dev
```


首先在安装之前，请参考这篇[文章](https://home.regit.org/netfilter-en/nftables-quick-howto/)，这篇文章还是比较好的。

How to use the code:
http://git.netfilter.org/libnftnl/tree/examples

#GSoC for nft

http://people.netfilter.org/pablo/nf-ideas-2018.txt

Here are some articles records the educational:

[article](https://github.com/ecklm/gsoc-blog/blob/master/_posts/2018-04-30-blog-intro.md)

# Basic concept
With nft, you can create `table/chain/rule/set` and families include `ipv4/ipv6/arp/inet/bridge/netdev/`

If this is your first time to run it, yiu can try it(in nftable git):

	nft -f files/examples/ipv4-filter.nft

then

	nft list table filter

The result is below:

![nft_list_tables-2018-03-12.png](http://yuzibo.qiniudn.com/nft_list_tables-2018-03-12.png)

## Tables
Via the output above, we know, in nftables, a table is at the top of the ruleset, It consists of chains, which are containers for rules, in a word, Table->Chains->Rules

You can `add/delete/list/flush` table.(flush is mean to empty table)

## Rules
You can list the rules that are contained by a table with the following command:

	sudo nft list table filter

```bash
table ip filter {
	chain input {
		type filter hook input priority 0; policy accept;
	}

	chain forward {
		type filter hook forward priority 0; policy accept;
	}

	chain output {
		type filter hook output priority 0; policy accept;
		ip daddr 1.2.3.4 drop
		ip protocol tcp
	}
}
```


