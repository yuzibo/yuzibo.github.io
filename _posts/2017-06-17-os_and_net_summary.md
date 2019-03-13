---
title: os 和 net总结
category: kernel
layout: post
---
* content
{:toc}

# 1. system call VS interrupt
System call is a call to a subroutine built in to the system, while Interrupt is an event, which causes the processor to temporarily hold the current execution. However one major difference is that system calls are synchronous, whereas interrupts are not. That means system calls occur at a fixed time (usually determined by the programmer), but interrupts can occur at any time due an unexpected event such as a key press on the keyboard by the user. Therefore, when ever a system call occurs the processor only has to remember where to return to, but in the event of an interrupt, the processor has to remember both the place to return to and the state of the system. Unlike a system call, an interrupt usually does not have anything to do with the current program.
