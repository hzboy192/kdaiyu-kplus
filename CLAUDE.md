# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个全栈 Monorepo 项目，包含前端和后端：

### 前端（packages/）

- **kplus-admin**: Vue 3 后台管理系统
- **kplus-web**: Vue 3 前台用户界面
- **kplus-components**: 共享组件库

### 后端（server/）

- **kdaiy-futures**: 业务模块（启动模块，端口 8091）
- 其他模块通过 Maven 制品库依赖

## 常用命令

### 前端命令

```bash
# 开发运行
pnpm admin:run      # 运行后台管理系统（端口 80）
pnpm web:run        # 运行前台界面

# 构建项目
pnpm admin:build    # 构建后台管理系统
pnpm web:build      # 构建前台界面
pnpm all:build      # 构建所有前端项目

# 代码检查
pnpm lint           # ESLint 检查并自动修复（不修改文件）
```

### 后端命令

```bash
# 开发运行
pnpm backend:run    # 启动后端服务（端口 8091）

# 构建项目
pnpm backend:build  # 构建 JAR 包（跳过测试）

# 运行测试
cd server && mvn test

# 完整构建（含测试）
cd server && mvn clean package

# 安装依赖到本地仓库
cd server && mvn clean install -DskipTests
```

### 各项目独立命令

#### 前端项目（packages/kplus-admin 或 packages/kplus-web）

```bash
pnpm dev            # 开发运行（admin 默认端口 80）
pnpm build          # 生产环境构建
pnpm preview        # 预览构建结果
```

#### 后端项目（server/）

```bash
cd server
mvn spring-boot:run -pl kdaiy-futures            # 启动后端
mvn clean package -pl kdaiy-futures -am           # 构建启动模块
mvn clean install -DskipTests                     # 安装所有模块
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

### 前端技术栈

- **Vue 3.5.13** - 主框架
- **Vite 6.0.11** - 构建工具
- **Element Plus 2.11.4** - UI 组件库
- **Pinia 2.1.7** - 状态管理
- **Vue Router 4.5.0** - 路由管理
- **TypeScript** - 部分文件使用
- **PNPM** - 包管理器（支持 workspace）

### 后端技术栈

- **Java 8+** - 编程语言
- **Spring Boot 2.7.18** - 应用框架
- **Maven** - 项目构建工具
- **MyBatis-Flex 1.11.3** - ORM 框架
- **PostgreSQL/MySQL** - 数据库
- **Redis** - 缓存
- **Spring Security + JWT** - 安全认证

## 项目架构

### Monorepo 结构

```
packages/                  # 前端工作区
├── components/            # 共享组件库
├── kplus-admin/           # 后台管理系统
└── kplus-web/             # 前台用户界面

server/                    # 后端工作区
├── kdaiy-futures/         # 业务模块（启动模块）
└── pom.xml                # 父级 POM
```

### 路径别名（前端）

所有前端项目都配置了统一的路径别名：

- `@`: src 目录
- `@c`: src/components
- `@d`: src/api （admin）或 src/data （web）
- `@r`: src/router
- `@s`: src/stores
- `@u`: src/utils

### 环境配置

#### 前端环境配置

**kplus-admin**

- 开发环境：API 代理到 `http://localhost:8091/api`
- 生产环境：基础路径 `/admin`，API 路径 `/admin/api`

**kplus-web**

- 开发环境：通过 `VITE_APP_API_BASE` 环境变量配置
- 生产环境：构建时会打包成 zip 文件到 `dist-zip/kplus-web.zip`

#### 后端环境配置

**配置文件位置**

- `server/kdaiy-futures/src/main/resources/application.yaml`
- `server/kdaiy-futures/src/main/resources/application-ds.yaml`

**关键配置**

- 服务端口：8091
- 数据库连接：根据环境配置（PostgreSQL）
- 跨域配置：允许前端开发地址

## 开发规范

### 前端开发规范

**ESLint 配置**

- 不使用分号
- 使用单引号
- 2 空格缩进
- 禁止使用 var（使用 let/const）
- 禁止使用 debugger 和 console

**Vite 特性**

- 自动导入：Vue、Vue Router、Element Plus 图标
- SVG 图标支持
- Gzip 压缩（生产环境）
- 自动移除 console 和 debugger（生产环境）

### 后端开发规范

**代码规范**

- 遵循阿里巴巴 Java 开发规范
- 使用 Lombok 减少样板代码
- 统一异常处理
- 统一返回结果封装

**命名规范**

- 包名：全部小写 `com.kplus.xxx`
- 类名：大驼峰 `UserController`
- 方法名：小驼峰 `getUserById`
- 常量：全大写下划线 `MAX_SIZE`

## 特殊功能

### 前端特殊功能

**加解密工具**

- crypto-js：AES 加密
- JSEncrypt：RSA 加密

**图表可视化**

- ECharts 5.5.1：通用图表
- KLineCharts：股票K线图

**实时通信**

- MQTT & StompJS：WebSocket 消息通信

**富文本编辑**

- Vue Quill：富文本编辑器组件

### 后端特殊功能

**API 文档**

- Swagger/Knife4j：API 文档自动生成
- 访问地址：http://localhost:8091/doc.html

**实时通信**

- WebSocket 支持（与前端 MQTT 配合）

## 开发注意事项

### 前端注意事项

1. 环境变量需要放置在对应项目的 `.env` 文件中
2. admin 项目默认运行在 80 端口，可能需要管理员权限
3. 使用 pnpm 而非 npm 或 yarn
4. 共享组件放在 `packages/components` 目录下
5. API 请求统一使用配置的代理路径 `/api`

### 后端注意事项

1. 后端代码位于 `server/` 目录
2. 使用 Maven 进行依赖管理和构建
3. 启动类在 `server/kdaiy-futures` 模块
4. 配置文件在 `server/kdaiy-futures/src/main/resources/`
5. 开发时注意跨域配置，允许前端访问

### 前后端联调

1. 前端开发时自动代理到后端 `http://localhost:8091/api`
2. 后端需要配置跨域允许前端地址
3. WebSocket 连接地址需要根据环境配置
4. 接口文档地址：http://localhost:8091/doc.html（如有）
