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


一个更简单的IRC log:

```bash
00:33 < count_omega> clone the repo and install cargo debstatus : cargo install cargo-debstatus
00:34 < count_omega> then cd into the helix folder and run cargo debstatus, it will print all missing packages
00:36 < mjt> does it take experimental into account?
00:36 < mjt> or does it look at debcargo-conf?
00:37 < count_omega> no experimental, no d-c-c iirc
00:37 < mjt> so how does it know which deps are missing?
00:37 < count_omega> checks against udd
00:38 < count_omega> it's not ideal, granted, but I am eternally grateful for it
00:44 < count_omega> hah, owned by jonas: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1024683
00:44 < count_omega> vieta:  ^
00:45 < count_omega> these are all (?) of the missing crates https://salsa.debian.org/debian/hx/-/blob/debian/latest/debian/TODO
01:14 < vieta> sry for the late respone @count_omega . I got by both (current and 23.05) versions: "Error: this command requires running
               against an actual package in this workspace"
01:47 < count_omega> yeah you need to cd into a subdirectory
01:47 < count_omega> Like helix-core
01:55 < mjt> that smells like a work for someone with good experience in this area..
01:56 < mjt> and jonas apparently already have the work done
02:24 < count_omega> No, that's the thing: he packages bigger rust projects like that on his own (sure, he can do that) but outright
                     refuses to use any of the debcargo tooling/ team work and files ITPs for crates
02:24 < count_omega> And then gets mad when we upload our versions
02:33 < vieta_> Sry, I lost the context. Was that ment to me on "20:24"?

02:39 < count_omega> link to the paste ?
02:39 < vieta_> https://paste.debian.net/1281428/
02:42 < count_omega> so this prints all dependencies nicely and shows you what's missing. etcetera seems like a good starting point
02:42 < count_omega> https://crates.io/crates/etcetera
02:43 < count_omega> I recommend reading this first: https://blog.hackeriet.no/packaging-a-rust-project-for-debian/

```