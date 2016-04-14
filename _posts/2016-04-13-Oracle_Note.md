---
title: "oracle基本操作" 
layout: article
category: oracle
---

# 简单的基本操作

### 读取一个表的字段名称

select   column_name   from   user_tab_columns   where   table_name='table1'
;

我的实验数据是

```sql
select column_name from user_tab_columns;

COLUMN_NAME
------------------------------
STUDENT_NO
STUDENT_NAME
TEL
USERID
USERNAME
```

我现在只能直接取，因为现在只有一个表，where还不能使用，这里有一个大坑，注意
点。
