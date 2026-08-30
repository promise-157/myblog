---
title: Ubuntu配置访问github
comments: true
cover: /gallery/defaultCover3.png
thumbnail: /gallery/defaultThumbnail3.png
tags:
  - Ubuntu
  - GitHub
  - WSL
categories:
  - 使用教程
toc: true
excerpt: 详情请点击read more
date: 2026-08-30 19:54:28
description: 在 Ubuntu 或 WSL 中配置 GitHub HTTPS/SSH 认证，并排查误装 gitsome、设备验证码与 Git 配置问题。
---

在 Ubuntu 或 WSL 中执行 `git push` 时，如果出现：

```text
fatal: could not read Username for 'https://github.com': No such device or address
```

真正的问题通常不是缺少提交用户名，而是当前 Linux 环境没有可用于 GitHub 的认证凭据。本文记录一次完整排障过程，并给出 HTTPS 和 SSH 两种可靠方案。

<!-- more -->

## 先分清三类配置

| 配置 | 用途 | 能否解决 push 认证失败 |
| --- | --- | --- |
| `user.name` / `user.email` | 写入 commit 作者信息 | 不能 |
| `remote.origin.url` | 指定远端仓库位置与协议 | 只有地址或协议要变时才修改 |
| HTTPS 凭据或 SSH Key | 证明当前用户有权访问 GitHub | 能 |

下面的命令只能修改提交署名，不能完成 GitHub 登录：

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

GitHub 已不支持用账户密码进行 Git 命令行认证。HTTPS 应使用 OAuth、凭据管理器或 Personal Access Token；SSH 则使用密钥对。

## 推荐方案：官方 GitHub CLI + HTTPS

仓库已经使用 `https://github.com/用户名/仓库.git` 时，通常不必修改远端。官方 GitHub CLI 可以通过浏览器登录，并作为 Git 的 credential helper，不需要把 Token 写入远端 URL。

### 避免误装 gitsome

在 Ubuntu 20.04 等较旧环境中，输入 `gh` 后可能看到：

```text
Command 'gh' not found, but can be installed with:
sudo snap install gh
sudo apt install gitsome
```

`gitsome` 不是 GitHub 官方 CLI，只是一个同样占用 `gh` 命令的第三方 Python 工具。误装后会出现：

```text
gh auth login
Error: No such command "auth".

gh --version
Error: no such option: --version
```

如果已经误装，先删除：

```bash
sudo apt remove gitsome
sudo apt autoremove
command -v gh
```

执行 `autoremove` 前检查待删除列表，确认主要是刚才随 `gitsome` 安装的依赖。删除后 `command -v gh` 应暂时没有输出。

### 从官方 apt 源安装 gh

准备 keyring：

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -nv -O /tmp/githubcli-archive-keyring.gpg \
  https://cli.github.com/packages/githubcli-archive-keyring.gpg
sudo cp /tmp/githubcli-archive-keyring.gpg \
  /etc/apt/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
```

加入 GitHub CLI 官方软件源：

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list
```

安装并验证：

```bash
sudo apt update
sudo apt install gh
gh --version
```

正确输出应以 `gh version 2.x.x` 开头，而不是 `gitsome` 的命令帮助。

### 8 位设备码从哪里来

执行：

```bash
gh auth login
```

依次选择：

```text
GitHub.com
HTTPS
Yes（Authenticate Git with your GitHub credentials）
Login with a web browser
```

终端会显示形如 `XXXX-XXXX` 的一次性 8 位设备码。它来自刚刚运行 `gh auth login` 的终端，不是邮件、短信或网页另外发送的验证码。

浏览器出现 `Authorize your device` 页面后，只输入自己终端刚生成的代码，并确认网页显示的是自己的 GitHub 账号。设备码过期时，在终端按 `Ctrl+C`，重新运行 `gh auth login` 即可。不要把设备码发给别人，也不要使用别人发来的代码。

授权后执行：

```bash
gh auth setup-git
gh auth status
git config --get-all credential.helper
```

不要使用 `gh auth status --show-token`，因为它会输出 Token。此后原有 HTTPS 仓库即可正常执行：

```bash
git push origin main
```

## 备选方案：SSH Key

SSH 适合长期固定的开发环境。它不依赖 HTTPS credential helper，但需要保护私钥，并把远端改为 SSH。

先检查已有密钥：

```bash
find ~/.ssh -maxdepth 1 -type f -printf '%f\n'
```

没有合适密钥时生成 Ed25519 密钥，并建议设置 passphrase：

```bash
ssh-keygen -t ed25519 -C "你的GitHub邮箱"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

只输出公钥：

```bash
cat ~/.ssh/id_ed25519.pub
```

把整行公钥添加到：

```text
GitHub → Settings → SSH and GPG keys → New SSH key
```

`id_ed25519.pub` 可以上传；没有 `.pub` 后缀的 `id_ed25519` 是私钥，绝不能粘贴到网页、聊天、Issue、日志或仓库中。

测试连接：

```bash
ssh -T git@github.com
```

首次连接可能要求确认 GitHub 主机指纹。应先与 GitHub 官方公布的指纹核对，不能无条件接受未知主机。

确认 SSH 成功后再修改目标仓库：

```bash
git remote -v
git remote set-url origin git@github.com:用户名/仓库.git
git remote -v
git push origin main
```

修改远端只是在 HTTPS 和 SSH 之间切换，不会改变 commit 历史。

## 不推荐的做法

不要把 Token 写入 URL：

```text
https://TOKEN@github.com/用户名/仓库.git
```

它可能进入 shell 历史、`.git/config`、日志或截图。

也不建议直接使用明文 credential store：

```bash
git config --global credential.helper store
```

它可能把凭据以可读形式保存在磁盘。优先使用 GitHub CLI、Git Credential Manager 或带 passphrase 的 SSH Key。

## 快速排查清单

```bash
git status --short --branch
git remote -v
git config --get user.name
git config --get user.email
gh --version
gh auth status
```

- commit 作者错误：修正 `user.name` / `user.email`；
- HTTPS 地址正确但未认证：使用 `gh auth login` 和 `gh auth setup-git`；
- `gh auth` 不存在：检查是否误装 `gitsome`；
- 使用 SSH：先生成密钥、添加公钥并测试连接，再修改 remote；
- push 成功后再检查远端分支或 GitHub Actions，不能把本地 commit 成功当作已经发布。

对普通 Ubuntu/WSL 个人开发环境，保留 HTTPS 远端并使用官方 GitHub CLI，通常是改动最少、最方便维护的方案。SSH 更适合希望完全使用密钥认证，或长期管理多台固定开发设备的用户。
