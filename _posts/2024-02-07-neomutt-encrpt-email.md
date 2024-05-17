---
layout: post
title: "neomutt encrypt email"
category: tools 
---

最近有一个需求是使用 neomutt 加密邮件内容。 相比较签名，加密确实更复杂一些。这里记录一下我探索的经历。

首先的一点是，必须提前把对方的  公钥 asc 导入到自己的主机， 这里我也不确认这是不是正确的方法，因为在实际操作中， neomutt找不到对应邮件的 keyid.  我的想法是，在这里我们应该把这些key放到一个配置目录中去，然后类似 `source` 的机制就应该识别到这些keys。 但是我没有找到这种方式，如果找到的话，恳请告知我一下。

# gpg 如何 import key

可以参考这个 [wiki](https://nick-chen.medium.com/%E5%A6%82%E4%BD%95%E5%82%B3%E8%BC%B8%E5%8F%AA%E6%9C%89%E6%94%B6%E4%BB%B6%E8%80%85%E6%89%8D%E8%83%BD%E9%96%8B%E5%95%9F%E7%9A%84%E7%A7%81%E5%AF%86%E6%96%87%E4%BB%B6-gunpg-%E6%87%89%E7%94%A8-bf9bcfbc9f2e), 如果对方是一个 asc 文件，直接 `import` 即可。

```
gpg --import public.asc
```
但是如何仅仅通过 keyid 直接转换得到 asc 文件呢？ 比如大部分开发者会在邮件末尾附上自己的 gpg key。

经试验以下方法可行:

```bash
vimer@dev:~/git/yuzibo.github.io/_posts$ gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 12345678 
gpg: key 786C63F330D7CB92: 13 duplicate signatures removed
gpg: key 786C63F330D7CB92: public key "example <xx@example.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```
前提是这个 pubkey 的所有者将自己的key上传到 kerserver.

Debian DD 或者 DM 可以直接 fetch from Debian 的服务器, 以及如何更新过期的key，请参考[这里](https://keyring.debian.org/)

```bash
gpg --keyserver keyring.debian.org --recv-keys 0x2404C9546E145360

```

一旦 import， 请看下面的操作.


# neomutt

## neomutt/mutt config

一些 config, 可以参考 [wiki1](https://blog.sanctum.geek.nz/gnu-linux-crypto-email/).

## usage

在 neomutt 下， 如果想要加密的需要，编辑完邮件内容, 到发送界面:

```bash
y:Send  q:Abort  t:To  c:CC  s:Subj  a:Attach file  d:Descrip  ?:Help
        From: Bo YU <tsu.yubo@gmail.com>
          To: xx@example.com
          Cc:
         Bcc:
     Subject: test for encrpting the email
    Reply-To:
         Fcc: +Sent
    Security: Sign (PGP/MIME)
     Sign as: <default>
         Mix: <no chain defined>
     Headers: X-PGP-Key: https://github.com/yuzibo/yuzibo.github.io/blob/master/_includes/subkey-signing-06-18-143E4BAF-pub.asc
-- Attachments

```

按下 `p` 或者 `S` 键, 出现:

```bash
PGP (e)ncrypt, (s)ign, sign (a)s, (b)oth, s/(m)ime or (c)lear?
```
然后选择 `b`就是签名和加密一块选择.
此时 界面 的提示变为:

```bash
 Subject: test for encrpting the email
    Reply-To:
         Fcc: +Sent
    Security: Sign, Encrypt (PGP/MIME)
     Sign as: <default>
         Mix: <no chain defined>
```

一切准备完毕， 输入`y` 发送, 再次提示:

```bash
PGP keys matching <xx@example.com>
ID has undefined validity. Do you really want to use the key? ([no]/yes)
```

输入 `yes` 并且 附带 签名的密码就可以发送了.

# 参考资料
[1](https://wooledge.org/~greg/crypto/node44.html)
[2](https://kb.wisc.edu/iam/page.php?id=4091)
[3](https://blog.sanctum.geek.nz/gnu-linux-crypto-email/)
