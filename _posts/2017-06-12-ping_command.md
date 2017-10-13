---
title: "ping命令自己实现"
category:
layout: article
---
[这篇](http://www.aftermath.cn/icmp.html)文章从内核的角度来看ICMP的，现在，ping命令就是利用icmp实现的。

首先看一个大概。

```c


/*
 *     File Name: ping.c
 *     Author: Bo Yu
 *     Mail: tsu.yubo@gmail.com
 *     Created Time: 2017年10月10日 星期二 16时53分33秒
 *     用于实现ping的原理
 */
#include <stdio.h>
#include <signal.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <netdb.h>
#include <setjmp.h>
#include <errno.h>
#include <signal.h>


#define MAX_WAIT_TIME	5
#define MAX_NO_PACKETS 3
#define PACKET_SIZE	4096
char sendpacket[PACKET_SIZE];
char recvpacket[PACKET_SIZE];



int sockfd, datalen = 56;
struct sockaddr_in dest_addr;
pid_t pid;
int nsend = 0, nreceive = 0;

struct sockaddr_in from;
struct timeval tvrecv;

/* 校验和算法 */
unsigned short cal_chksum(unsigned short *addr, int len)
{
	int nleft = len;
	int sum = 0;
	unsigned short *w = addr;
	unsigned short answer = 0;
	/* 将 ICMP报头二进制为单位累加起来 */
	while(nleft > 1){
		sum += *w++;
		nleft -= 2;
	}
	/* 这个校验和算法真的不明白 */
	if (nleft == 1){
		*(unsigned char *)(&answer) = *(unsigned char *)w;
		sum += answer;
	}
	sum = (sum >> 16) + (sum&0xffff);
	sum += (sum >> 16);
	answer =~ sum;
	return answer;

}

/* 设置ICMP 报头
 * @pack_no 应该是packet seq
 * */
int pack(int pack_no)
{
	int i, packsize;
	struct icmp *icmp;
	struct timeval *tval;
	icmp = (struct icmp*)sendpacket;
	icmp->icmp_type = ICMP_ECHO;
	icmp->icmp_code = 0;
	icmp->icmp_cksum = 0;
	icmp->icmp_seq = pack_no;
	icmp->icmp_id = pid;
	packsize = 8 + datalen;
	tval = (struct timeval *)icmp->icmp_data;
	gettimeofday(tval, NULL); /*记录发送时间*/
	/* 校验算法 */
	icmp->icmp_cksum = cal_chksum((unsigned short *)icmp, packsize);
	return packsize;


}

/* 发送三个ICMP报文 */
void send_packet()
{
	int packetsize;
	while (nsend < MAX_NO_PACKETS){
		nsend++;
		/* 设置ICMP报头 */
		packetsize = pack(nsend);
		if(sendto(sockfd, sendpacket, packetsize, 0,
			(struct sockaddr *)&dest_addr, sizeof(dest_addr)) < 0)
		{
			perror("sendto error");
			continue;
		}
		sleep(1); /*每隔一秒发送一个ICMP报文*/
	}

}
/* 统计信息*/
void statistics(int signo)
{
	printf("\n--------PING statistics----------\n");
	printf("%d packets transmitted, %d received, %%%d lost\n",
			nsend, nreceive, (nsend - nreceive)/nsend * 100);
	close(sockfd);
	exit(1);


}
/*两个timeval 结构相减*/
void tv_sub(struct timeval *out, struct timeval *in)
{
	if((out->tv_usec -= in->tv_usec) < 0)
	{
		--out->tv_sec;
		out->tv_usec += 1000000;
	}
	out->tv_sec -= in->tv_sec;
}

/* 剥去ICMP报头，这是理解ip结构的精彩一步 */
int unpack(char *buf, int len)
{
	int i, iphdrlen;
	struct ip *ip;
	struct icmp *icmp;
	struct timeval *tvsend;
	double rtt;
	ip = (struct ip *)buf;
	/* 求ip报头长度，用ip报头长度标志乘以4*/
	iphdrlen = ip->ip_hl << 2;
	/* 越过ip报头，指向ICMP报头*/
	icmp = (struct icmp *)(buf + iphdrlen);
	/* * ICMP 报头及ICMP数据报的总长度*/
	len -= iphdrlen;
	/*小于 * ICMp报头长度不合理*/
	if(len < 8) {
		perror("ICMP packets\'s length is less than 8");
		return -1;
	}
	/*确保所接受的是我所发的ICMP的回应*/
	if((icmp->icmp_type == ICMP_ECHOREPLY) && (icmp->icmp_id == pid))
	{
		tvsend = (struct timeval *)icmp->icmp_data;
		/* 接受和发送时间差*
		 */
		tv_sub(&tvrecv, tvsend);
		/*以毫秒为单位计算rtt*/
		rtt = tvrecv.tv_sec * 1000 + tvrecv.tv_usec/1000;
		/*显示相关信息*/
		printf("%d bytes from %s: icmp_seq=%u ttl=%d rtt=%.3f ms\n", len, inet_ntoa(from.sin_addr), icmp->icmp_seq, ip->ip_ttl, rtt);
	}
	else
		return -1;
}
/*接受所有的
 * ICMP报文 */
void recv_packet()
{
	int n, fromlen;
	extern int errno;
	/* 调用 statistics 函数*/
	signal(SIGALRM, statistics);
	fromlen = sizeof(from);
	while(nreceive < nsend){
		alarm(MAX_WAIT_TIME);
		if((n = recvfrom(sockfd, recvpacket, sizeof(recvpacket),
				0, (struct sockaddr *)&from, &fromlen)) < 0)
		{
			if(errno == EINTR)
				continue;
			perror("recvfrom error");
				continue;
		}
		gettimeofday(&tvrecv, NULL);
		if(unpack(recvpacket, n) == -1)
			continue;
		nreceive++;

	}

}
int main(int argc, char **argv)
{
	struct hostent *host;
	struct protoent *protocol;
	unsigned long inaddr = 0l;
	int waittime = MAX_WAIT_TIME;
	int size = 50*1024;

	if(argc < 2)
	{
		printf("usage: %s hostname/IP address\n", argv[0]);
		exit(1);
	}
	if((protocol = getprotobyname("icmp")) == NULL)
	{
		perror("getprotobyname");
		exit(1);
	}
	if((sockfd = socket(AF_INET, SOCK_RAW, protocol->p_proto)) < 0)
	{
		perror("socket error");
		exit(1);
	}
	/* 回收root权限，设置当前权限 */
	setuid(getuid());
	/* 扩大套接字接收缓冲区到50K,不过，对于，下面的参数我是很不了解 */
	setsockopt(sockfd, SOL_SOCKET, SO_RCVBUF, &size, sizeof(size)); bzero(&dest_addr, sizeof(dest_addr)); dest_addr.sin_family = AF_INET;
	/* 判断是主机名还是ip地址 */
	if((inaddr = inet_addr(argv[1])) == INADDR_NONE)
	{
		if((host = gethostbyname(argv[1])) == NULL) /*是主机名*/
		{
			perror("gethostbyname error");
			exit(1);
		}
		memcpy((char *)&dest_addr.sin_addr, host->h_addr, host->h_length);

	}
	else /*  是ip地址 */
	{

		printf("Here is wrong?:%s\n", argv[1]);
		memcpy((char *)&dest_addr.sin_addr, (char *)&inaddr, sizeof(argv[1]));
	}

	/* 获取main的进程id，用于设置ICMP的标识符 */
	pid = getpid();
	printf("PING %s(%s): %d bytes data in ICMP packets.\n", argv[1],
			inet_ntoa(dest_addr.sin_addr), datalen);
	send_packet(); /* 发送所有ICMP报文*/
	recv_packet(); /*接受所有的ICMP报文*/
	statistics(SIGALRM); /*进行统计*/
	return 0;

}

```
首先介绍实现这个命令需要的结构体。

### hostent

These structures are located in /usr/include/netdb.h
首先了解一下这个结构体：

```c
/* Description of data base entry for a single host.  */
struct hostent
{
  char *h_name;			/* Official name of host.  */
  char **h_aliases;		/* Alias list.  */
  int h_addrtype;		/* Host address type.  */
  int h_length;			/* Length of address.  */
  char **h_addr_list;		/* List of addresses from name server.  */
#ifdef __USE_MISC
# define	h_addr	h_addr_list[0] /* Address, for backward compatibility.*/
#endif
};
```

### protoent

```c

/* Description of data base entry for a single service.  */
struct protoent
{
  char *p_name;			/* Official protocol name.  */
  char **p_aliases;		/* Alias list.  */
  int p_proto;			/* Protocol number.  */
};
```

### getprotobyname

```c

extern struct protoent *getprotobyname (const char *__name);

/* Return entry from protocol data base which number is PROTO.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
```

### setsockopt

位于<sys/socket.h>

```c

/* Set socket FD's option OPTNAME at protocol level LEVEL
   to *OPTVAL (which is OPTLEN bytes long).
   Returns 0 on success, -1 for errors.  */
extern int setsockopt (int __fd, int __level, int __optname,
		       const void *__optval, socklen_t __optlen) __THROW;
```


### struct sockaddr_in

这个结构体定义在/usr/include/netinet/in.h

```c

/* Structure describing an Internet socket address.  */
struct sockaddr_in
  {
    __SOCKADDR_COMMON (sin_);
    in_port_t sin_port;			/* Port number.  */
    struct in_addr sin_addr;		/* Internet address.  */

    /* Pad to size of `struct sockaddr'.  */
    unsigned char sin_zero[sizeof (struct sockaddr) -
			   __SOCKADDR_COMMON_SIZE -
			   sizeof (in_port_t) -
			   sizeof (struct in_addr)];
  };

