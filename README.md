# Kplus · 口袋鱼

> 基于历史 K 线的期货交易模拟训练平台

Kplus（口袋鱼）是一个面向交易学习者的期货模拟训练系统。它把历史行情"藏"起来，让你像真实交易一样，一根一根地播放 K 线：在不知道未来走势的前提下判断方向、开仓、平仓，训练盘感与交易纪律。

系统完整模拟了开仓、平仓、手续费、实时盈亏与结算统计，并提供训练成绩单、排行榜和收益分析，帮助你复盘每一次决策。

## 在线演示

- 演示地址：<https://kplus.laoder.dpdns.org/>
- 免费使用，欢迎体验。使用中遇到问题或有好的建议，欢迎通过 [Issue](https://gitee.com/kdaiy/kdaiy-kplus/issues) 反馈给我们。

## 功能特性

### K 线训练（kplus-web）

- **商品与周期**：期货商品列表、多周期切换（1/5/15/30/60 分钟、日 K 等）
- **训练配置**：自定义训练时间范围、初始资金、开仓手数
- **逐根播放**：K 线逐根推进，模拟真实行情演进
- **交易操作**：做多、做空、平仓，支持快捷键操作
- **实时盈亏**：持仓浮盈浮亏、手续费、可用资金实时计算
- **训练成绩**：持仓收益、平仓收益、收益率等结算统计

### 管理后台（kplus-admin）

- 用户与权限管理
- 期货商品与 K 线数据管理
- 手续费配置
- 系统运行监控

### 后端服务（kplus-futures）

- 用户训练记录的创建、查询与删除
- 开仓 / 平仓交易记录管理
- 资金账户与盈亏、手续费计算
- 历史 K 线数据与商品信息查询

## 技术栈

### 前端

| 技术 | 说明 |
|------|------|
| Vue 3 + Vite | 前端框架与构建工具 |
| Element Plus | UI 组件库 |
| Pinia + Vue Router | 状态管理与路由 |
| klinecharts / @klinecharts/pro | K 线图表 |
| ECharts | 统计图表 |
| pnpm workspace | Monorepo 管理 |

### 后端

| 技术 | 说明 |
|------|------|
| Spring Boot 2.7 | 后端框架 |
| Java 8 | 运行环境 |
| MyBatis-Flex | ORM 框架 |
| PostgreSQL | 数据库 |
| Hutool / FastJSON2 / Lombok | 工具与简化 |

## 项目结构

```
kdaiy-kplus/
├── packages/                    # 前端 monorepo
│   ├── kplus-web/              # 业务前端（K 线训练）
│   ├── kplus-admin/            # 管理后台
│   └── components/             # 共享组件库
├── server/                     # 后端服务
│   └── kplus-futures/          # 期货业务模块
├── assets/docs/                # 文档
│   └── rules/                  # 开发规则（前端 / 后端 / 业务）
├── AGENTS.md                   # 开发指南
└── package.json                # workspace 脚本
```

## 快速开始

### 环境要求

- Node.js 18+
- pnpm
- JDK 8、Maven 3.6+
- PostgreSQL

### 安装与运行

```bash
# 安装前端依赖
pnpm install

# 启动业务前端（K 线训练）
pnpm web:run

# 启动管理后台
pnpm admin:run
```

```bash
# 启动后端服务
cd server && mvn spring-boot:run -pl kplus-futures
```

数据库连接与启动配置分别位于：

| 配置 | 位置 |
|------|------|
| 启动配置 | `server/kplus-futures/src/main/resources/bootstrap.yaml` |
| 数据源配置 | `server/kplus-futures/src/main/resources/application-ds.yaml` |
| 前端环境变量 | `packages/kplus-web/.env`、`.env.prod` |

后端敏感配置不随仓库分发：本地开发请复制 `application-dev.yaml.example` 为 `application-dev.yaml` 并填入自己的配置（该文件已被忽略）；生产环境通过环境变量注入：

| 环境变量 | 说明 |
|----------|------|
| `postgrsql_username` / `postgrsql_password` | 数据库账号 / 密码 |
| `app_token_secret` | 登录令牌签名密钥 |
| `mail_username` / `mail_password` | 邮件服务账号 / 密码 |

前端请复制 `.env.example` 为 `.env` 并填入 AES 密钥（`.env` 已被忽略，不会提交到仓库）。

### 构建

```bash
pnpm all:build                  # 构建全部前端
cd server && mvn clean package -DskipTests   # 构建后端
```

## 分支与发布

| 分支 | 用途 |
|------|------|
| `dev` | 日常开发，所有功能提交到该分支 |
| `master` | 稳定版本，仅在发布时从 `dev` 合并 |

两个远端保持同步，`git push` 会同时推送到 Gitee 与 GitHub。

## 相关文档

- [项目概述](assets/docs/rules/PROJECT_OVERVIEW.md)
- [前端规范](assets/docs/rules/FRONTEND_RULES.md)
- [后端规范](assets/docs/rules/BACKEND_RULES.md)
- [业务规则](assets/docs/rules/BUSINESS_RULES.md)
- [开发指南](assets/docs/rules/DEVELOPMENT_GUIDE.md)

## 一起完善这个项目

Kplus 目前仍在持续迭代中，很多功能还有很大的改进空间。如果你对交易、量化或前端体验感兴趣，欢迎一起参与：

- **提建议**：发现 Bug 或有功能想法，欢迎提交 Issue
- **贡献代码**：Fork 仓库 → 基于 `dev` 建分支 → 提交改动 → 发起 Pull Request
- **分享使用体验**：先到演示环境 <https://kplus.laoder.dpdns.org/> 玩一玩，把真实感受告诉我们

哪怕只是一条使用反馈，也会让这个项目变得更好。期待你的加入！

## 开源协议

本项目基于 [Apache License 2.0](LICENSE) 开源。

## 仓库地址

- Gitee：<https://gitee.com/kdaiy/kdaiy-kplus>
- GitHub：<https://github.com/hzboy192/kdaiyu-kplus>