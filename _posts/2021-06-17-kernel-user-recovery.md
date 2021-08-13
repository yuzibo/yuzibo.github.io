---
title: unix 信号的使用案例
category: unix
layout: post
---
* content
{:toc}

先看代码“

```c

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <poll.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>

#define EXIT_ERR(m) \
do\
{\
    perror(m);\
    exit(EXIT_FAILURE);\
}\
while (0)

static int fd;

void recovery_signal_handle(int signum)
{
    unsigned int val = 0;
    int status;
    read(fd, &val, 1);
    if (val == 0){
        sleep(7);
        if (val == 0) {
            printf("I'm pretty sure that recovery button is pushed down, go and boot from B slot!!!\n");
            //status = system("nvbootctrl -t bootloader set-active-boot-slot 1");
            //printf("nvbootctrl -t bootloader set-active-boot-slot 1\n");
	    	status = system("nvbootctrl -t rootfs set-active-boot-slot 1");
            printf("nvbootctrl -t rootfs set-active-boot-slot 1\n");
		    if (status == -1) {
		        EXIT_ERR("system nvbootctrl error");
		    }else {
		        printf("Now this station is going to reboot...\n");
		        sleep(1);
		        status = system("reboot");
		        if (status == -1) {
		            EXIT_ERR("system reboot error");
		        }
            }
        }
    }
}

int main(int argc, char **argv)
{
    int Oflags;

    //SIGIO, driver sends this signal to note that Interrupt is coming.
    signal(SIGIO, recovery_signal_handle);

    fd = open("/dev/recovery", O_RDWR);
    if (fd < 0)
        printf("can't open!\n");

    //set the process ID that will receive SIGIO signal for events on the fd.
    fcntl(fd, F_SETOWN, getpid());

    //get the file status flags
    Oflags = fcntl(fd, F_GETFL);

    //set the file status flags to Oflags | FASYNC.
    //You could find "#define FASYNC O_ASYNC" in fcntl.h of glibc.
    //O_ASYNC means generating a signal when input or output becomes possible on this fd.
    fcntl(fd, F_SETFL, Oflags | FASYNC);

    while (1){
        sleep(1000);
    }

    return 0;
}

```
