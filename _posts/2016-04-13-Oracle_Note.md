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

### 新建一个用户

## 忘记密码处理

```sql
sqlplus / as sysdba;
alter user username identified by passwd;
```
### 创建新用户

```sql
create user username identified by default tablespace xx
```
这里的表空间有以下几种：
 SYSTEM，SYSAUX USERS UNDOTBS1 EXAMPLE TEMP

系统中必须的表空间有那几个？

答案： SYSTEM、SYSAUX、TEMP、UNDO， 像USERS、EXAMPLE等表空间是可有可无的。

### 为用户赋予权限

```sql
grant connect,resource,dba to username;
```
