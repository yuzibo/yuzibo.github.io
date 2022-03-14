---
title: Nezha D1 boards install Debian 11
category: debian-riscv
layout: post
---
* content
{:toc}

Please visit the [link](https://www.rvboards.org/forum/cn/topic/61/rvboards-%E5%93%AA%E5%90%92-d1-debian%E7%B3%BB%E7%BB%9F%E9%95%9C%E5%83%8F%E5%92%8C%E5%AE%89%E8%A3%85%E6%96%B9%E6%B3%95/60) and follow the instructions to install Debian 11 on D1 boards.

But if you have problems to download those files that the above url mentioned, you can download those files from my [google drive](https://drive.google.com/drive/folders/12xBG_VQQRhEi_wMg7I10lhiNzOhswDNZ?usp=sharing).

Conditions: windows 10+, SD card reader

# flash image

Once we have downloaded those file: `RVBoards_D1_Debian_img_v0.6.1.zip` 和`PhoenixCardv4.2.7.7z`.

Prequirements: A card reader that insertd into pc with a sd card(16GB+), better 32GB or nore.

1. We first untar PhoenixCardv4.2.7.7z file to get PhoneixCard exe program. Open it and we push button as "固件"(fireware) to choose image file that we downloaded RVBoards_D1_Debian_img_v0.6.1.zip (untar it first please).

2. Then we choose "启动卡"(boot card) as card flashing category.

3. At last to choose "烧卡" (flash card) to start flash process.

And wait a few minutes we can see the flashing task have beed finished.

Then we can connect D1 boards with HDMI monitor and sd card insert into boards and power in on, at last we to login:

user: rvboards/root
passwd: rvboards

ps: The Serial Port Connection has issue to debug the boards I encountered.