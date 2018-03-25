---
title: "wireshark使用入门"
category: network
layout: article
---

### 快捷键

[快捷键](https://www.wireshark.org/docs/wsug_html_chunked/ChUseMainWindowSection.html)

### The Menu
![wireshark-usage-2018-03-16_1.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_1.png)
First, you have to understand it: in wireshark, the packet is very important concept.Above, items of menu have `File`,`Edit`, `View`, `Go`,`Capture`,`Analyze` and they use packets(born from TCP/IP) except `file`.

### The main toolbar
![wireshark-usage-2018-03-16_2.png.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_2.png.png)

### The filter menu
![wireshark-usage-2018-03-16_3.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_3.png)

### The "packet List" pane
![wireshark-usage-2018-03-16_4.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_4.png)
Each line in the packet list corresponds to one packet in the capture file, if you select  a line in this pane, more details will be displayed in the "packet pane" and "Packet Bytes" panes.

The picture is very happy:
![wireshark-usage-2018-03-16_5.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_5.png)

### The "packet detailes " pane
![wireshark-usage-2018-03-16_6.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_6.png)
...

# Starting Capture

	wireshsrk -i eth0 -k

This will start Wireshark capturing on interface eth0.

Or you click "Capture" -> "Options", which short key is `ctrl + k`. You can add it and linux command `ifconfig` into to test.

![wireshark-usage-2018-03-16_7.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_7.png)

![wireshark-usage-2018-03-16_8.png](http://yuzibo.qiniudn.com/wireshark-usage-2018-03-16_8.png)
So, my eth0 is called 'enp1s0'
