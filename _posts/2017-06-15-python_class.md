---
title: "python中类的用法"
category: python
layout: post
---

* content
{:toc}

# python 中类的用法
请先看下面的例子代码:

```python
class Dog():
    def __init__(self, name, age):
        """ 初始化属性 name和age"""
        self.name = name
        self.age = age

    def sit(self):
        """模拟小狗被命令时蹲下"""
        print(self.name.title() + " is now sitting")

    def roll_over(self):
        print(self.name.title() + " is now rolling")


my_dog = Dog('yubo', 6)
print(" My dog,s name is " + my_dog.name.title() + ".")
print("My dog is " + str(my_dog.age) + ".")

my_dog.sit()
my_dog.roll_over()

```
小提示，在python2.x中，定义类时需要在括号里面填上`object`, 就像这样

> def Dog(object)

根据约定，在python中，首字母大写就是指的类，上面的这个类的括号里面是空的，这说明我们要从空白处新建立类。


### __init__
类中的函数称为方法，到目前为止，关于函数的使用方法都适用于类中，唯一的区别在于方法的调用。`__init__`是python中较为特殊的方法，每当你根据类创建实例时，python都会自动运行它，之所以有下划线就是为了让用户避免与其他的方法相混淆。

方法`__init__`中有三个实参，self name和age，self必须位于第一位且不可缺少，python在调用`__init__`创建实例时，将自动传入实参self。每个与类相关联的方法都会传递实参self，它是一个指向实例本身的引用，这类似于c++的this指针。这里，你只需要把参数传递给你自己定义的参数。

>def sit(self):

这个语句就是对应着上面的解释，看，这里你只需要传递一个self，其他的参数就可以调用了。另外，以self为前缀的变量都可供类中的所有方法使用，我们还可以通过类的任何实例来访问这些变量。像这样可以通过实例访问的变量称为属性。

# 使用类和实例

### 给属性指定默认值

```python

class Car():
    def __init__(self, make, model, year):
        """ 初始化汽车属性"""
        self.make = make
        self.model = model
        self.year = year
        ''' 设置默认值， 可以不在形参中体现， 里程表的读数'''
        self.odometer_read = 0
    def get_describe_name(self):
        long_name = str(self.year) + ' ' + self.make  + ' ' + self.model
        return long_name.title()
    def read_meter(self):
        print("This car has " +  str(self.odometer_read) + "meters read ")

my_new_car = Car('Audio', 'A4', '2016')
print(my_new_car.get_describe_name())
my_new_car.read_meter()
```

### 修改属性的值
这里有三种方法: 直接通过实例进行修改、通过方法设置和通过方法进行递增。

1. 直接修改属性的值
在上面的例子中，我们在访问实例的时候，直接将里程表读数设置为112.

```python
class Car():
	--snip--

my_new_car = Car('Audio', 'A4', '2016')
print(my_new_car.get_describe_name())
my_new_car.odometer_read = 112
my_new_car.read_meter()
```

2.通过方法修改属性的值
```python
class Car():
	--snip--

    def update_odometer(self, mileage):
        self.odometer_read = mileage

my_new_car = Car('Audio', 'A4', '2016')
print(my_new_car.get_describe_name())
my_new_car.update_odometer(113)
my_new_car.read_meter()
```
这种方案还是比较符合现代主流软件设计思潮的

### 继承
集成就是利用父类已经让子类可以继续使用定义好的属性

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-

# 自动继承父类的所有属性
# python 2 中需要填写object,而且继承的子类必须声明自己的实例加上self
# pyhton 3 中不需要这些

class Battery():

	"""将多个类分开，让子类多继承"""
	def __init__(self, battery_size = 70):
		""" 初始化电平属性"""
		self.battery_size = battery_size

	def describe_battery(self):
		""" 打印一条电瓶容量的消息"""

		print("This car has a " + str(self.battery_size) + "-kwh battery.")
	def get_range(self):
		""" 打印一条消息，指出电瓶的续航里程"""
		if self.battery_size == 70:
			range = 240
		elif self.battery_size == 85:
			range = 270

		message = " This car can go approximately " + str(range)
		message += " miles on a full charge "
		print(message)

class Car(object):
	""" 一次模拟汽车的简单尝试 """
	def __init__(self, make, model, year):
		self.make = make
		self.model = model
		self.year = year
		""" 默认值  里程表"""
		self.odometer_reading = 0

	def get_describe(self):
		long_name = str(self.year) + ' ' + self.make + ' ' + self.model
		return long_name

	def read_odometer(self):
		print(" This car has " + str(self.odometer_reading) + " miles on it")
	""" 禁止任何人将里程表往回拨"""
	def update_odometer(self, mileage):
		if mileage >= self.odometer_reading:
			self.odometer_reading = mileage
		else:
			print("You can't roll back an odometer!")

	def increment_odometer(self, miles):
		self.odometer_reading += miles

class ElectricCar(Car):
	""" 电动汽车的特点"""
	def __init__(self, make, model, year):
		""" 初始化父类的属性"""
		super(ElectricCar, self).__init__(make, model, year)
		""" 以这样的方法继承Battery()"""
		self.battery = Battery()

my_tesla = ElectricCar('tesla', 'model s', 2016)
print(my_tesla.get_describe())
my_tesla.battery.describe_battery()
my_tesla.battery.get_range()
```
