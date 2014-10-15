---
layout: article
category: DS 
tags: [DS]
---
#暂时不熟悉的用法
##宏定义：

###define L(x) (x<<1)//将x乘以2
###define R(x) (x<<1|1)//将x乘以2加1，注意后面|1就是加1,其他的不一定正确

线段树的深度为log2(b-a+1)
线段数组基本知识：
1.通常我们用lowbit(x)表示x对应的2^k;
2.lowbit(x)=x&(-x);
3.lowbit(x)实际上就是x的二进制表示形式留下最右边的1，其他位都变成0
数组a对应的线段数组应该是C[i]=a[i-lowbit(i)+1]+...+a[i]
#hdu 1166我居然挂了20多次
[hdu 1166](http://acm.hdu.edu.cn/showproblem.php?pid=1166)
虽然是一个人的战场，但你永远不会独行！you nerver go alone!
线段树的简单使用可以用以下模板，高级还需自己慢慢领会

1. 下面是基于线段树结构的代码

{% highlight c++ %}
/*

     File Name: hdu1166-4.cpp
     Author: damit
     Mail: yuzibode@126.com 
     Created Time: 2014年07月18日 星期五 19时55分04秒
     学习重点:

*/

#include<cstring>
#include<cstdio>
#include<iostream>
#define lson t<<1,l,m
#define rson t<<1|1,m+1,r
#define MID(x,y) (x+y)>>1
#define N 50010
using namespace std;
int st[N<<2];
void PushUp(int t)
{
	st[t]=st[t<<1]+st[t<<1|1];

}
void build(int t,int l,int r)
{
	if(l==r)
	{
		scanf("%d",&st[t]);
		return ;
	}
	int m=MID(l,r);
	build(lson);
	build(rson);
	PushUp(t);
}
void display(int t,int l,int r)
{
	if(l==r)
	{
		printf("%d->",st[t]);
		return ;
	}
	int m=MID(l,r);
	display(lson);
	display(rson);

}

//p is where of update,add is value,**
//i don't understand clearly
void update(int p,int add,int t,int l,int r)
{
	//找准一个条件即可，如此递归下去就成了
	if(l==r){
		st[t]+=add;
		return ;
	}
	int m=MID(l,r);
	if(p<=m)
		update(p,add,lson);
	else
		update(p,add,rson);
	PushUp(t);

}
//more argument more clearly,L and R is Query from to  
int getSum(int L,int R,int t,int l,int r)
{//区间在最左侧或最右侧/不理解,还有，每个结点的ret要清0，由分支再求和
	//求和的函数确实难以理解
	//For example,get sum(1,3),肯定要分支才行，下面用笔画画
	if(L<=l && r<=R)
	{

	return st[t];
	}
	int m=MID(l,r);
	int ret=0;
	if(L<=m)
		ret+=getSum(L,R,lson);
	if(R>m)
		ret+=getSum(L,R,rson);
	return ret; 

}
int main()
{
	freopen("in.txt","r",stdin);
	int k;
	int j,p,q,n;
	char str[6];
	scanf("%d",&k);
		for(int j=1;j<=k;j++){
			scanf("%d",&n);
				build(1,1,n);
			//	display(1,1,n);
			printf("Case %d:\n",j);
			while(scanf("%s",str)&&str[0]!='E'){
				scanf("%d%d",&p,&q);
				switch(str[0]){
					case 'Q':
						{
	//						printf("Query %d %d\n",p,q);
							printf("%d\n",getSum(p,q,1,1,n));			
						}
						break;
					case 'S':
						{
	//						printf("Sub %d %d\n",p,q);
							update(p,-q,1,1,n);
	//						display(1,1,n);
						}
						break;
					case 'A':
						{
	//						printf("Add %d %d \n",p,q);
							update(p,q,1,1,n);
	//						display(1,1,n);
						}
						break;
				}
			}
		}
	
	return 0;
}

{% endhighlight %}

这是树状数组的做法，参考了

[树状数组](http://blog.csdn.net/lulipeng_cpp/article/details/7816527);

{% highlight c++ %}

/*
     File Name: hdu1166array.cpp
     Author: damit
     Mail: yuzibode@126.com 
     Created Time: 2014年07月19日 星期六 06时27分29秒
     学习重点:
*/
//还要仔细推敲
#include<cstring>
#include<cstdio>
#include<iostream>
using namespace std;
int st[50005];
//2^k==lowbit(x)
int lowbit(int a)
{
	return a&(-a);
}
void update(int p,int val,int N)
{
	while(p<=N)
	{
		st[p]+=val;//主要是向后衍生使用的
		p+=lowbit(p);
	}

}
int getsum(int p)
{
	int res=0;
	while(p){
		res+=st[p];
		p-=lowbit(p);
	}
	return res;

}
void display(int n)
{
	for(int i=1;i<=n;i++)
		printf("%d ",st[i]);

}
int main()
{
	freopen("in.txt","r",stdin);
	int k,n,x;
	int p,q;
	char str[5];
	scanf("%d",&k);
	for(int j=1;j<=k;j++){
		memset(st,0,sizeof(st));
		printf("Case %d:\n",j);
		scanf("%d",&n);
		for(int i=1;i<=n;i++)
		{
			scanf("%d",&x);
			update(i,x,n);
		}

	//	display(n);
		while(scanf("%s",str)&&str[0]!='E'){
			scanf("%d%d",&p,&q);
			if(str[0]=='A'){

			//	printf("Add %d %d\n",p,q);
				update(p,q,n);

		//display(n);
			}
			if(str[0]=='S'){
		//		printf("Sub %d %d\n",p,q);
				update(p,-q,n);
		//display(n);
			}
			if(str[0]=='Q'){
		//		printf("Query %d %d\n",p,q);
				printf("%d\n",getsum(q)-getsum(p-1));
			}
		}



	}
}

{% endhighlight %}

{% highlight c++ %}
int lowbit(int a)
{
	return a&(-a);
}

{% endhighlight %}

一直不理解那个lowbit到底是干什么，上面的文章说可以向后衍生（更新结点）和向前（求和）
向后主要是为了找到目前节点的父节点，比如要将C[4]+1，那么4+(4&(-4))=8，C[8]+1，8+(8&(-8))=16，

C[16]+1。

向前主要是为了求前缀和，比如要求A[1]+...+A[12]。那么，C[12]=A[9]+...+A[12]；然后12-12&(-12)=8，

C[8]=A[1]+...+A[8]。
##hdu 1754
[hdu 1754](http://acm.hdu.edu.cn/showproblem.php?pid=1754)
奇了怪了，我的代码与下面的一模一样，我的错，他的对，到底哪里不一样啊
而且还有一件事情，就是在传递参数的时候，t<<1放在参数列表的最后一个位置比放置在其他
位置时间更快一些，为什么啊

{% highlight c++ %}
/*************************************************************************
     File Name: hdu1754-5.cpp
     Author: damit
     Mail: yuzibode@126.com 
     Created Time: 2014年07月20日 星期日 18时06分35秒
     学习重点:
 ************************************************************************/

#include<cstring>
#include<cstdio>
#include<iostream>
#include<algorithm>
using namespace std;
#define lson l,m,t<<1
#define rson m+1,r,t<<1|1
const int N=222222;
int st[N<<2];
void UpPush(int t){
	st[t]=max(st[t<<1],st[t<<1|1]);
}
void build(int l,int r,int t)
{
	if(l==r){
		scanf("%d",&st[t]);
		return ;
	}
	int m=(l+r)>>1;
	build(lson);
	build(rson);
	UpPush(t);
}
void Update(int p,int add,int l,int r,int t)
{
	if(l==r)
	{
		st[t]=add;
		return ;
	}
	int m=(l+r)>>1;
	if(p<=m)
		Update(p,add,lson);
	else 
		Update(p,add,rson);
	UpPush(t);
}
int Query(int L,int R,int l,int r,int t)
{
	if(L<=l&&R>=r){
		return st[t];
	}
	int m=(l+r)>>1;
	int ret=0;
	if(L<=m)
		ret=max(ret,Query(L,R,lson));
	if(R>m)
		ret=max(ret,Query(L,R,rson));
	return ret;

}
void display(int l,int r,int t)
{
	if(l==r)
	{
		printf("%d->",st[t]);
		return ;
	}
	int m=(l+r)>>1;
	display(lson);
	display(rson);

}
int main()
{
	freopen("1754.in","r",stdin);
	int n,m;
	while(scanf("%d%d",&n,&m)!=EOF){
		memset(st,0,sizeof(st));
		build(1,n,1);
	//	display(1,n,1);
		while(m--){
			int p,q;
			char str[2];
			scanf("%s%d%d",str,&p,&q);
			if(str[0]=='U'){
	//			printf("Update %d %d\n",p,q);
				Update(p,q,1,n,1);
	//			display(1,n,1);
			}
			else{
	//			printf("Query %d %d\n",p,q);
				printf("%d\n",Query(p,q,1,n,1));
			}
		}
	}
}



{% endhighlight %}

update()函数中p+=lowbit(p)是推算p在后面的有关的st的位置，至于为什么那真的就是数学证明了
[hdu 2795](http://acm.hdu.edu.cn/showproblem.php?pid=2795)

/*************************************************************************
     File Name: hdu2795.cpp
     Author: damit
     Mail: yuzibode@126.com 
     Created Time: 2014年07月21日 星期一 21时15分10秒
     学习重点:
	 原来线段树还可以这样用啊，自己真是长见识了，以后我也要尝试着去写些这类有价值的东西来，

少制造垃圾.
      题意：面板是h*w,而纸条为1*w，从左上角依次填充，若可以则输出最小的行数。利用线段树，右区间为min(n,h),
为什么呢，我们试想想，h*w，我们只需h层（最安全），
如3*5，我们

如果贴2张纸条	， 
则只需建一个【1，2】的线段树，够使用的就可以的。然后每个节点被赋值w（宽度），build(l,r,t)先赋值，判断退		出，然后左右子树分别建立。
	 查询时，将每个宽度的值传递过来，到叶子节点时去掉宽度值，并返回l，即层数
	 然后更新父节点，取自左右子树的最大值，以便下次使用。
	 还有，一开始就判断MAX[1],为什么？
 ************************************************************************/


{% highlight c++ %}

#include<cstring>
#include<cstdio>
#include<iostream>
using namespace std;
#define lson l,m,t<<1
#define rson m+1,r,t<<1|1
const int N=222222;
int MAX[N<<2];
int n;//gloabl val
int h,w;
void UpPush(int t)
{
	MAX[t]=max(MAX[t<<1],MAX[t<<1|1]);

}
void build(int l,int r,int t)
{
		MAX[t]=w;
	if(l==r)
	{
		return ;
	}
	int m=(l+r)>>1;
	build(lson);
	build(rson);

}
//发现很多的使用都是在这里更改
//
int Query(int p,int l,int r,int t)
{
	if(l==r)
	{
		MAX[t]-=p;
		return l;
	}
	int m=(l+r)>>1;
	int ret=((MAX[t<<1] >= p) ? Query(p,lson) : Query(p,rson));
	UpPush(t);
	return ret;
	

}

void display(int l,int r,int t)
{
	if(l==r)
	{

	printf("%d->",MAX[t]);
	return ;
	}
	int m=(l+r)>>1;
	display(lson);
	display(rson);
}
int main()
{
	freopen("2795.in","r",stdin);
	//int h,w;
	int b;
	while(scanf("%d%d%d",&h,&w,&n)!=EOF)
	{
		if(h>n)
			h=n;
		build(1,h,1);
//		display(1,h,1);
//		printf("\n");
		while(n--){
			scanf("%d",&b);
			if(MAX[1]<b)
			printf("-1\n");
			else
			printf("%d\n",Query(b,1,h,1));
		}
	}
}
{% endhighlight %}
