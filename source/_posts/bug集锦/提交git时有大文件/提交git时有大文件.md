---
title: 提交git时有大文件
comments: true
cover: /gallery/defaultCover2.png
thumbnail: /gallery/defaultThumbnail2.png
tags:
  - 未分类
categories:
  - bug集锦
toc: true
excerpt: 详情请点击read more
date: 2026-05-12 17:19:36
description:
---
1. 使用git status获取有多少个超前的分支记住那个数字
2. git reset --soft HEAD~7 这个数字具体改成你第一步得到的
3. git reset 大文件的文件夹
4. 这个时候可以选择删除文件或者写.gitgnore重新提交了。
5. 合并分支后貌似会把已经解决的问题重新带过去，在那个分支执行第一步开始的那些步骤就好
6. 这是commit未提交成功的情况解决方法，如果已经上传的云端请另寻他法