---
title: c++之ios的数字格式用法
category: c++
layout: post
---
* content
{:toc}

# header file

最重要的头文件就是<iomanip>, 下面的函数不在这里面的会特别指正出来的。 

# std::setiosflags

这个函数在我看来就是可以用在改变io流的进制基数的，比如指定10进制或者16进制，可以看下下面的一个例子:

```c
int main() {
	std::cout << std::hex;
	std::cout << std::setiosflags(std::ios::showbase | std::ios::uppercase);
	std::cout << 100 << std::endl;
}
```
如果不指定std::hex和set::setiosflags的话，肯定输出的是100，但是实际的结果是 0X64(如何0x64?)

# setw
指定显示的字符宽度。
```c
int main() {
	cout << setw(4) << 123 << endl;
	cout << "====" << endl;
}
// output:
//  123
// ====
```

# std::fixed && std::setprecision

# std::scientific

# std::modf

# links

[std::letf](https://en.cppreference.com/w/cpp/io/manip/left)

[小数点精度](https://stackoverflow.com/questions/5907031/printing-the-correct-number-of-decimal-points-with-cout)

[]
# English 
A scale of 2 decimal place. (小数点后两位)