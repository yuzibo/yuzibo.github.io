---
title: "oracle基本操作" 
layout: post
category: oracle
---

# 简单的基本操作

### 查看所有用户：

```bash
select * from dba_users;   
select * from all_users;   
select * from user_users;
```

### 查看用户或角色系统权限(直接赋值给用户或角色的系统权限)：

```bash
select * from dba_sys_privs;   
select * from user_sys_privs; (查看当前用户所拥有的权限)
```

### 查看角色(只能查看登陆用户拥有的角色)所包含的权限

```c
sql>select * from role_sys_privs;
```

### 查看用户对象权限：

```bash
select * from dba_tab_privs;   
select * from all_tab_privs;   
select * from user_tab_privs;
```

### 查看所有角色：

>select * from dba_roles;

### 查看用户或角色所拥有的角色：

```c
select * from dba_role_privs;   
select * from user_role_privs;
```

### 查看哪些用户有sysdba或sysoper系统权限(查询时需要相应权限)

>select * from V$PWFILE_USERS

### SqlPlus中查看一个用户所拥有权限
 
>SQL>select * from dba_sys_privs where grantee='username';

其中的username即用户名要大写才行。
比如：
SQL>select * from dba_sys_privs where grantee='TOM';

### Oracle删除指定用户所有表的方法

```c
select 'Drop table '||table_name||';' from all_tables
where owner='要删除的用户名(注意要大写)';
```

### 删除用户

>drop user user_name cascade;

如：drop user SMCHANNEL CASCADE

### 获取当前用户下所有的表：

>select table_name from user_tables;

### 删除某用户下所有的表数据: 

>select 'truncate table  ' || table_name from user_tables;

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

#### 忘记密码处理

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

### 系统中必须的表空间有那几个？

答案： SYSTEM、SYSAUX、TEMP、UNDO， 像USERS、EXAMPLE等表空间是可有可无的。

### 为用户赋予权限

```sql
grant connect,resource,dba to username;
```
