---
title: LLVM，clangd等新概念接触
comments: true
cover: /gallery/defaultCover1.png
thumbnail: /gallery/defaultThumbnail1.png
tags:
  - 未分类
categories:
  - 笔记
toc: true
excerpt: 详情请点击read more
date: 2026-03-27 19:01:20
description:
---

# 概念
1. LLVM不是一个单一的软件，而是一套庞大的编译器工具链项目。还记得以前按照交叉编译链的时候吗？  
不同架构的编译器编译不了不同平台的代码。，而LLVM不管你写什么语言，先翻译成 LLVM IR，然后 LLVM 负责把 IR 优化并转换成你 i.MX6ULL 能跑的机器码。Rust、Swift、Clang 都是基于它构建的。gcc不是。。。
2. Clang 是 LLVM 项目下的一个子项目，专门负责处理 C/C++/Objective-C。
3. clangd 是一个 LSP (Language Server Protocol) 语言服务器。用于代码补全。  
C++ 的代码补全之所以难，是因为它的每一个符号（变量、函数）的含义，都深度依赖于上下文和编译过程。而这些信息就记录在了编译文件里了，因此说clangd是基于clang的，这样他能更准确的找到文件。特别是使用了模板之类的东西，代码补全简直是灾难。
# muduo：用来处理复杂情况的网络编程的库
文档下载：<https://github.com/mobinsheng/books.git>,叫Linux多线程服务端编程：使用muduo C++网络库.pdf
项目地址：<https://github.com/chenshuo/muduo.git>   
在这里你能学习到智能指针等高级知识。