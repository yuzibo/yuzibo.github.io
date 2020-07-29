---
title: vscode支持aosp java
category: tools
layout: post
---
* content
{:toc}

# aosp frameworks
frameworks存在大量的java代码，但是vscode原来是不支持java原生跳转的。
但是在这个URL中找到了这个方法，目前看是解决了这个问题。

[知乎](https://jekton.github.io/2018/05/11/how-to-read-android-source-code/)

# Java 代码的跳转
frameworks/base 里面大多是 Java 代码，VS Code 打开后，你需要告诉它对应的 classpath。这个可以通过创建一个 build.gradle 解决。
```java
# frameworks/base/build.gradle

apply plugin: 'java'

sourceSets {
    main {
        java {
            srcDirs 'core/java'
            srcDirs 'graphics/java'
        }
    }
}
```
目前的情况是添加了这个文件后，frameworks/base/media/下的java代码是可以跳转啊。

后面如果再不满足的话，自己手动添加吧。