#if !__USE_KERNEL_IPV6_DEFS
/* Ditto, for IPv6.  */
struct sockaddr_in6
  {
    __SOCKADDR_COMMON (sin6_);
    in_port_t sin6_port;	/* Transport layer port # */
    uint32_t sin6_flowinfo;	/* IPv6 flow information */
    struct in6_addr sin6_addr;	/* IPv6 address */
    uint32_t sin6_scope_id;	/* IPv6 scope-id */
  };
#endif /* !__USE_KERNEL_IPV6_DEFS */
```

### bzero

这个函数也很常见，你猜它在哪里？--><strings.h>

### inet_addr

这个文件位于/usr/include/arpa/inet.h

```c

/* Convert Internet host address from numbers-and-dots notation in CP
   into binary data in network byte order.  */
extern in_addr_t inet_addr (const char *__cp) __THROW;
```

它的返回值是

```c

/* Address to accept any incoming messages.  */
#define	INADDR_ANY		((in_addr_t) 0x00000000)
/* Address to send to all hosts.  */
#define	INADDR_BROADCAST	((in_addr_t) 0xffffffff)
/* Address indicating an error return.  */
#define	INADDR_NONE		((in_addr_t) 0xffffffff)

/* Network number for local host loopback.  */
#define	IN_LOOPBACKNET		127
/* Address to loopback in software to local host.  */
#ifndef INADDR_LOOPBACK
# define INADDR_LOOPBACK	((in_addr_t) 0x7f000001) /* Inet 127.0.0.1.  */
#endif

