---
title: "python 数据可视化matplotlib简介"
category: python
layout: article
---


# install

python 2.7:

	sudo apt-apt install matplotlib


## 小试牛刀

```python
import matplotlib.pyplot as plt

squares = [1, 4, 9,25]
plt.plot(squares)
plt.show()
```

这个代码段就打开了一个二维坐标图。我们首先导入模块pyplot,因为它有很多用于生成图表的函数。

下面作为更详细的介绍.

## 修改标签文字和线条粗细

```python

import matplotlib.pyplot as plt
import matplotlib

zhfont1 = matplotlib.font_manager.FontProperties(fname='/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc')

squares = [1, 4, 9, 16, 25]
plt.plot(squares, linewidth = 5)

# 　set title
plt.title(u"平方数据",fontsize = 24, fontproperties=zhfont1)
plt.xlabel(u"值", fontsize = 12, fontproperties=zhfont1)
plt.ylabel(u"值的平方", fontsize = 12, fontproperties=zhfont1)

# set scale
plt.tick_params(axis='both', labelsize=14)
plt.show()

```
参数*linewidth*决定了plot()绘制的线条的粗细，像title, xlabel,ylabel这些就不用多说了吧，尤其第三个参数fontproperties这个下面就有介绍。

plt.tick_params就是设置刻度的样式，其中指定的实参将影响x轴和y轴的刻度(axis='both')

显示的效果如下：

![mat_1.png](http://yuzibo.qiniudn.com/mat_1.png)


大家请注意第zhfont1,这个对象就是指定matplotlib使用的字体，这个不指明的话容易造成乱码，这里，有必要说一下fname的参数，这个传递不对的话也不行。

怎么看你的系统支持哪一种字体呢？使用：

```bash
fc-list
```

然后指明字体路径即可。

## 校正图形

不知道大家有没有注意到上面的图片中，有几个问题，那就是在4.0这个点指向了25，现在就得修复这个问题了。

```python
input_values = [1, 2, 3, 4, 5]
squares = [1, 4, 9, 16, 25]
plt.plot(input_values, squares, linewidth = 5)
```
效果如下图所示：

![mat_2.png](http://yuzibo.qiniudn.com/mat_2.png)

这种方式是浅显易懂的，主要是因为有了输入数据，而不必需要matplotlib去猜。

## 分散点(scatter)
上面的图像是连续的，如果使用分散点，那么就可以使用scatter()方法了。

为了节省空间，下面的代码段中有很多的注释，这里就不一一讲解了。　

```python
plt.scatter(2,4)

# 一系列的点
x_values = [1,2,3,4,5]
y_values = [1, 4, 9, 16, 25]
plt.scatter(x_values, y_values, s=100)

#自己填充数字 及　确定刻度范围
# 这样的填充点因为数据太密了，连成一条曲线了
x_values = list(range(1, 1001))
y_values = [x**2 for x in x_values]

plt.axis([0, 1100, 0, 1100000])

# edgecolor 删除点的轮廓和改变颜色
plt.scatter(x_values, y_values, c = 'red', edgecolor = 'none', s=40)

# 颜色映射colormap: 根据数据的变化规律用颜色展示出来。
# c = y_values 就是将颜色索引值传递给c
plt.scatter(x_values, y_values,  edgecolor = 'none', c = y_values, s=40)

# 自动保存图像,这里需要注意的是将　plt.show()替换掉，否则就会显示为一张空白的图片
plt.savefig('squares_plot.png', bbox_inches = 'tight')

```

其他的代码不用改变，只是代替plt.plot()方法即可。

# 随机漫步

这个东西有点类似随机化算法，下面请看代码实现.

code in random_walk.py:

```python

from random import choice

class RandomWalk():
    def __init__(self, num_point = 5000):
        """ 初始化随机漫步的属性"""
        self.num_point = num_point

        # 所有的随机漫步都始于(0,0)
        self.x_values = [0]
        self.y_values = [0]


    def fill_walk(self):
    # walk and up to length of
        while len(self.x_values) < self.num_point:
        # decise direction and distance
            x_direction = choice([-1, 1])
            x_distance = choice([0, 1, 2, 3, 4])
            x_step = x_direction * x_distance

            y_direction = choice([-1, 1])
            y_distance = choice([0, 1, 2,3,4])
            y_step = y_direction * y_distance

        # refuse keep original
            if x_step == 0 and y_step == 0:
                continue

        # caluate next x and y, x_step add last element in x_values
            next_x = self.x_values[-1] + x_step
            next_y = self.y_values[-1] + y_step

            self.x_values.append(next_x)
            self.y_values.append(next_y)
```

上面的代码只是定义了一个使用的类，下面是使用的方法。

code in rw_visual.py:

```python

import matplotlib.pyplot as plt

from mpl_squares import RandomWalk

# 创建一个RandomWalk（）实例

rw = RandomWalk()
rw.fill_walk()

plt.scatter(rw.x_values, rw.y_values, s=15)

plt.show()

```

效果如图所示：

![mat_3.png](http://yuzibo.qiniudn.com/mat_3.png)

还可以使用循环，做一下好几次变化的输出：

```python
while True:
	--[snip]--

	keep_running = raw_input("make a another(y/n)?")
	if keep_running == 'n'
	break
```

还可以像前面那样使用颜色映射：

```python
point_numbers = list(range(rw.num_point))
plt.scatter(rw.x_values, rw.y_values, c=point_numbers, cmap=plt.cm.Blues, edgecolor='none', s=15)
```

还可以突出起点和终点:

```python

plt.scatter(rw.x_values, rw.y_values, c=point_numbers, cmap=plt.cm.Blues, edgecolor='none', s=15)
--[snip]--
    plt.scatter(0,0,c='green', edgecolor='none', s=100)
    plt.scatter(rw.x_values[-1], rw.y_values[-1], c='red', edgecolor='none', s=15)
--[snip]--
```
也就是说,plt.scatter方法是可以前后调用的，当你前面已经描绘出随机点的时候，后面的可以突出起点和终点.

还可以隐藏坐标轴:

```python

    plt.axes().get_xaxis().set_visible(False)
    plt.axes().get_yaxis().set_visible(False)
```

实际上介绍到这里，还是希望大家能够阅读文档，这里的实质性的东西太少，并不能给你一个透彻的理解.

