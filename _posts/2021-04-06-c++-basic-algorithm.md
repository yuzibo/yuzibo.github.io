---
title: c++之基础算法
category: c/c++
layout: post
---
* content
{:toc}


何谓c++的基础算法？ 就是那些基本的算法，比如  reverse, is_sorted, is_unique等。这些usage在一些场景下使用的比较多。

# std::is_sorted
std::is_sorted 用来判断一个容器是否为一个已排序的容器，比如[1,2.3]，然后有一个不满足就会return false;

```c
    vector<int> ans = [1,2,3];
    if(std::is_sorted(std::begin(res), std::end(res)))
        return true;
```
具体的实现可能为:
```c
template<class ForwardIt>
bool is_sorted(ForwardIt first, ForwardIt last)
{
    return std::is_sorted_until(first, last) == last;
}
```
这样的用法还是挺多的。

# is_unique

根据这篇[文章](https://www.zhihu.com/question/281081474),

```c
std::unique(begin(nums), end(nums)) != end(nums)
```
说实在的，这个用法还是搞蒙我了。

一个可能的实现就是:

```c
template<class ForwardIt>
ForwardIt unique(ForwardIt first, ForwardIt last)
{
    if (first == last)
        return last;

    ForwardIt result = first;
    while (++first != last) {
        if (!(*result == *first) && ++result != first) {
            *result = std::move(*first);
        }
    }
    return ++result;
}
```
