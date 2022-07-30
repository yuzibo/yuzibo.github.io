---
title: gcc-12 ftbfs
category: riscv
layout: post
---
* content
{:toc}

目前来看，bookworm应该默认使用gcc-12了，不过，从目前的QA质量来看，有不少C++包在rebuild时失败了。这篇文章就是简单的记录这个ftbfs summary. 其实做了这么多我发现，任何东西都不能浮于表面，也就是fix 一个issue,需要深挖背后的原理。当然，我现在的时间、资历还达不到那个级别，所以这个page就是当做笔记用的。

GCC 11 defaults to the GNU++17 standard.

指引性的文章[here](https://gcc.gnu.org/gcc-11/porting_to.html)

其实大部分的ftbfs集中在这一块。

# ftbfs

## dbus-c++
http://qa-logs.debian.net/2022/06/09/gcc12/dbus-c++_0.9.0-9_unstable_gcc12.log

```bash
/usr/include/c++/12/iomanip:170:5: note:   template argument deduction/substitution failed:
../../include/dbus-c++/types.h:96:8: note:   ‘DBus::MessageIter’ is not derived from ‘std::basic_istream<_CharT, _Traits>’
   96 |     ri >> cast;
      |     ~~~^~~~~~~
/usr/include/c++/12/iomanip:200:5: note: candidate: ‘template<class _CharT, class _Traits> std::basic_istream<_CharT, _Traits>&
+std::operator>>(basic_istream<_CharT, _Traits>&, _Setprecision)’
  200 |     operator>>(basic_istream<_CharT, _Traits>& __is, _Setprecision __f)
      |     ^~~~~~~~
/usr/include/c++/12/iomanip:200:5: note:   template argument deduction/substitution failed:
../../include/dbus-c++/types.h:96:8: note:   ‘DBus::MessageIter’ is not derived from ‘std::basic_istream<_CharT, _Traits>’
   96 |     ri >> cast;
      |     ~~~^~~~~~~
/usr/include/c++/12/iomanip:230:5: note: candidate: ‘template<class _CharT, class _Traits> std::basic_istream<_CharT, _Traits>&
+std::operator>>(basic_istream<_CharT, _Traits>&, _Setw)’
  230 |     operator>>(basic_istream<_CharT, _Traits>& __is, _Setw __f)
      |     ^~~~~~~~
/usr/include/c++/12/iomanip:230:5: note:   template argument deduction/substitution failed:
../../include/dbus-c++/types.h:96:8: note:   ‘DBus::MessageIter’ is not derived from ‘std::basic_istream<_CharT, _Traits>’
   96 |     ri >> cast;
      |     ~~~^~~~~~~
/usr/include/c++/12/iomanip:264:5: note: candidate: ‘template<class _CharT, class _Traits, class _MoneyT> std::basic_istream<_CharT,
+_Traits>& std::operator>>(basic_istream<_CharT, _Traits>&, _Get_money<_MoneyT>)’
  264 |     operator>>(basic_istream<_CharT, _Traits>& __is, _Get_money<_MoneyT> __f)

```

Solutions: todo

