# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Vue 3 + Vite 的前端 Monorepo 项目，包含两个应用：
- **kplus-admin**: 后台管理系统
- **kplus-web**: 前台用户界面
- **kplus-components**: 共享组件库

## 常用命令

### 根目录命令
```bash
# 开发运行
pnpm admin:run      # 运行后台管理系统（端口 80）
pnpm web:run        # 运行前台界面

# 构建项目
pnpm admin:build    # 构建后台管理系统
pnpm web:build      # 构建前台界面
pnpm all:build      # 构建所有项目

# 代码检查
pnpm lint           # ESLint 检查并自动修复（不修改文件）
```

### 各项目独立命令
在 `packages/kplus-admin` 或 `packages/kplus-web` 目录下：

```bash
# 开发环境
pnpm dev            # 开发运行（admin 默认端口 80）

# 构建生产版本
pnpm build          # 生产环境构建

# 预览构建结果
pnpm preview        # 预览构建结果
```

## 技术栈

- **Vue 3.5.13** - 主框架
- **Vite 6.0.11** - 构建工具
- **Element Plus 2.11.4** - UI 组件库
- **Pinia 2.1.7** - 状态管理
- **Vue Router 4.5.0** - 路由管理
- **TypeScript** - 部分文件使用
- **PNPM** - 包管理器（支持 workspace）

## 项目架构

### Monorepo 结构
```
packages/
├── components/      # 共享组件库
├── kplus-admin/     # 后台管理系统
└── kplus-web/       # 前台用户界面
```

### 路径别名
所有项目都配置了统一的路径别名：
- `@`: src 目录
- `@c`: src/components
- `@d`: src/api （admin）或 src/data （web）
- `@r`: src/router
- `@s`: src/stores
- `@u`: src/utils

### 环境配置

#### kplus-admin
- 开发环境：API 代理到 `http://localhost:8091/api`
- 生产环境：基础路径 `/admin`，API 路径 `/admin/api`

#### kplus-web
- 开发环境：通过 `VITE_APP_API_BASE` 环境变量配置
- 生产环境：构建时会打包成 zip 文件到 `dist-zip/kplus-web.zip`

## 开发规范

### ESLint 配置
- 不使用分号
- 使用单引号
- 2 空格缩进
- 禁止使用 var（使用 let/const）
- 禁止使用 debugger 和 console

### Vite 特性
- 自动导入：Vue、Vue Router、Element Plus 图标
- SVG 图标支持
- Gzip 压缩（生产环境）
- 自动移除 console 和 debugger（生产环境）

## 特殊功能

### 加解密工具
项目集成了 AES 和 RSA 加密功能：
- crypto-js：AES 加密
- JSEncrypt：RSA 加密

### 图表可视化
- ECharts 5.5.1：通用图表
- KLineCharts：股票K线图

### 实时通信
- MQTT & StompJS：WebSocket 消息通信

### 富文本编辑
- Vue Quill：富文本编辑器组件

## 开发注意事项

1. 环境变量需要放置在对应项目的 `.env` 文件中
2. admin 项目默认运行在 80 端口，可能需要管理员权限
3. 使用 pnpm 而非 npm 或 yarn
4. 共享组件放在 `packages/components` 目录下
5. API 请求统一使用配置的代理路径 `/api`