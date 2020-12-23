---
title: 回溯法简单入门
category: algorithm
layout: post
---
* content
{:toc}

# 说在前面

其实回溯法的套路是非常固定的，是一种决策树的表现形式。

形式:
```c
result = {};
void backtrack(路径， 选择列表){
    if (满足条件)
        result.add(路径);
        return;

    for (if 路径 in  选择列表){
        做选择
        backtrack(路径，选择列表);
        撤销选择
    }
}
```

以 LeetCode # 113 Path Sum II为例，题目给你一个sum，要求保存从root到leaf的累加和等于该sum的路径:
```c
[
   [5,4,11,2],
   [5,8,4,5]
]
```

看下下面这段优秀的代码:

```c
class Solution {
public:
  
    vector<vector<int>> pathSum(TreeNode* root, int sum) {
        vector<vector<int>> res;
        vector<int> path;
        findPaths(res, path, root, sum);
        return res;
    }
private:
    void findPaths(vector<vector<int>> &paths, vector<int> &path, TreeNode *cur, int sum){
        if(!cur) return ;
        path.push_back(cur->val); // 这就是细节
        if(!(cur->left) && !(cur->right) && (cur->val == sum))
            paths.push_back(path);  // 满足条件，
        if(cur->left) findPaths(paths, path, cur->left, sum - cur->val);
        if (cur->right) findPaths(paths, path, cur->right, sum - cur->val); // 选择列表
        path.pop_back(); // 撤销不满足的节点值
    }
};
```

有了最基本的框架，剩下的就是一些细节了，需要编程经验的积累。
照着葫芦画瓢，下面是全排列的代码:

```c
class Solution {
public:
    vector<vector<int>> permute(vector<int>& nums) {
        vector<vector<int>> res;
        vector<int> track;
        permutations(res, nums, track);
        return res;
    }
private:
    void permutations(vector<vector<int>>& res, vector<int>& nums, vector<int>& track){
        if (track.size() == nums.size()){
            res.push_back(track);
            return;
        }
        for (int i = 0; i < nums.size(); i++){
            if (std::find(track.begin(), track.end(), nums[i])!=track.end()) { 
                continue; // 在vector中判断是否存在一个元素
            }
            track.push_back(nums[i]);
            permutations(res, nums, track);
            track.pop_back();
        }      
    }
};
```