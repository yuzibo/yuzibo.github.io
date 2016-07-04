---
layout: article
title: "linux基本命令"
category: shell
---
## 注，代码中的数字是注释

## bc

## 十进制转换成二进制

{% highlight bash %}
no=100
echo "obase=2;$no" | bc
## x()B==>()10
no=1100100
echo "obase=10;ibase=2;$no" | bc
## direct to
echo "sqrt(100)" | bc
echo "10^10" | bc
{% endhighlight %}

## cat

{% highlight bash %}
## remove blank cols
cat 1.txt | tr -s '\n'
## display tab
cat -T xx.txt
## lines numbers
cat -n filename
## cat > file1
向文件中写入内容
{% endhighlight %}
## comm


## comm must use sorted file as input
``` bash
sort A.txt -o A.txt ;
sort B.txt -o B.txt
comm A.txt B.txt
```

产生以下三列：
第一列是在A中，第二列是在B中，第三列是在A，B中的，加上参数
即可方便的格式化输出：
-1 ；删除第一列
-2；删除第二列
-3；删除第三列

```bash
comm A.txt B.txt -1 -2
comm A.txt B.txt -3 | sed 's/^\t//'
```

这个命令会产生1，2列，用sed命令删除空白字段，s是替换，^是行首，
利用这个命令产生差集

comm A.txt B.txt -1 -3

## cut

{% highlight bash %}

## 1. 在cut的术语中，每列都是一个字段
cut -f 2,3 filename
## 2.    打印除第三列之外所有的列，
cut -f3 --complement filename
##    要指定字段的定界符，使用-d选项
cut -f2 -d";" filename

{% endhighlight %}

## less--more

## mkdir

```bash
if [ -e /home/yubo ]; then
#mkdir
fi
```
## 创建多级目录

```bash
mkdir -p /home/yubo/xx
```

## chmod


u=用户权限
g=用户组权限
o=其他实体权限

如一个文件 rwx rw- r--增加其他组的可执行权限

```bash
chmod o+x filename
chmod a(all)+x filename
```

## 删除权限

```bash
chmod a-x filename
```

## r--=4,-w-=2,--x=1,依次类推


## chown


## 更改所有权

```bash
chown u
ser.group filename
```

>>chown [OPTION]... [OWNER][:[GROUP]] FILE...

>>chown [OPTION]... --reference=RFILE FILE...

## -R operate a file or direct recurence

```bash
chown -R redhat ./test
```

## 将test目录及其子目录中的文件的其他用户权限设置为没有任何权限

```bash
chown -R o=--- ./test
```

## cp


## -r copy directories recursively

```bash
cp -r /ect/pam.d ./test
```

# chattr


### 使文件不可修改

```bash
chattr +i file
```

### 删除这个属性

```bash
chattr -i file
```
# echo

### print color text

```bash
echo -e "[e1;42m This is color txet \e[0m"#其中数字不同颜色不同
```


# find


### find and print

```bash
find . -print   ## . stand for current directory,".." father
```

## -iname(ignore lower or upper leteer)

find /dir -iname "*.txt" -print


### find . \( -name "*.txt" -o -name "*.sh" \) -print
4.## path

```bash
find /home/xx -path "*xx*" -print
```

### regex
```bash
find . -regex ".*\(.sh\|\.c\)$"
```

### not args
```bash
find . ! -name "*.txt" -print
```

### maxdepth or mindepth
```bash
find . -maxdepth 2 -type f -print
```

### filetype
```bash
find . -type d/f/l -print
```

### time
```bash
find . -type f -a/m/cmin -/+num -print
```

### sizeoffile
```bash
find . -type f -size (+/-/)num(b/c/w/k/M/G)
```

### del
```bash
find . -type f -name "*.swp*" -delete
```

### perm
```bash
find . -type f -name "*.php" ! -perm 644 -print
```

### exec???
```bash
find . -type f -name "*.txt" -exec chown yubo {} \
```

### jump special dir????

## whereis------locate

同样可以实现
script and scirptreplay----

## commandS
script -t 2> xx.log -a xx.session
...
exit

## replay
scriptreplay xx.log xx.session


## tr


### '\0' is replaced by '\n'
```bash
cat /proc/$PID/environ | tr '\0' '\n'
```

### format form output

### upper is to lower
```bash
echo "HELLO" | tr 'A-Z' 'a-z'
```

### miwen
```bash
echo 12345 | tr '0-9' '9876543210'
```

==>87654
echo 87654 | tr '9876543210' '0-9'

### del special

echo "hello 123 world 456" | tr -d '0-9'


## 宣告变量----$PATH and $VAR

