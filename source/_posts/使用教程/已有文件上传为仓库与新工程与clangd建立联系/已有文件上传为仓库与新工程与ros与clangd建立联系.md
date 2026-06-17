---
title: 已有文件上传为仓库与新工程与ros与clangd建立联系
comments: true
cover: /gallery/defaultCover5.png
thumbnail: /gallery/defaultThumbnail5.png
tags:
  - 未分类
categories:
  - 使用教程
toc: true
excerpt: 详情请点击read more
date: 2026-05-14 15:23:07
description:
---
1. ros使用的catkin_make默认不会产生配置文件需要手动定义：
catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=YES

1. 根文件目录执行git init
2. 写gitignore，查找是否有单个文件超过100MB。
3. 提交commit
4. 云端创建好仓库后git remote add origin <你的远程仓库地址>并命名分支：git branch -M main
5. push

1. 使用gh指令一键完成，gh repo create 仓库名 --public --source=. --remote=origin --push

