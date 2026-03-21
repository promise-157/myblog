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