/* Defines for Multicast INADDR.  */
#define INADDR_UNSPEC_GROUP	((in_addr_t) 0xe0000000) /* 224.0.0.0 */
#define INADDR_ALLHOSTS_GROUP	((in_addr_t) 0xe0000001) /* 224.0.0.1 */
#define INADDR_ALLRTRS_GROUP    ((in_addr_t) 0xe0000002) /* 224.0.0.2 */
#define INADDR_MAX_LOCAL_GROUP  ((in_addr_t) 0xe00000ff) /* 224.0.0.255 */

```
### gethostbyname

这个文件位于 /usr/include/netdb.h
```c

/* Return entry from host data base for host with NAME.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct hostent *gethostbyname (const char *__name);
```

### inet_ntoa

这个文件位于 /usr/include/arpa/inet.h

```c

/* Convert Internet number in IN to ASCII representation.  The return value
   is a pointer to an internal array containing the string.  */
extern char *inet_ntoa (struct in_addr __in) __THROW;
```

### struct icmp

这个结构位于 /usr/include/netinet/ip_icmp.h

```c

/*
 * Internal of an ICMP Router Advertisement
 */
struct icmp_ra_addr
{
  u_int32_t ira_addr;
  u_int32_t ira_preference;
};

struct icmp
{
  u_int8_t  icmp_type;	/* type of message, see below */
  u_int8_t  icmp_code;	/* type sub code */
  u_int16_t icmp_cksum;	/* ones complement checksum of struct */
  union
  {
    u_char ih_pptr;		/* ICMP_PARAMPROB */
    struct in_addr ih_gwaddr;	/* gateway address */
    struct ih_idseq		/* echo datagram */
    {
      u_int16_t icd_id;
      u_int16_t icd_seq;
    } ih_idseq;
    u_int32_t ih_void;

    /* ICMP_UNREACH_NEEDFRAG -- Path MTU Discovery (RFC1191) */
    struct ih_pmtu
    {
      u_int16_t ipm_void;
      u_int16_t ipm_nextmtu;
    } ih_pmtu;

