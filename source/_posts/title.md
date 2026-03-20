---
title: title
date: 2026-03-19 19:18:43
tags:
---

@[toc]

- [VScode配置hexo笔记 一 配置与预备知识](#vscode配置hexo笔记-一-配置与预备知识)
  - [本次踩坑](#本次踩坑)
  - [markdown语法](#markdown语法)
    - [显示原本文本方法 代码块](#显示原本文本方法-代码块)
    - [文本换行](#文本换行)
    - [标题 目录 超链接](#标题-目录-超链接)
    - [文本相关 一 字与图](#文本相关-一-字与图)
    - [文本相关 二 布局](#文本相关-二-布局)
    - [图片显示问题](#图片显示问题)


# VScode配置hexo笔记 一 配置与预备知识
    教程网址：https://xiamu-ssr.github.io/Hexo/categories/Hexo/?t=1739015009016
    学习markdown语法链接：留坑
    配置图片，音视频方法：留坑。（1）图片CTRLv粘贴即可。
    拷贝csdn博文体验：留坑，待做超链接
## 本次踩坑
（1）教程里的hexo init 不要带blog后缀，因为到时候设置工作流时会要求.github目录在根目录。
（2）文末讲的插件并不能起到打开侧边栏功能，需要下载Markdown Preview Enhanced插件，
![alt text](title/image.png)，注意这里要把文件类型改为markdown，不然快捷键不起作用。ctrl+k v调出预览侧边栏。
  还能通过CTRLshift P键入Markdown Preview Enhanced: Open Preview to the Side打开预览。
(3)新建文章：hexo new post title
## markdown语法

### 显示原本文本方法 代码块
```
切换到英语输入法点击~这个按键的`，单个括起来就是单行代码，```头尾括起来则是代码块，也可以使用tab缩进

代码块里如果是html语言会自动转换
```
### 文本换行
```
两个以上空格加换行
```
测试  
效果
### 标题 目录 超链接
```
使用#号表示多级标题  
生成目录：
1. 【TOC】但是我一直失败
2. 安装Markdown All in One插件在vscode，然后CTRLshift+P，粘贴Markdown All in One，找到create指令点击。  
3.注意标题不要出现中文标点符号，英语的可能可以我没试过

使用html创建锚点：<a id="section1"></a>
锚点使用：[内容](#section1)

标题跳转：疑似专用，笔者不是很了解。  
创建：[目录内容，最好和标题一致](#标题)
使用：创建标题即可。
```
### 文本相关 一 字与图
```
*xx*，**xx**，_xx_,~~xx~~，一一对应查看效果即可。

！[图片描述可以不写](路径 “标题”)，可以是互联网网址路径
超链接。

网址：用<>括起来网址。

公式：$$ 测试 $$ $ test $,单个为行间
```
测试：*xx*，**xx**，_xx_,~~xx~~，
![alt text](source\_posts\title\image.png)
<baidu.com>
$$ 测试 $$ $ test $

### 文本相关 二 布局
```
1.分割线：*** --- ___，效果一一对应

2.引用：可以多级引用增加数量即可，相当于tips，里面可以重新写一个markdown语法内容。>,>>,>>>等

3. 列表：*，在前面加点，英语1.序号。
为了使得不误产生列表时间可以\ .隔开时间，加\也是通用显示原本符号的方法

4.表格
xx|xx|xx
-|-|-
xx|xx|xx

5.todo列表：
- [ ] xxx
- [X] xxx
```
测试：
1. 
***
---
___
2. 
> 测试
> > 测试
3. 
* 列表记得加空格 用*表示
* 1. 可以叠加使用
4. 
xx|xx|xx
-|-|-
xx|xx|xx
5. todo列表：
- [ ] xxx
- [X] xxx

### 图片显示问题
首先需要在md同级目录下创建文件夹存放然后npm uninstall hexo-asset-image hexo-filter-asset-image，把这些卸载掉，在根目录下创建scripts脚本，fix-image.js，代码如下，自带输出调试信息，hexo g时输出。最后使用![alt text](title/image.png)这样的方法显示。
```
const path = require('path');

hexo.extend.filter.register('before_post_render', function(data) {
    // 1. 打印：证明脚本被加载并开始处理文章
    console.log('====================================');
    console.log('[调试] 正在处理文章:', data.title);

    const postName = path.basename(data.source, '.md');
    
    // 2. 更加宽容的正则表达式
    // 匹配：![](文件名/图.png) 或 ![](./文件名/图.png) 或 ![](/文件名/图.png)
    const imgRegex = /!\[.*?\]\((?:\.\/|\/)?([^)]+?)\/([^)]+?)\)/g;

    // 记录匹配次数
    let matchCount = 0;

    data.content = data.content.replace(imgRegex, (match, folderName, fileName) => {
        // 只有文件夹名和文件名一致，或者是子文件夹时才转换
        if (folderName === postName || folderName.includes(postName)) {
            matchCount++;
            const newTag = `{% asset_img "${fileName}" %}`;
            console.log(`  [转换成功] ${match}  =>  ${newTag}`);
            return newTag;
        }
        return match;
    });

    if (matchCount === 0) {
        console.log('  [注意] 此文章未发现匹配路径的图片。');
    }
    
    return data;
});
```




