---
title: Claudecode插件使用
comments: true
cover: /gallery/defaultCover1.png
thumbnail: /gallery/defaultThumbnail1.png
tags:
  - 未分类
categories:
  - 使用技巧
toc: true
excerpt: 详情请点击read more
date: 2026-07-10 20:48:51
description:
---
# 使用前
## 如何添加文件
1. 默认vscode当前打开文件会被引用
2. 添加指定文件，使用@，引入路径，工作目录就是vscode的工程目录
## 清除上下文
1. /clear，指令
## 使用skills
1. 在聊天中直接/skills的名字就可以使用
2. vscode的cc插件很烂不能使用cc的指令，因此想要体验完全版请使用终端键入claude打开，同时获得tab补全的便利。
3. skills默认开启的，触发到关键词自动调用。
4. 自定义skills，要求在.claude/skills或者.claude/command下，只有在这下面就会被当成skill，同时skill还能带附件和辅助说明，格式为my-skill/                 ← ✅ 新格式，技能名 my-skill
          ├── SKILL.md              ←   必须！唯一入口
          ├── reference.md          ←   辅助文件，SKILL.md 不引用就不读
          └── scripts/
              └── helper.sh         ←   辅助脚本
## claude.md
不和skilss一样的触发机制，他是每次聊天都会使用到的。用于去除共性大的冗余提示。