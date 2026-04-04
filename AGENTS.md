# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 语言规则

用中文回答问题，除非是路径、命令和专业名词可以保持英文。

## 仓库概述

个人 macOS dotfiles，通过手动软链接管理（不使用 stow/rcm/Makefile）。配置文件按类别组织，通过 symlink 部署到系统对应位置。

## 目录结构

- `shell/` — Zsh、Oh My Zsh、Powerlevel10k、Starship 提示符配置
- `git/` — Git 配置（用户信息、LFS、SSL 设置）
- `terminal/` — Kitty（主力终端）、iTerm2、macOS Terminal 配置

## 软链接部署

从仓库根目录通过 `ln -sf` 部署配置：

```bash
ln -sf dotfiles/shell/zshrc ~/.zshrc
ln -sf dotfiles/shell/p10k.zsh ~/.p10k.zsh
ln -sf dotfiles/shell/starship.toml ~/.config/starship.toml
ln -sf dotfiles/git/gitconfig ~/.gitconfig
ln -sf dotfiles/terminal/kitty ~/.config/kitty
```

注意：iTerm2/Terminal 的配置需要通过各自应用手动导入。

## 规范

- **Commit 格式**：Conventional Commits，提交信息使用中文（如 `feat(zsh): 启用 zsh-autosuggestions 插件`、`chore(): 修改kitty字体`）
- **文档语言**：文档和 commit message 使用中文
- **平台**：macOS，包管理器为 Homebrew（路径 `/opt/homebrew`）
- **字体**：ComicShannsMono Nerd Font（shell 和终端配置统一使用）
