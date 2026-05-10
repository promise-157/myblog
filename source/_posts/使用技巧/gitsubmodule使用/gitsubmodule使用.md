---
title: gitsubmodule使用
comments: true
cover: /gallery/defaultCover1.png
thumbnail: /gallery/defaultThumbnail1.png
tags:
  - 未分类
categories:
  - 使用技巧
toc: true
excerpt: 详情请点击read more
date: 2026-05-10 21:23:30
description:
---
# 语法
## git submodule 
git submodule add 仓库 ./你要放的文件夹。注意和git clone不一样，如果没有文件夹的话文件会散乱出来
## 子模块仓库选择
如果是别人的仓库最好fork一个到本地这样方便修改，因为他实际上是记录指针，如果你先用了原仓库的再想改成fork，其实是可以的因为fork来的仓库也会记录原仓库的指针。但是如果你git submodule别人的仓库想改成自己的仓库就不行了，缓存里的指针会冲突。
## 删除子模块
vscode貌似没有提供便捷的方法，必须用命令行，git rm -f 文件夹；然后再把缓存删除一下，rm -rf .git/modules/这里开始就是你从根目录开始的路径了。.git文件夹如果是在vscode看的话是被隐藏的，我就不讲咋取消了，没意义。
# 注意事项
## rm 操作
记得末尾不要带/，这样的话会残留一个文件夹空格