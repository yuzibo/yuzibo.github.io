---
title: unix 信号的使用案例
category: unix
layout: post
---
* content
{:toc}

先看代码

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

然后看一下内核源代码是怎么写的:

```c
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/gpio.h>                 // Required for the GPIO functions
#include <linux/interrupt.h>            // Required for the IRQ code
#include <linux/cdev.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
//#include <linux/device.h>


MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");

static int major;

static struct class *vimer_recovery_class;
static struct device *vimer_recovery_class_dev;

static unsigned int recovery_button = 393;	//GPIO01--421,GPIO11--422,GPIO13--393
static unsigned int irq_number;

static struct fasync_struct *recovery_async;

static irq_handler_t vimer_recovery_irq_handler( unsigned int irq, void *dev_id, struct pt_regs *regs )
{
   printk(KERN_INFO "RECOVERY_TEST:: interrupt received! (recovery button state is %d)\n", gpio_get_value(recovery_button));

//deliver a signal to interested processes(userspace) when the interrput comes.
   if (recovery_async) {
      kill_fasync(&recovery_async, SIGIO, POLL_IN);
   }

   return (irq_handler_t) IRQ_HANDLED;
}

static int vimer_recovery_fasync(int fd, struct file *filp, int on)
{
   printk("driver: vimer_recovery_fasync\n");
//add files to or remove files from the lists of interested processes when the FASYNC flag changes for an open file.
   return fasync_helper(fd, filp, on, &recovery_async);
}

static int vimer_recovery_open(struct inode *inode, struct file *filp)
{
   int result = 0;

   printk(KERN_INFO "RECOVERY_TEST:: Initializing the RECOVERY_TEST LKM\n");

   gpio_request(recovery_button, "sysfs");
   gpio_direction_input(recovery_button);
   gpio_set_debounce(recovery_button, 200);
   gpio_export(recovery_button, false);

   printk(KERN_INFO "RECOVERY_TEST:: the current state of recovery button is: %d\n", gpio_get_value(recovery_button));

   irq_number = gpio_to_irq(recovery_button);
   printk(KERN_INFO "RECOVERY_TEST:: the recovery button is mapped to IRQ: %d\n", irq_number);

   result = request_irq(irq_number,
                        (irq_handler_t) vimer_recovery_irq_handler,
                        IRQF_TRIGGER_FALLING,
                        "vimer_recovery_handler",
                        NULL);
   if( result < 0 )
   {
      printk(KERN_INFO "RECOVERY_TEST:: request_irq returns ERROR: %d, please kindly check\n", result);
   }
   return result;
}

static ssize_t vimer_recovery_read(struct file *filp, char __user *buf, size_t size, loff_t *ppos)
{
   unsigned int val;
   int ret;

   val = gpio_get_value(recovery_button);
   ret = copy_to_user(buf, &val, 1);

   return 1;
}

static int vimer_recovery_close(struct inode *inode, struct file *filp)
{
   printk(KERN_INFO "RECOVERY_TEST:: the current state of recovery button is: %d\n", gpio_get_value(recovery_button));
   free_irq(irq_number, NULL);
   gpio_unexport(recovery_button);
   gpio_free(recovery_button);
   vimer_recovery_fasync(-1, filp, 0);
   printk(KERN_INFO "RECOVERY_TEST:: close from the LKM!\n");

   return 0;
}

static struct file_operations vimer_recovery_fops =
{
   .owner = THIS_MODULE,
   .open = vimer_recovery_open,
   .read = vimer_recovery_read,
   .release = vimer_recovery_close,
   .fasync = vimer_recovery_fasync,
};

int vimer_recovery_init(void)
{
   major = register_chrdev(0,"vimer_recovery", &esw_recovery_fops);
   vimer_recovery_class = class_create(THIS_MODULE, "esw_recovery");
   vimer_recovery_class_dev = device_create(esw_recovery_class, NULL, MKDEV(major, 0), NULL, "recovery"); /* /dev/recovery */

   return 0;
}

void vimer_recovery_exit( void )
{
   unregister_chrdev(major, "vimer_recovery");
   device_unregister(vimer_recovery_class_dev);
   class_destroy(vimer_recovery_class);
}

module_init(vimer_recovery_init);
module_exit(vimer_recovery_exit);

```
