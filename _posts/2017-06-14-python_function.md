---
title: "python函数知识点"
category: python
layout: article
---

# 简介
相信函数大家都比较熟悉了，这里就是简单的记录一点。

```python
def greet_user(username):
	""" 显示简单语句"""
	print("hello, " + username.title() + ".")

greet_user('yubo')
```

上面就是简单的一个函数原型和调用的方法。首先，python定义函数需要关键词`def`表明这是一个函数定义。后面紧接着是函数名称，括号里面是形参，你可以简单的理解为参数。参数就是你需要处理的数据，它可有可无，这个不是必须的。按照python的语法结构，这个语法块就是一个整体，不可分割。一般的函数还有返回值，这个函数显性没有返回值，但是它会向调用者打印一串字符串

### 传递参数
```python
# 默认值， 比如，上面的用法就是可以这样的:
def greet_user(username = 'yubo'):
	...

# 实参变成可选的,下面这个函数有三个参数，这样的话，你的形参不可缺少

def get_formatted(first_name, middle_name, last_name):
    """ 返回全名"""
    full_name = first_name + ' ' + middle_name +  ' ' + last_name;
    return full_name.title()

name = get_formatted('bo', 'zi', 'bo')
print(name)

### 将参数用空值符表示出来，同时判断条件
def get_formatted(first_name, last_name, middle_name = ''):
     if middle_name:
        full_name = first_name + ' ' + middle_name + ' ' + last_name
     else:
        full_name = first_name + ' ' + last_name
     return full_name.title()

name_1 = get_formatted('Bo', 'yu')
name_2 = get_formatted('bo', 'yu', 'zi')

print(name_1)
print(name_2)
# 看下面的这个函数，有意思
def get_formatted(first_name, last_name):
    full_name = first_name + ' ' + last_name
    return full_name.title()

while True:
    print("\n Please input your name\n")
    print("enter 'q' to quit the exam:\n")

    f_name = raw_input("First name:")
    if f_name == 'q':
        break
    l_name = raw_input("Last name:")
    if l_name == 'q':
        break

    formatted = get_formatted(f_name, l_name)
    print(formatted)

# 传递列表
def greet_user(names):
    for name in names:
        print("Hello, " + name.title() + "!")

name_list = ['yubo', 'hechun','xiaoxiao']
greet_user(name_list)

# 在函数中修改列表
def print_list(unprinted_designs, complete_models):
    """ 模拟打印每个设计，直到没有未打印的设计为止"""
    while unprinted_designs:
        current_design = unprinted_designs.pop()

        # 模拟根据设计制作3D打印
        print("Printing model: " + current_design)
        complete_models.append(current_design)

def show_list(complete_models):
    """ 显示打印好的模型"""
    print("\n The following models have been printed")
    for complete_model in complete_models:
        print(complete_model)

unprinted_designs = ['iphone', 'robot', 'winphone']

complete_models = []

print_list(unprinted_designs, complete_models)
show_list(complete_models)

# 禁止函数修改列表，则要将列表的副本传递给函数,比如，上面的例子：
print_list(unprinted_designs[:], complete_models)
# 不过，你除非有充足的理由这样做，否则这样会花时间和内存创建副本，
#这样会影响效率

# 向函数传递任意多的参数, 需要在形参名字前面加上星号(*)
def make_pizza(*topping):
    print(topping)
""" 当然，实参位置还是需要注意的"""
make_pizza('yubo')

make_pizza('hechun', 'xiaoxiao')

# 使用任意数量的关键字实参
def build_profile(first, last, **user_info):
    """创建一个字典， 其中包含我们知道的一切"""
    profile = {}
    profile['first_mane'] = first;
    profile['last_name'] = last;

    for key, value in user_info.items():
        profile[key] = value

    return profile

user_profile = build_profile('bo', 'yu',
        location = 'Qingdao', phone = '123')

print(user_profile)
```