```bash 
1.##add path:
export PATH="$PATH:/home/user/bin"
2,##obtain length of var:
length=${#var}
3.##shell version
echo $0
4.##root UID
echo $UID(0 is root)
```

## declare----typeset

```bash
1.## declare [-aixr] variable
Options:
-a: 将后面的variable定义为数组(array)类型
-i: 将后面的variable定义为整型(integer)类型
-x: 用法与export一样，就是将后面的variable定义为环境变量
-r: 将变量设定为readonly类型，不能更改也不能unset.
```


## md5sum

```bash
1.##???
md5sum filename
```

## date

```bash
1.## display second
date +%s
2##conver/?? time for s from exterm
1.date --date "Thu Nov 18 hh:mm:ss HKT 2010"
+%s
3.## output day for weeks
...+%A
4.## details for man date
5.## wanted form
date "+%d %B %Y"
```

## file

```bash
1.##打印文件类型（print file type）
file /etc/passwd
2.##(print file type and not include filename)
file -b /etc/passwd
```

## eject


干出cd托盘

>eject


## diff&patch

```bash
1.## all output
diff -u 1.txt 2.txt > version.patch
patch -p1 1.txt < version
## 此时 1.txt与2.txt一样了
## 若撤销patch
patch -p1 1.txt < version.patch
```

## tar

```bash 
1.    ## gzip [-cdtv] file,可以被WinRAR解压缩
gzip -v file  ##显示压缩比
zcat file ##可以将压缩的.gz内容读出来
gzip -d xx.gz ## 解压缩
2.## bzip2 [-cdkzv] file
bzip2 -z file
bzcat xx.bz2 ##将bz2的文件读出来
3.##以上两种分别对目录中文件进行压缩
tar [-j|-z] [cv] [-f 建立的档名] file <==打包与压缩
tar [-j|-z] [tv] [-f 建立的档名] <== 查看档名
tar [-j|-z] [xv] [-f 建立的档名] ［-C 目录］<==解压缩
-p:保留备份数据的原本权限与属性，常用备份重要文件
##最好不使用-P（保留根目录）
tar -zpcv -f /tmp/1.tar.gz /etc/pam.d   ##感觉tar对.gz,bz2的支持不够
tar -jcv -f /tmp/2.tar.bz2 /etc/pam.d
查看文件： -t
tar -jtv -f 2.tar.bz2
解压缩：
tar -jxv -f 2.tar.bz2
tar -jxv -f 2.tar.bz2 -C ./etc  ##指定目录
4.还可以使用grep
tar -jtv -f 2.tar.bz2 | grep 'name'
5.使用 --exclude!!!!!!
tar -jcv -f /../xx.bz2 --exclude=/root/etc* --exclude=/root/xx.bz2 /etc/ /root
```


## head && tail

```bash
1.## print ahead 10 lines
head file
cat text | head
head -n 4 file
2. ## print behand 10 lines
tail -n 5 file
```

## grep

```bash
#1. ^        ^tux
#2, $        tux$
#3. .        hack.(任意单个字符)
#4. []      [hk](只匹配h或者k)
#5. [^]        9[^01] (92,93,but is not 90 nor 91 )
#6. ?       colou?r(color or colour)(匹配之前的项0次或1次)
#7. +       （1次或多次）
#8. *      （0次或多次）
#9.  ()???
#10. {n}     匹配之前的项n次
#11. ｛n，}   --------至少n次
#12， ｛n，m｝［0-9］｛2，5｝匹配从两位数到五位数的任意一个数字
#13.   ｜      oct(1st | 2nd) 匹配Oct 1st 或者Oct 2nd
#14.   \      a\.b match a.b，但不能匹配ajb
#15.[:alnum:][:alpha:][:blank:]....
#16. \b      单词边界
#17. \B
#18. \<
#19. \>
[^fgh]不与fgh之中的任意一个字符匹配;

\w 匹配大小写英文字符及数字0到9之间的任意一个及下划线;

\W 不匹配大小写英文字符及数字0到9之间的任意一个;

\s 匹配任何空白字符；

\S 匹配任何非空白字符；

\d 匹配任何0到9之间的单个数字；

option: -n;打印出行号 -v:排除特定的行 -o:只输出匹配的字符


1. ## 不输出匹配的行
grep -v word file
2.## lines numbers
grep -c "text" file  ##匹配的数量
grep word -n file ##行号
3.## match word numbers
echo -e "1 2 3 4\nhello\n5 6" | egrep -o "[0-9]" | wc -l
4.##  递归搜索 developer use most
gerp "text" . -R -n
5.## ignore UPPer or lower
echo hello HELLO | grep -i "HELLO"
6.## many match
echo this is a line of test | grep -e "this" -e "line" -o
7.## match URL or EMAIL
egrep -o '[A-Za-z0-9.]+@[A-Za-z0-9.]+\.[a-zA-Z]{2,4}'   //email
// .匹配任意一个字符，+匹配一个或多个[A-Za-z0-9.],so  "[A-Za-z0-9.]+"
//匹配字母与数字的混合搭配
URL:
egrep -o "http://[a-zA-Z0-9.]+\.[a-zA-Z]{2,3}"
8.## 按要求打印匹配的行
grep -A  3 "word" 1.txt (打印当前行及后三行)
grep -B 3 "word" file (打印当前行及后三行)
grep -C 2 "word" file(打印前2行和后2行)
9.## grep那么该如何定位呢
```


