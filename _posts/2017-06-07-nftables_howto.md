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

# Basic
Adding tables

% nft add table ip filter
Show/List tables

% nft list tables
Deleting tables

% nft delete table ip foo
Troubleshooting: Since Linux kernel 3.18, you can delete tables and its content with this command. However, before that version, you need to delete its content first, otherwise you hit an error that look like this:
% nft delete table filter
<cmdline>:1:1-19: Error: Could not delete table: Device or resource busy
delete table filter
^^^^^^^^^^^^^^^^^^^
Flushing tables

You can delete all the rules that belong to this table with the following command:
% nft flush table ip filter
This removes the rules for every chain that you register in that table.

