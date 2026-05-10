---
title: 在linux使用hexo
comments: true
cover: /gallery/defaultCover5.png
thumbnail: /gallery/defaultThumbnail5.png
tags:
  - 未分类
categories:
  - 网站手册
toc: true
excerpt: 详情请点击read more
date: 2026-05-10 20:21:36
description:
---
1. 下载nvm：curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
2. 更新配置：source ~/.bashrc
3. 执行安装：nvm install 24，检查版本node -v；npm -v
4. git clone我之前的win下的博客：npm install -g hexo-cli
5. 执行：npm install
6. 适配hexo版本：npm install --save hexo@^7.1.1 hexo-util@^3.2.0 semver@^7.5.4
7. 如果不知道适配哪个版本，你执行hexo clean & hexo g & hexo s，他会报错并告诉你解决方法的，没有报错就是正常。