## pushd && popd

```bash
1.## ingore cd
pushd /var/www
pushd /usr/src
dirs
## form 0 to n-1,若切换到目的目录中可以这样
pushd +1
2.## popd 同样的内容但是推出，原理同上
3.## 若只在两个目录间切换，可以尝试  cd -
```

## print dir

```bash
1.## print dir
ls -d */
ls -F | grep "/s" ##
ls -l | grep "^d"
```

## cp

```bash 
1.##  连同子目录一起复制
cp -r source_file destion_file
```

## du-----df


>du显示当前目录所占的磁盘空间    df目前磁盘的所剩空间


## sort--uniq

```bash
1.## sort
sort 1.txt 2.txt >/-o sorted.txt
2.## sort by num
sort -n 1.txt
3.## nixu
sort -r 1.txt
4.## months
sort -M months.txt
5.## test
sort -C file
if [ $? -eq 0 ]
then
echo sorted
else
echo Unsorted
fi
6.## -nr表示按照数字，采用逆序 ,如果按照数字排序，必须给出-n选项
sort -nrk 1 data.txt
7.## 依据第二列排序
sort -k 2 data.txt
8.## 消除单一行
sort unsorted.txt | uniq
9.## 统计次数
sort unsorted.txt | uniq -c
```

## stdin==0--stdout==1---stderr==2

```bash
1.##> and >>
2,##< and <<
3.ls + 2> out.txt
4.##/dev/null the data that The file revice will discard
5.##use model for exec
exec 3<file
cat <&3##display content text
##each time use one time
6.##M>&N: redirect the output of channel M to channel N
grep foo nofile 2>&1 ## errors will appear on STDOUT
7.## STDOUT
echo `date' whoami' >> 1.txt
echo $(date) $(whoami) >> 1.txt
8.##详解exec用法
##不要畏难，其实这一块还是蛮简单的，首先，自己定义一个文件描述符，最好不要用0，1，2当然，你执意使用，没人拦你，exec 4<out.txt,就定义一个从文件读的符号，使用时，如cat <&4,看好格式，有一点需要弄明白，从文件读的时候，我们不需要用追加模式，而向文件写的时候，我们的必须分清截断模式（>）和追加模式(>>),在定义(>>)的时候，是这样子的
举个例子：
exec 4>out.txt
echo newline >&4  ##这样就将newline写入了out.txt, 我们 cat out.txt,会显示   newline, 而使用追加模式
exec 4>>out.txt
echo append line >&4  ##!!!,这样就将新内容写入了out.txt,  cat 一下
newline
append line
##  ok!

```

### termial-tput and stty

```bash
1.##cols and lines
tput cols;lines
2.##set backgroundcolor
tput set no(0~no~7)
3.##text bold
tput bold
4.##del all to end
tput ed
```

###function()

```bash
1.##methon
fname(){
echo $1,$2;
echo "$@";
echo "$*";
return 0;
}
fname 1 2 3 4
```
#### export

export -f fname ##subprocess can use fanme


## read-重点是对于变量起作用

```bash
1.##read and can''t use Enter(no-echoed)
read -n 2 var
2.## display
read -p "enter input" var
3.## timeout
read -t 2 var
4.##define symbol
read -d ":" var
```

## paste

```bash
1.## 按列合并文本,中间以：为定界符
paste 1.txt 2.txt -d ":"

```

## ulimit

```bash
1.## 文件系统及程序的限制关系
ulimit [-SHacdfltu] [配额]
-H :hard limit,不能超过这个设定的数值
-S :soft limit,超过发出警告
-a :all ，后面不接任何选项，列出所有的限制额度
---


## sed

