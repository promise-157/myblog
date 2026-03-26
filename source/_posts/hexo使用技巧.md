---
title: hexo使用技巧
comments: true
cover: /gallery/defaultCover1.png
thumbnail: /gallery/defaultThumbnail1.png
tags:
  - hexo
  - 教程
categories:
  - 教程
date: 2026-03-21 14:26:01
description:
toc: true
sticky: 20
excerpt: 详情请点击read more
---

## 记录对hexo的使用优化过程和教程
### 置顶功能
```
sticky: 100  # 数字越大，置顶优先级越高.
npm install hexo-generator-json-content --save
然后在Icarus配置文件加：
jsonContent:
  meta: false
  pages: false
  posts:
    title: true
    date: true
    path: true
    text: false    # 设为 false，首页加载速度会快很多
    sticky: true  # 核心：显式要求抓取 sticky 字段
```
### 侧边栏，在_config.yml添加
```
  widgets:
  -
    type: profile # 个人信息
    position: left
  -
    type: categories # 分类（层级管理）
    position: left
  -
    type: toc # 目录（长文管理必备）
    position: right
    index: true
    collapsed: false # 是否默认折叠
  -
    type: recent_posts # 最近文章
    position: right
```
添加toc: true也可以自动有目录了
### 自定义首页
```
1.在source目录下创建自定义首页文件，可以是md页可以是html
2.修改_config.yml文件：
index_generator:
  path: 'blog'  # 仅修改这一行，文章的 URL 依然保持原样
  per_page: 10
  order_by: '-date'
  我的原备份：
  index_generator:
  path: ''
  per_page: 10
  order_by: '-date'
  3.修改Icarus配置：
navbar:
    # Navigation menu items
    menu:
        Home: /
        Blog: /blog/


    原备份：
    # Page top navigation bar configurations
navbar:
    # Navigation menu items
    menu:
        Home: /
        Archives: /archives
        Categories: /categories
        Tags: /tags
        About: /about
    # Links to be shown on the right of the navigation bar
    links:
        Download on GitHub:
            icon: fab fa-github
            url: https://github.com/ppoffice/hexo-theme-icarus
# Page footer configurations
```
我的index页面为：
```
---
layout: false
---
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>导航首页 - Promise's Blog</title>
    <style>
        :root { 
            --main-color: #ffffff; /* 主色调改为白色，适合深色背景 */
            --accent-color: #3273dc; /* 强调色 */
        }
        
        body { 
            margin: 0; 
            font-family: "PingFang SC", "Microsoft YaHei", sans-serif;
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh;
            overflow: hidden;
            
            /* 背景图设置 */
            background-image: url('/myblog/images/background.jpg'); 
            background-position: center; 
            background-repeat: no-repeat; 
            background-size: cover; 
            background-attachment: fixed; 
        }

        /* 全屏轻微调暗，确保文字清晰 */
        body::before {
            content: "";
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.2); 
            z-index: -1;
        }

        .container { 
            /* 毛玻璃效果 */
            background: rgba(255, 255, 255, 0.15); 
            backdrop-filter: blur(3px); 
            -webkit-backdrop-filter: blur(3px);
            
            padding: 3rem 2rem; 
            border-radius: 20px; 
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3); 
            
            width: 85%; 
            max-width: 450px; 
            text-align: center;
            color: white; /* 全局文字改为白色 */
        }
        
        h1 { 
            font-size: 2.2rem;
            margin-bottom: 0.5rem; 
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        .description { 
            color: rgba(255, 255, 255, 0.8); 
            margin-bottom: 2.5rem; 
            font-size: 1rem;
        }
        
        /* 幽灵按钮样式 */
        .nav-links { display: flex; flex-direction: column; gap: 15px; }
        .btn {
            padding: 12px; 
            border-radius: 30px; 
            text-decoration: none; 
            font-weight: 500;
            transition: all 0.4s ease; 
            border: 1.5px solid rgba(255, 255, 255, 0.5); 
            color: white;
            background: rgba(255, 255, 255, 0.1);
        }
        .btn:hover { 
            background: white; 
            color: #333; 
            border-color: white; 
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        /* 置顶主按钮稍微显眼一点 */
        .btn-primary {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.8);
        }
        
        /* 动态文章列表 */
        #latest-posts { 
            margin-top: 2.5rem; 
            text-align: left; 
            border-top: 1px solid rgba(255, 255, 255, 0.2); 
            padding-top: 1.5rem; 
        }
        #latest-posts h3 { 
            font-size: 1rem; 
            margin-bottom: 12px; 
            color: rgba(255, 255, 255, 0.9);
        }
        .post-item { 
            font-size: 0.95rem; 
            margin: 10px 0; 
            list-style: none; 
            display: flex; 
            align-items: center;
        }
        .post-link { 
            color: white; 
            text-decoration: none; 
            opacity: 0.85;
            transition: 0.3s;
            white-space: nowrap; 
            overflow: hidden; 
            text-overflow: ellipsis;
        }
        .post-link:hover { opacity: 1; text-decoration: underline; }
        .post-item::before { 
            content: "✦"; 
            margin-right: 10px; 
            font-size: 0.8rem; 
            color: rgba(255, 255, 255, 0.6);
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Promise 的个人空间</h1>
    <p class="description">技术、音乐与生活的交叉点</p>

    <div class="nav-links">
        <a href="/myblog/blog/" class="btn btn-primary">📖 进入博文列表 (Blog)</a>
        <a href="/myblog/archives/" class="btn">📂 文章归档 (Archives)</a>
        <a href="/myblog/about/" class="btn">👤 关于我 (About)</a>
    </div>

    <div id="latest-posts">
        <h3>✨ 最近更新</h3>
        <ul id="post-list" style="padding: 0; margin: 0;">
            <li class="post-item">正在加载最新文章...</li>
        </ul>
    </div>
</div>

<script>
    fetch('/myblog/content.json')
        .then(res => res.json())
        .then(data => {
            const listContainer = document.getElementById('post-list');
            listContainer.innerHTML = '';
            // 获取最近 5 篇
            const recentPosts = data.posts.slice(0, 5);
            
            if (recentPosts.length === 0) {
                listContainer.innerHTML = '<li class="post-item">暂无文章</li>';
                return;
            }

            recentPosts.forEach(post => {
                const li = document.createElement('li');
                li.className = 'post-item';
                li.innerHTML = `<a class="post-link" href="/myblog/${post.path}" title="${post.title}">${post.title}</a>`;
                listContainer.appendChild(li);
            });
        })
        .catch(err => {
            document.getElementById('post-list').innerHTML = '<li class="post-item">暂时无法加载文章列表</li>';
        });
</script>

</body>
</html>
```

