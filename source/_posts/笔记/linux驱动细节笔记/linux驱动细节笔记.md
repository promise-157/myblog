---
title: linux驱动细节笔记
comments: true
cover: /gallery/defaultCover4.png
thumbnail: /gallery/defaultThumbnail4.png
tags:
  - 未分类
categories:
  - 笔记
toc: true
excerpt: 详情请点击read more
date: 2026-04-27 14:58:19
description:
---
# 文件的含义
1. dts文件记录了硬件的配置信息，但是不会记录实现方法，具体的是实现驱动文件要不就是编译内核时固定编入要不就是启动系统后动态加载。因此由于缺乏源文件我们操作资源往往只能查看sys下面的节点有什么功能。
2. 在最开始学习的时候我们操作的dev文件，那为什么还会有sys文件的节点？这个的功能起到了一个仪表板的功能你可以快速使用一些简单的硬件也可以辅助记录复杂硬件的相关信息。在linux2.6版本时创建了控制面板一样的文件夹sys，操作这些文件夹他会代替我们去我dev文件沟通。sys整体就是一个虚拟文件系统文件夹,ls -ld时你会发现都链接到了/dev下面。
3. 有时候官方会提供好一些典型的驱动文件，所以sys会有相应操作方法，也就不需要再去操作/dev文件了。
