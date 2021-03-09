---
title: leetocde--241. Different Ways to Add Parentheses
category: leetcode
layout: post
---
* content
{:toc}

这道题目大部分摘抄 https://zxi.mytechroad.com/blog/leetcode/leetcode-241-different-ways-to-add-parentheses/ d的题解。

Given a string of numbers and operators, return all possible results from computing all the different possible ways to group numbers and operators. The valid operators are +, - and *.

Example 1:
```c
Input: "2-1-1".

1
2
((2-1)-1) = 0
(2-(1-1)) = 2
Output: [0, 2]
```
Example 2:
```c
Input: "2*3-4*5"

1
2
3
4
5
(2*(3-(4*5))) = -34
((2*3)-(4*5)) = -14
((2*(3-4))*5) = -10
(2*((3-4)*5)) = -10
(((2*3)-4)*5) = 10
Output: [-34, -14, -10, -10, 10]
```

其实这道题目就是不停的参数，然后把目前所得的值存入一个存储中。

"2-1-1"为例： 
1. 首先分为"2", "1-1"两部分，然后减号"-"单独作为一部分。
2. 再就是可以分为"2-1"，“1”两部分，减号再作为一部分。

"2*3-4*5"为例:
同样例那样就是。

```c++
namespace vimer {  // 首次使用 namespace
    int add(int a, int b) { return a + b; }
    int minus(int a, int b) { return  a - b; }
    int multi(int a, int b) { return a * b; }
} // First time use namespace in c++

class Solution {
public:
    vector<int> diffWaysToCompute(string input) {
        return ways(input);
    }
private:
    const vector<int>& ways(const string& input){
        if(m_.count(input)) return m_[input]; // m_.find() is ok also but...
        
        // Array    for answer of input
        vector<int> ans;
        
        // Split every oper
        for(int i = 0; i < input.length();i++){
            char op = input[i];
            if (op == '+' || op == '-' || op == '*'){
                // Get left/right sub expression
                const string left = input.substr(0,i);
                const string right = input.substr(i+1);
                
                // Get value left and right sub-expression
                const vector<int>& l = ways(left);  // 计划递归
                const vector<int>& r = ways(right);
                
                std::function<int(int, int)> f;
                switch(op){
                    case '+': f = vimer::add; break;
                    case '-': f = vimer::minus; break;
                    case '*': f = vimer::multi; break; // 如此调用 回调函数
                }
                for (int a : l){
                    for(int b : r){
                        ans.push_back(f(a,b));
                    }
                }
            }
            
        }
        if(ans.empty())
            ans.push_back(std::stoi(input));
        m_[input].swap(ans);
        return m_[input];
    }
    
    unordered_map<string, vector<int>> m_;
};
```

c++的新知识:
 1. unordered_map中的find和count是等价的，但是呢， find 的用法更强调结果，比如发现一个值然后使用它；而count只是查找，查到后返回true就罢了。

 2.  swap就是交换两个map的键值对，就是暂时还没有发现为啥这么干。