    struct ih_rtradv
    {
      u_int8_t irt_num_addrs;
      u_int8_t irt_wpa;
      u_int16_t irt_lifetime;
    } ih_rtradv;
  } icmp_hun;
#define	icmp_pptr	icmp_hun.ih_pptr
#define	icmp_gwaddr	icmp_hun.ih_gwaddr
#define	icmp_id		icmp_hun.ih_idseq.icd_id
#define	icmp_seq	icmp_hun.ih_idseq.icd_seq
#define	icmp_void	icmp_hun.ih_void
#define	icmp_pmvoid	icmp_hun.ih_pmtu.ipm_void
#define	icmp_nextmtu	icmp_hun.ih_pmtu.ipm_nextmtu
#define	icmp_num_addrs	icmp_hun.ih_rtradv.irt_num_addrs
#define	icmp_wpa	icmp_hun.ih_rtradv.irt_wpa
#define	icmp_lifetime	icmp_hun.ih_rtradv.irt_lifetime
  union
  {
    struct
    {
      u_int32_t its_otime;
      u_int32_t its_rtime;
      u_int32_t its_ttime;
    } id_ts;
    struct
    {
      struct ip idi_ip;
      /* options and then 64 bits of data */
    } id_ip;
    struct icmp_ra_addr id_radv;
    u_int32_t   id_mask;
    u_int8_t    id_data[1];
  } icmp_dun;
#define	icmp_otime	icmp_dun.id_ts.its_otime
#define	icmp_rtime	icmp_dun.id_ts.its_rtime
#define	icmp_ttime	icmp_dun.id_ts.its_ttime
#define	icmp_ip		icmp_dun.id_ip.idi_ip
#define	icmp_radv	icmp_dun.id_radv
#define	icmp_mask	icmp_dun.id_mask
#define	icmp_data	icmp_dun.id_data
};

/*
 * Lower bounds on packet lengths for various types.
 * For the error advice packets must first insure that the
 * packet is large enough to contain the returned ip header.
 * Only then can we do the check to see if 64 bits of packet
 * data have been returned, since we need to check the returned
 * ip header length.
 */
#define	ICMP_MINLEN	8				/* abs minimum */
#define	ICMP_TSLEN	(8 + 3 * sizeof (n_time))	/* timestamp */
#define	ICMP_MASKLEN	12				/* address mask */
#define	ICMP_ADVLENMIN	(8 + sizeof (struct ip) + 8)	/* min */
#ifndef _IP_VHL
#define	ICMP_ADVLEN(p)	(8 + ((p)->icmp_ip.ip_hl << 2) + 8)
	/* N.B.: must separately check that ip_hl >= 5 */
#else
#define	ICMP_ADVLEN(p)	(8 + (IP_VHL_HL((p)->icmp_ip.ip_vhl) << 2) + 8)
	/* N.B.: must separately check that header length >= 5 */
#endif
```

### sendto

位于/sys/socket.h

```c

/* Send N bytes of BUF on socket FD to peer at address ADDR (which is
   ADDR_LEN bytes long).  Returns the number sent, or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t sendto (int __fd, const void *__buf, size_t __n,
		       int __flags, __CONST_SOCKADDR_ARG __addr,
		       socklen_t __addr_len);
```

### recvfrom

该结构体位于 /sys/socket.h

```c

/* Read N bytes into BUF through socket FD.
   If ADDR is not NULL, fill in *ADDR_LEN bytes of it with tha address of
   the sender, and store the actual size of the address in *ADDR_LEN.
   Returns the number of bytes read or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t recvfrom (int __fd, void *__restrict __buf, size_t __n,
			 int __flags, __SOCKADDR_ARG __addr,
			 socklen_t *__restrict __addr_len);


```

### ip

这是一个重要的结构体，可以说，这里面的东西都是围绕着这个结构行动，位于
/usr/include/netinet/ip.h

```c

/*
 * Structure of an internet header, naked of options.
 */
struct ip
  {
#if __BYTE_ORDER == __LITTLE_ENDIAN
    unsigned int ip_hl:4;		/* header length */
    unsigned int ip_v:4;		/* version */
#endif
#if __BYTE_ORDER == __BIG_ENDIAN
    unsigned int ip_v:4;		/* version */
    unsigned int ip_hl:4;		/* header length */
#endif
    u_int8_t ip_tos;			/* type of service */
    u_short ip_len;			/* total length */
    u_short ip_id;			/* identification */
    u_short ip_off;			/* fragment offset field */
#define	IP_RF 0x8000			/* reserved fragment flag */
#define	IP_DF 0x4000			/* dont fragment flag */
#define	IP_MF 0x2000			/* more fragments flag */
#define	IP_OFFMASK 0x1fff		/* mask for fragmenting bits */
    u_int8_t ip_ttl;			/* time to live */
    u_int8_t ip_p;			/* protocol */
    u_short ip_sum;			/* checksum */
    struct in_addr ip_src, ip_dst;	/* source and dest address */
  };


```

### gettimeofday

这个结构体位于 <sys/time.h>

```c

/* Get the current time of day and timezone information,
   putting it into *TV and *TZ.  If TZ is NULL, *TZ is not filled.
   Returns 0 on success, -1 on errors.
   NOTE: This form of timezone information is obsolete.
   Use the functions and variables declared in <time.h> instead.  */
extern int gettimeofday (struct timeval *__restrict __tv,
	__timezone_ptr_t __tz) __THROW __nonnull ((1));

/*其中timeval结构体如下：*/
struct timeval{
			long tv_sec;
			long tv_usec;
		}
```
