---
title: c++ unorder_map使用
category: c/c++
layout: post
---
* content
{:toc}

目前的c++还是熟悉数据结构的阶段，所以总结记录下。

作为工具就是，该容器的效率为O(1).常用方法有:

1. 赋值 [], =
2. empty and size
3. begin and end for iterator
4. find and count
5. insert and modification

```c
#include <unordered_map>
#include <iostream>
#include <vector>
using namespace std;

int main() {

        unordered_map<string, vector<int>> keys;
        keys["a"] = vector<int>(); // Initialize key with all null vector
        keys["a"].push_back(1);
        keys["a"].push_back(2);

        for (const int &x : keys["a"]){
                cout << x << endl;

        }

        /* Above code is store a int array with string */

        /* insert value by [] oper */
        unordered_map<string, double> umap;
        umap["PI"] = 3.14;
        umap["root2"] = 1.414;
        umap["user1"] = 2.302;

        /* insert value by insert function */
        umap.insert(make_pair("e", 2.78));
        string key = "PI";

        if (umap.find(key) == umap.end())
                cout << key << "not found\n\n";
        else
                cout << "found " << key << "\n";

        key = "lambda";
        if (umap.find(key) == umap.end())
                cout << key << "not found" << "\n";
        else
                cout << "found " << "\n";

        /* iterator elements with iter */
        unordered_map<string, double>::iterator iter;
        for (iter = umap.begin(); iter !=umap.end(); iter++){
                cout << iter->first << " " << iter->second << endl;
        }

}

```

