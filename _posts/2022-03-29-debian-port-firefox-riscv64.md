---
title: debian port(packaging) firefox
category: tools
layout: post
---
* content
{:toc}


目前，firefox局部升级确实遇到一些困难，不过，好消息是，社区目前正式承认这个问题。

以下内容是我打包过程中遇到的一些raw data，供后面学习、复盘时使用。

===========>&==========

the right way to update is cargo update -p nix, then ./mach vendor rust
But since nix is probably used by some other dependency, you probably need to update that as well
It seems nix is used by alsa and midir
So you'd need to update it in those crates

for reference, the minimal patch to update nix locally would be this:
0001-Update-nix...patch (1004.5 KB)
vimer: ^, that's on central, but the important changes are in the top level Cargo.toml then in the individual crates that use nix
vimer: but the right thing to do is to send PRs to the relevant crates and then update them in Gecko
That is, send a PR updating nix in https://github.com/mozilla/midir, https://github.com/mozilla/alsa and https://github.com/msirringhaus/minidump_writer_linux

Oh, that is cool. thank you very!!!  
emilio
You can probably do the local thing for now, and send the PR so that when we update those crates we update nix as well
vimer
I will send PR as you said
emilio
Sweet, thanks!
msirringhaus
vimer
I will send PR as you said
For the record: minidump_writer_linux is already on nix 0.23, but it's not yet vendored in the FF-tree.
vimer
msirringhaus: Ok, will notice it.
BTW, Where is FF-tree source code pubilc? I google a lot but nothing :-(
msirringhaus
vimer
msirringhaus: Ok, will notice it.
There has been some changes to it lately that need proper testing. I have handed over ownership of the crate to a newly created rust-minidump org (but I'm still involved). If you want to vendor it with the nix-dependency, either open an issue there (the link above will redirect correctly) and/or hop over to #crashreporting:mozilla.org
vimer
BTW, Where is FF-tree source code pubilc? I google a lot but nothing :-(
https://hg.mozilla.org/
hg.mozilla.org index
hg.mozilla.org repository index
emilio
also https://searchfox.org for a searchable version
vimer
The url it reports: ERR_CONNECTION_CLOSED from hg
emilio
The trunk repo is https://hg.mozilla.org/mozilla-central/
mozilla-central summary
A summary of repository state for mozilla-central
See https://firefox-source-docs.mozilla.org/contributing/contribution_quickref.html#clone-the-sources
Firefox Contributors’ Quick Reference — Firefox Source Docs documentation
» Working on Firefox » Firefox Contributors’ Quick Reference Report an issue / View page source Firefox Contributors’ Quick Reference¶ Some parts of this process, including cloning and
vimer
Ok, will look into. Thank all again

=========&>========

# firebox code架构

## toolchain的配置

`build/moz.configure/toolchain.configure`.