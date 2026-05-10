---
title: linux配置clash
comments: true
cover: /gallery/defaultCover5.png
thumbnail: /gallery/defaultThumbnail5.png
tags:
  - clash
categories:
  - 教程
toc: true
excerpt: 详情请点击read more
date: 2026-03-25 14:29:02
description:
---
## 下载教程
> 参考网址：<https://www.mgodmonkey.cn/posts/a5d6f412.html>  
> 
1. 对于Ubuntu20.04以下的梯子只能使用那只黑猫图案的软件，使用不了clash verge。Clash verge需要22.04以上。
2. Clash verge的github为：`https://github.com/clash-verge-rev/clash-verge-rev`,
3. clash for windows的网址为`https://github.com/clash-download/Clash-for-Windows.git`,版本选择Clash.for.Windows-0.20.39-x64-linux.tar.gz
### 无命令行
有图片的配置流程具体参考我给出的网址即可。这是是指只有命令行的流程，需要运行cfw后手动开启代理。
```
export https_proxy="http://127.0.0.1:7890"
export http_proxy="http://127.0.0.1:7890" 
```
关闭代理：
```
unset http_proxy
unset https_proxy
```
> 似乎网上有更自动化配置的方法，但是我没理解，可以自己去搜一下。
加&后缀可以后台执行