```bash
1.## replace
sed 's/pattern/replace_string' file <==>
cat 1.txt | sed 's/pattern/replace_string'
2.## 使用-i选项，可以使结果作用于原文件，修改原来的值
sed -i 's/pattern/replace_string/g' file
3.## 以上法则，只会将每行的第一个符合要求的字替换掉，若要全部替换,加上/g
sed 's/pattern/replace_string/g' file
4.## 从符合要求的第N处开始
echo this thisthisthis | sed 's/this/THIS/2g'
5.## 可以使用多种定界符
sed 's:text:replace:g'
sed 's|text|replace|g'==>sed 's|te\|xt|replace|g'==>脱义
6.## remove blank lines==>  /pattern/d会删除匹配样式的行
sed '/^$/d' file
7.## 用＆标记匹配样式的字符串
echo this is an example | sed 's/\w\+/[&]/g'  ==>\w\+匹配每一个单词,&？
8.## 字串匹配标记\1
echo this is digit 7 in number | sed 's/digit \([0-9]\)/\1/'==>
\(pattern\)用yu匹配子串，对于匹配到的第一个子串，其对应的标记是\1,依次类    推
echo seven EIGHT | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'==>print EIGHT                       seven
([a-z]\+\)匹配第一个单词，([A-Z]\+\)匹配第二个单词
9.## reference
text=hello
echo hello world | sed "s/$text/HELLO/"
10.## 匹配三位数字
cat 1.txt | sed 's/\b[0-9]\{3\}\b/number/g'
11.## sed [-e] 'instruction' file  ## -e:输入多条命令必需品
```

## awk

```bash
1.## construct,这三部分都是可选的
awk ' BEGIN{ print "start" } pattern { command } end{ print "end" }'
file
2.## principle :begin语句从输入流读取行之前被执行，end语句同begin语句相似，只是在之后执行，最重要的pattern语句，就像while循环样，不断读取行，执行｛｝中的语句
3.## example print的参数是以逗号进行分割的，参数打印时以空格作为定界符
双引号是被当作拼接操作符使用的
echo -e "line1\nline2" | awk 'BEGIN{ print "start" } { print } end{ print "end" } '
echo | awk '{ var1="v1";var2="v2";var3="v3"; print var1,var2,var3 ; }'
print v1 v2 v3

4.## NR(number of records)==行号；（NF）（字段数量）；$0(current row's content) ;$1(第一个字段的文本内容)；$2(第二个字段的文本内容)
echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk '{
print "Line no "NR",no of field:"NF,"$0="$0,"$1="$1,"$2="$2,"$3="$3 }'
5.## 打印每一行的第2和第3个字段
awk '{ print $3,$2 }' file
6.## 将外部变量值传给awk -v
VAR=10000
echo | awk -v var=$VAR '{ print var }'
7.## 当输入来自文件时
awk  '{ print v1,v2 }' v1=$var1 v2=$var2 filename
8.## 用样式对awk处理的行进行过滤
awk 'NR < 5'
awk 'NR==1,NR==4' 打印文本1-4行的所有内容
awk '/linux/' 包含样式linux的行
awk '1/linux/' 不包含linux行
9.## 用getline读取行
10.##  设置字段定界符
awk -F: '{ print $NF }' /etc/passwd <==> awk 'BEGIN { FS=':'} { print $N    F}' 1.txt  ##这里的:可以使用" "弄起来
11. ## 模拟head
awk ‘NR <= 10' file
12. ## 模拟tail命令打印文件的后10行,buffer[] should be build-in array in awk
awk '{ buffer[NR%10] = $0;} END { for(i=1;i<11;i++) { print buffer[i%10]    } }' file
13.## 模拟tac逆序输出
awk '{ buffer[NR] = $0;} END { for(i=NR;i>0;i--) { print buffer[i] } }'
file
14.## 以，为分界符
awk -F, '/pattern/ { print $1 }' file
15.## -f 脚本文件；-v var=value follows
```


## tac


```bash
1.## 逆序输出,同时可以使用-s 分割符选项指定分割符
seq 5 | tac

## IFS

## Internal Field Separator IFS


## who---w-----ku


1.##这三个指令差不多，只不过ku是检查整个网络上的用户


## wc

```bash
1.## count lines
wc -l file
2.## count words
wc -w file
3.## char numbers
echo -n 1234 | wc -c
4. ## print longest length
wc file -L
```

## xargs

```bash
1.## special form output
cat 1.txt | xargs
2.## same
cat 1.txt | xargs -n 3
3.## IFS
echo "hghjkh:hgfjh:hf" | xargs -d :
or
echo "jhhgjg:hjfh:bv" | xargs -d : -n 2
```
## 12

```bash
1.##根据扩展名且分文件名 %：提取文件名
file_jpg="sample.jpg"
name=${file_jpg%.*}
echo file name is: $name
##其中，%是最长提取符%%是最短提取符，匹配规则是从右向左
2，##提取扩展名：#，匹配规则是从左向右的。
exten=${file_jpg#*.}
```


