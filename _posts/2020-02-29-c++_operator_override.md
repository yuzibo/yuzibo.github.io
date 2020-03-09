---
title: c++ operator override
category: c++
layout: post
---
* content
{:toc}

```c
std::ostream& operator << (std::ostream& out,  Box& B){
    out << B.getLength() << " " << B.getBreadth() << " " << B.getHeight();
    return out;
}
```
this is "<<" overload.  Note it will be defined at beside of class.

```c
bool operator < (const Box& B){ // overload operator "<"
       if (this->l < B.l)
           return true;
       else if (this->l == B.l && this->b < B.b)
           return true;
       else if (this->l == B.l && this->b == B.b && this->h < B.h)
           return true;
       else
           return false;
};
```
This is `<`'s override,which is defined in class,Why it is different from
above example.Yes, the reason that is we can use keyword `this` pointer to
access private numbers of class.
