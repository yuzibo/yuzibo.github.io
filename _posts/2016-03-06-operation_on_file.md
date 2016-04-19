---
layout: article
categroy: c
title: "c语言的文件操作"
---


#include<stdio.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

#define LENGTH 100

int main()
{
	int fd, len;
	char str[LENGTH];
	fd = open("hello.txt", O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
	/*
	 * creat and open file
	 * */
	if(fd){
		write(fd, "Hello,world",strlen("Hello,world"));
		close(fd);

	}
	fd = open("hello.txt",O_RDWR);
	len = read(fd, str, LENGTH);
	/*
	 * str copied from file that should add '\0'
	 * */
	str[len] = '\0';
	printf("%s\n",str);
	close(fd);


}
/*
 * 上面的c语言函数是系统调用，这段代码是库函数的实现
 * 从这里我们可以看出，库函数的文件操作的前面都有一个f，
 * 这可能就是这两者最明显的区别了
 * */
#include<stdio.h>
#define LENGTH 100
int main()
{
	FILE *fd;
	char str[LENGTH];
	fd = fopen("yubo.txt","w+");
	if(fd){
		fputs("Hello,yubo", fd);
		/*Here, fputs write char into file */
		fclose(fd);
	}
	fd = fopen("yubo.txt","r");
	fgets(str,LENGTH,fd);
	printf("%s\n",str);
	fclose(fd);

}
