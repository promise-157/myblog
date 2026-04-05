---
title: 关于linux中无法使用code命令
comments: true
cover: /gallery/defaultCover5.png
thumbnail: /gallery/defaultThumbnail5.png
tags:
  - 未分类
categories:
  - bug集锦
toc: true
excerpt: 详情请点击read more
date: 2026-04-05 10:56:54
description:
---
>username记得替换
# 方法一：建立软链接
## 步骤一：判断Linux端是否有启动脚本/usr/bin/code。
`whereis code`指令查看信息。
如果有则跳转至方法二。
## 步骤二：建立软链接
`sudo ln -s "/mnt/c/Users/username/AppData/Local/Programs/Microsoft VS Code/bin/code" /usr/local/bin/code`并给予权限，`sudo chmod +x /usr/local/bin/code`

# 方法二：直接新建指令
打开bashrc文件，加入你确定可以执行的地址：`alias code="/mnt/c/Users/username/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"`