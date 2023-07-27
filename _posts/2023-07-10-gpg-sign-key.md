---
title: GPG key 签名使用
category: tools
layout: post
---
* content
{:toc}

首先应该看一下这个wiki:
    https://gist.github.com/F21/b0e8c62c49dfab267ff1d0c6af39ab84
    
# 对别人的签名
可以根据wiki

# 别人对你的签名
通过这个wiki，我们反向理解，并且我加上自己真实案例予以说明。

S老师给我做了一个名为`msg.asc`的加密消息，其内容应该就是s老师给我的签名key。
`cat msg.asc`
```bash
-----BEGIN PGP MESSAGE-----
...
...
```
这就是加密的消息。下面是重点，我们需要使用`--decrypt`选项将这个加密消息进行解密:

```
vimer@dev:~/tmp$ gpg --decrypt msg.asc
gpg: encrypted with 4096-bit RSA key, ID 66681FECEFF9AC75, created 2022-04-09
      "Bo YU <tsu.yubo@gmail.com>"
...

Hi,

please find attached the user id
        Bo YU <tsu.yubo@gmail.com>
of your key 954E6A70100598A2 signed by me.

If you have multiple user ids, I sent the signature for each user id
separately to that user id's associated email address. You can import
the signatures by running each through `gpg --import`.

Note that I did not upload your key to any keyservers. If you want this
new signature to be available to others, please upload it yourself.
With GnuPG this can be done using
        gpg --keyserver hkp://pool.sks-keyservers.net --send-key 954E6A70100598A2
...
------------=_1689674421-10093-0
Content-Type: application/pgp-keys;
 name="0x954E6A70100598A2.1.signed-by-0xxxxxxxx.asc"
Content-Disposition: attachment;
 filename="0x954E6A70100598A2.1.signed-by-0xxxxxx.asc"
Content-Transfer-Encoding: 7bit
Content-Description: PGP Key 0x954E6A70100598A2, uid Bo YU <tsu.yubo@gmail.com>
 (1), signed by 0xxxxxxxxxxx

-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

注意，这个`PUBLIC KEY BLOCK`的内容才是最重要的内容，我的做法是copy出来保存到一个xx.asc文件，然后再 `import`.

```bash
vimer@dev:~/tmp$ gpg --import sun.asc
gpg: key 954E6A70100598A2: 1 signature not checked due to a missing key
gpg: key 954E6A70100598A2: "Bo YU <tsu.yubo@gmail.com>" 1 new signature
gpg: Total number processed: 1
gpg:         new signatures: 1
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u

```

# send-keys 

```bash
vimer@dev:~/tmp$ gpg --keyserver keyserver.ubuntu.com --send-keys 100598A2
gpg: sending key 954E6A70100598A2 to hkp://keyserver.ubuntu.com
```