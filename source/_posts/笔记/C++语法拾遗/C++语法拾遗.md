---
title: C++语法拾遗
comments: true
cover: /gallery/defaultCover4.png
thumbnail: /gallery/defaultThumbnail4.png
tags:
  - 未分类
categories:
  - 笔记
toc: true
excerpt: 详情请点击read more
date: 2026-04-20 19:55:40
description:
---
# explicit语法作用
防止构造函数或转换运算符被用于隐式类型转换。如果一个函数需要传入某个类作为变量，修饰这个类可以强制必须显示构造出这个类防止隐式不安全转换。
在嵌入式中必要性是，阻止隐式构造以达成临时创建对象操作的堆栈空间节省，安全可靠性，避免不稳定的时间花销保证实时性
# 虚函数实现
QString appName() const override; 声明
函数：QString MyApp::appName() const
{}
如果函数太短可以直接在h文件：QString appName() const override { return "视频播放器"; }
# <>和“”的区别
“”会在当前文件夹找一下，因此范围更广，其他头文件除了系统目录就是cmake文件指定的路径了
# extern的作用
通常来讲如果你变量定义在了头文件，其他文件包含头文件相当于多次创建了这个变量。
因此需要在头文件声明的话请用extern，类和结构体就不用了，实际上需要的是他们的实例化对象。
# 类写函数不用考虑先后声明
很爽