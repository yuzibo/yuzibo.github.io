---
title: "pygame知识点总结"
category: python
layout: post
---

* content
{:toc}

### pygame中加载位图、绘制位图
pygame中有这些类和函数：

```python
#1
screen = pygame.display.set_mode()
#上面这个函数会返回一个Surface 对象,他是位图的一种.

#2
space = pygame.image.load("xx.png")

#3, Surface对象有一个名为blit()的方法，它可以绘制位图
screen.blit(space, (0,0))
""" 第一个参数是加载完成的位图，第二个参数是绘制的起始坐标"""
```


其实，没有代码的话直说函数有点空洞，现在我就将最重要的(至少我认为是)的重点列出来，以方便自己复习。


    keys = pygame.key.get_pressed()

这个函数就是在打开的界面中监听你的动作，顺便说一句，在python中，函数的返回值最好设为列表，这样就和绝大多数的库函数保持一致了。

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import pygame
from pygame.locals import *
from sys import exit
import sys, random, time
""" 这个函数是简单的打印文字的，需要总结一下"""
def print_text(font, x, y, text, color = (255,255,255)):
    imgText = font.render(text, True, color)
    screen.blit(imgText, (x,y))

# 主程序
# 这样的程序最好分开写比较好

pygame.init()

screen = pygame.display.set_mode((600,500))
pygame.display.set_caption("Leyboard Demo")
font1 = pygame.font.Font(None, 24)
font2 = pygame.font.Font(None, 200)

white = 255,255,255
yellow = 255,255,0
color = 125,100,210

key_flag = False
correct_answer = 97
seconds = 10
score = 0
clock_start = 0
game_over = True
# 这是重点
while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            exit()
        elif event.type == KEYDOWN:
            key_flag = True
        elif event.type == KEYUP:
            key_flag == False

    keys = pygame.key.get_pressed()
    if keys[K_ESCAPE]:
        exit()

    if keys[K_RETURN]:
        if game_over:
            game_over = False
            score = 0
            seconds = 11
            clock_start = time.clock()

    current = time.clock() - clock_start
    speed = score * 6

    if seconds - current < 0:
        game_over = True
    elif current:
        if keys[correct_answer]:
            correct_answer = random.randint(97, 122)
            score += 1

    #清屏
    screen.fill(color)
    print_text(font1, 0, 20, "Try to keep up for 10 seconds...")

    if key_flag:
        print_text(font1, 450, 0, "You are keying...")

    if not game_over:
        print_text(font1, 0, 80, "Time:" + str(int(seconds - current)))

    print_text(font1, 0, 100, "speed: " + str(speed) + "letters/min")

    if game_over:
        print_text(font1, 0, 160, "Press Enter to start ...")

    print_text(font2, 0, 240, chr(correct_answer - 32), yellow)

    #update
    pygame.display.update()
```