### 常用字段集合
1. tags:
  - private
加密
2. sticky: number，越大优先级置顶顺序越高
3. toc: true

### 新增模板化脚本创建功能
在scaffolds里面创建好自己的模板leetcode然后调用create_post.bat leetcode。不带参数则是默认方法。

### 文章间跳转
1. 只要你在两篇文章的 Front-matter 里写了相同的 tags：Icarus 会自动在文章底部展示 “相关文章” 挂件。
2. {% post_link title %}即可，可以使用这个方法手动创建md文件的目录。

### 创建书页
1. source下的md文件为home页，home页就是一开始的页
2. posts文件夹为index生成的页，index_generator指定的这个路径为空则是默认是home页，我这里自己给他设置为blog页。
3. 当你调用hexo new page时会新生成一个文件夹在source里，为一个新的页。newh出来的页需要配置进menu里才能在网站看见，不然就只能通过**网址访问**，注意这里是**可以访问的。**
4.     menu:
        Home: /
        Blog: /blog/
        Archives: /archives
        Categories: /categories
        Tags: /tags
        About: /about
在这里设置页的路径，到时候会访问对应文件。/默认为source文件夹，到时候解析的时候是另外一个路径名字。

### 设置文章预览
在配置文件设置的东西都需要在具体博文再设置打开，否则默认关闭。
```
excerpt: true。
 是否在首页文章卡片显示摘要
    excerpt: true
    # 自动截取的长度（设为 200 左右比较美观）
    auto_excerpt: 200
    # 是否显示“阅读更多”按钮
    read_more: true
```
1. 经测试auto_excerpt功能无效。
2. 解决方法一，直接使用excerpt：具体的摘要内容
3. 解决方法二，在正文写一段摘要，在后面放上```<!-- more -->```，这样做的话就不要加excerpt了。

### 看板娘设置
参考博客为：<https://kailalan.github.io/>
1. 又到老生常谈的问题，md这npm包上传不到github上啊我去。

