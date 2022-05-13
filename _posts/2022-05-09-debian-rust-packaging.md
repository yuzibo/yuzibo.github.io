---
title: debian rust packaging notes
category: debian-riscv
layout: post
---
* content
{:toc}

目前还没有对debian rust进行打包，但是应该在不远的将来会打包。

# messages  from IRC

```bash
<count_omega> capitol: how do I download the crate? With cargo ?
<capitol> curl -L https://crates.io/api/v1/crates/$name/$version/download | tar -xf -
<count_omega> K thanks
<f_g> count_omega: cargo doesn't expose it itself, but `debcargo extract $crate` does
<f_g> (it's basically just the first step of `debcargo package`, which is what get's called by update.sh
```

# 要学习的blog
[https://blog.hackeriet.no/packaging-a-rust-project-for-debian/](https://blog.hackeriet.no/packaging-a-rust-project-for-debian/)


