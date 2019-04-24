---
title: python how to use statistics method 
category: python
layout: post
---
* content
{:toc}

first, the _AIM.txt_ is :
```c
23
45
89
...
```

# count number of element of a list

```python
with open("AIM.txt") as file_object:
	lines = file_object.readlines()
	#print(lines.strip())
	for x in lines:
		if x.strip() == '':
			continue
		temp.append(int(x.strip()))

#print(temp)

dict = {}
for key in temp:
	dict[key] = dict.get(key, 0) + 1

#print(dict)

```

# count number of element of a special interval

```python
# code for python3
from itertools import groupby

lst= [
    2648, 2648, 2648, 63370, 63370, 425, 425, 120,
    120, 217, 217, 189, 189, 128, 128, 115, 115, 197,
    19752, 152, 152, 275, 275, 1716, 1716, 131, 131,
    98, 98, 138, 138, 277, 277, 849, 302, 152, 1571,
    68, 68, 102, 102, 92, 92, 146, 146, 155, 155,
    9181, 9181, 474, 449, 98, 98, 59, 59, 295, 101, 5
]

for k, g in groupby(sorted(lst), key=lambda x: x//50):
    print('{}-{}: {}'.format(k*50, (k+1)*50-1, len(list(g))))

```

Output:

```c
0-49: 1
50-99: 10
100-149: 15
150-199: 8
200-249: 2
250-299: 5
300-349: 1
400-449: 3
450-499: 1
800-849: 1
1550-1599: 1
1700-1749: 2
2600-2649: 3
9150-9199: 2
19750-19799: 1
63350-63399: 2
```
