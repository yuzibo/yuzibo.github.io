---
title: "nftables简介"
category: nft
layout: article
---

# howtos
首先在安装之前，请参考这篇[文章](https://home.regit.org/netfilter-en/nftables-quick-howto/)，这篇文章还是比较好的。

How to use the code:
http://git.netfilter.org/libnftnl/tree/examples

GSoC for nft
http://people.netfilter.org/pablo/nf-ideas-2018.txt


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