### 优化图片和创建博文体验
> 老实讲，这个内容不应该出现在使用技巧这的，因为因人而已，我写的脚本也十分臃肿（ai写的）
> 但是花了2个多小时才从ai口中敲出来的代码实在是不想以后忘记了。
>功能为：优化图片识别路径方法，同一级目录下的同名文件夹和同一级目录都可以识别。，那个asset啥的要保持true。
```
@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set /p "U_CAT=[1/3] 输入大类 (回车则为未分类): "
set /p "U_LYT=[2/3] 使用模板 (回车则用 post): "
set /p "U_TTL=[3/3] 标题名字 (回车则用时间戳): "
echo ========================================

if "%U_LYT%"=="" set "U_LYT=post"
set "STAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%"
set "STAMP=%STAMP: =0%"
set "STAMP=%STAMP::=%"

set "FINAL_TITLE=%U_TTL%"
if "%FINAL_TITLE%"=="" set "FINAL_TITLE=%STAMP%"
set "FINAL_TITLE=%FINAL_TITLE: =-%"

set "FINAL_CAT=%U_CAT%"
if "%FINAL_CAT%"=="" set "FINAL_CAT=未分类"

if "%U_CAT%"=="" (
    set "REL_PATH=%FINAL_TITLE%/%FINAL_TITLE%.md"
) else (
    set "REL_PATH=%U_CAT%/%FINAL_TITLE%/%FINAL_TITLE%.md"
)

echo [Hexo] 正在创建文章...
call hexo new "%U_LYT%" "%FINAL_TITLE%" --path "%REL_PATH%"

set "target_file=source\_posts\%REL_PATH:/=\%"

if not exist "%target_file%" (
    echo [错误] 找不到文件: "%target_file%"
    pause
    exit /b
)

set /a random_num=%random% %% 5 + 1
set "cover_path=/gallery/defaultCover%random_num%.png"
set "thumb_path=/gallery/defaultThumbnail%random_num%.png"

echo [处理] 正在写入数据...
set "temp_file=%target_file%.tmp"
set "in_cat=0"

(for /f "usebackq delims=" %%i in ("%target_file%") do (
    set "line=%%i"
    
    :: 封面替换
    if not "!line:COVER_PLACEHOLDER=!"=="!line!" set "line=!line:COVER_PLACEHOLDER=%cover_path%!"
    if not "!line:THUMBNAIL_PLACEHOLDER=!"=="!line!" set "line=!line:THUMBNAIL_PLACEHOLDER=%thumb_path%!"
    
    :: 状态切换：进入 categories 时打开开关，进入 tags 时关闭开关
    echo !line! | findstr /C:"categories:" >nul && set "in_cat=1"
    echo !line! | findstr /C:"tags:" >nul && set "in_cat=0"
    
    :: 只有在分类区才替换
    if "!in_cat!"=="1" (
        set "line=!line:未分类=%FINAL_CAT%!"
    )

    if "!line!"=="" (echo.) else (echo !line!)
)) > "%temp_file%"

move /y "%temp_file%" "%target_file%" >nul

echo ---------------------------------------
echo [成功] 文章已就绪: %FINAL_TITLE%
echo [大类] %FINAL_CAT%
echo ---------------------------------------
pause
```

```
const path = require('path');
const fs = require('fs-extra');

hexo.extend.filter.register('before_post_render', function(data) {
    const postSrcDir = path.dirname(data.full_source);
    const postName = path.basename(data.source, '.md');
    // 关键：读取你的 root 配置 (/myblog/)
    const blogRoot = hexo.config.root || '/';

    // 正则：匹配所有 ![](...)，捕获组 1 为路径/文件名
    const imgRegex = /!\[.*?\]\((?:\.\/)?(?:([^/)]+)\/)?([^)]+?)\)/g;

    data.content = data.content.replace(imgRegex, (match, pathPart, fileName) => {
        // 判定：同级图片 (pathPart为空) 或 同名文件夹图片 (pathPart === postName)
        if (!pathPart || pathPart === postName) {
            
            // 寻找物理原图
            let srcPath = path.join(postSrcDir, postName, fileName);
            if (!fs.existsSync(srcPath)) {
                srcPath = path.join(postSrcDir, fileName);
            }

            if (fs.existsSync(srcPath)) {
                // 1. 强制搬运图片到 public 对应位置
                // data.path 已经是 :year/:month/:day/:title/ 结构
                const destPath = path.join(hexo.public_dir, data.path, fileName);
                fs.ensureDirSync(path.dirname(destPath));
                fs.copySync(srcPath, destPath);

                // 2. 生成带 root 前缀的路径，解决子目录虚无问题
                const webPath = path.join(blogRoot, data.path, fileName).replace(/\\/g, '/');
                
                // console.log(`[同步成功] ${postName} -> ${webPath}`);
                return `<img src="${webPath}" alt="${fileName}">`;
            }
        }
        return match;
    });

    return data;
});
```