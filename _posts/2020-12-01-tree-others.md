---
title: leetcode binary tree other
category: leetcode
layout:  post
---
* content
{:toc}

这篇文章重点记录二叉树的一些不入流的题目，但是很有意思。

## 606 construct-string-from-binary-tree

题目的大意是给你一个二叉树，然后输出它的遍历字符串，就比如；

```c
Input: Binary tree: [1,2,3,4]
       1
     /   \
    2     3
   /
  4

Output: "1(2(4))(3)"

Explanation: Originallay it needs to be "1(2(4)())(3()())",
but you need to omit all the unnecessary empty parenthesis pairs.
And it will be "1(2(4))(3)".

Input: Binary tree: [1,2,3,null,4]
       1
     /   \
    2     3
     \
      4

Output: "1(2()(4))(3)"
Explanation: Almost the same as the first example,
except we can't omit the first parenthesis pair to break the one-to-one mapping relationship between the input and the output.
```

这个题目有意思在，有一点 tip 在里面，也就是需要在你写程序之前进行一些观察。看着那些括号和数字是一些杂乱无章的符号，实际有固定套路的。

通过第二个例子，假设根节点有右子节点，而没有左子节点的话，需要在根节点后面添加一个"()",当然这个"()"你也可以看成一个空节点。此时，一般还是看不出的， 这时候，你把output的首位和末尾分别用"()"进行包裹起来，则这个结果就有规律了。

```c
class Solution {
public:
    string tree2str(TreeNode* t) {
        string res = "";
        if(!t) return res;
        tree2str_helper(t, res);
        return string(res.begin()+1, res.end()-1);

    }
private:
    void tree2str_helper(TreeNode* t, string& res){
        if (!t) return;
        res += "(";
        if (t) res += to_string(t->val);
        if(!t->left && t->right) res += "()";
        tree2str_helper(t->left, res);
        tree2str_helper(t->right, res);
        res +=")"; // 这个语句为什么放在这里，把我搞蒙了
    }
};
```
