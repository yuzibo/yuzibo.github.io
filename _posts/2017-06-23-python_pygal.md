---
title: "python画表--pygal简介"
category: python
layout: article
---

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="//ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=vimerbf-20&marketplace=amazon&region=US&placement=1593276036&asins=1593276036&linkId=f5eaeee62c358a4e99f19b434f682e82&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066C0&bg_color=FFFFFF">
    </iframe>
    
# install

	sudo pip install pygal

python可以画比较优美的图表，现在介绍一下pygal的简单用法，下面模拟一个掷骰子的游戏。

code in die.py

```python
from random import randint
class Die():
    """ a class of die(骰子)"""
    def __init__(self, num_sides = 6):
        # default a die have 6 sides
        self.num_sides = num_sides

        def roll(self):
            """ return a random number between 1 and side"""
            return randint(1, self.num_sides)
```
下面是实例化的代码： code in die_visual.py
```python

from die import Die

die = Die()
# throw die, result in a list
results = []

for roll_num in range(100):
    result = die.roll()
    results.append(result)

print(results)
```
上面的代码你应该知道怎么去运行吧？

### 分析结果
很简单，就是简单的把１，２,,,６出现的频率分析一下：

```python
--[snip]--
frequencier = []
for value in range(1, die.num_sides + 1):
    frequency = results.count(value)
    frequencier.append(frequency)
--[snip]--
```
这个思想和上面的没啥区别，关键有一点我不是很明白，为什么是从点数是从１到die.num_sides+1,直接到die.num_sides不行吗?不行，请看下面的代码:

```python
for i in range(1, 6):
    print i
# output: 1 2 3 4 5
```

原来是两端取一端的。

#  绘制直方图
下面的才是今天的重点，

```python
--[snip]--
# 绘制直方图

hist = pygal.Bar()
hist.title = u"投掷1000次的结果"
hist.x_labels = ['1','2','3','4','5','6']
hist.x_title = u"结果"
hist.y_title = u"结果的频率"

hist.add('D6', frequencier)
hist.render_to_file('die_visual.svg')
```

效果如下所示：

![pygal_1.png](http://yuzibo.qiniudn.com/pygal_1.png)

下面就是画出两个骰子的分布图，代码只需做一个修改，为了不占用空间，请[参考](0https://github.com/yuzibo/linux-programming/tree/master/python/python_crash/visual)
