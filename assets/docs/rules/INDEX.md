# Kplus 开发规则文档索引

> 快速导航到各个规则文档

## 文档列表

### 项目规则文档

| 文档                                           | 说明         | 适用场景                           |
| ---------------------------------------------- | ------------ | ---------------------------------- |
| [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)   | 项目概述     | 了解项目整体结构、技术栈、功能模块 |
| [FRONTEND_RULES.md](./FRONTEND_RULES.md)       | 前端架构规则 | 前端开发、组件创建、状态管理       |
| [BACKEND_RULES.md](./BACKEND_RULES.md)         | 后端架构规则 | 后端开发、API设计、数据库操作      |
| [BUSINESS_RULES.md](./BUSINESS_RULES.md)       | 业务规则     | 理解K线训练业务逻辑、交易规则      |
| [DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md) | 开发指南     | 快速开始、构建部署、调试技巧       |

### 脚手架框架文档

| 文档                                             | 说明         | 适用场景                            |
| ------------------------------------------------ | ------------ | ----------------------------------- |
| [FRAMEWORK_OVERVIEW.md](./FRAMEWORK_OVERVIEW.md) | 框架概览     | 了解框架技术栈、模块结构、Maven依赖 |
| [FRAMEWORK_BASIC.md](./FRAMEWORK_BASIC.md)       | 基础设施清单 | 使用枚举、异常、VO、常量            |
| [FRAMEWORK_MODULES.md](./FRAMEWORK_MODULES.md)   | 模块功能说明 | 了解各模块功能、配置和使用方式      |
| [FRAMEWORK_UTILS.md](./FRAMEWORK_UTILS.md)       | 工具类清单   | 使用框架提供的工具类                |

## 快速查找

### 我想了解...

- **项目是什么？** → [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)
- **项目结构？** → [PROJECT_OVERVIEW.md#项目结构](./PROJECT_OVERVIEW.md#项目结构)
- **技术栈？** → [PROJECT_OVERVIEW.md#技术栈](./PROJECT_OVERVIEW.md#技术栈)
- **如何运行？** → [DEVELOPMENT_GUIDE.md#快速开始](./DEVELOPMENT_GUIDE.md#快速开始)

### 我想开发前端...

- **创建组件？** → [FRONTEND_RULES.md#组件开发规范](./FRONTEND_RULES.md#组件开发规范)
- **API请求？** → [FRONTEND_RULES.md#api-请求规范](./FRONTEND_RULES.md#api-请求规范)
- **状态管理？** → [FRONTEND_RULES.md#状态管理](./FRONTEND_RULES.md#状态管理)
- **事件通信？** → [FRONTEND_RULES.md#事件通信](./FRONTEND_RULES.md#事件通信)
- **路径别名？** → [FRONTEND_RULES.md#路径别名配置](./FRONTEND_RULES.md#路径别名配置)

### 我想开发后端...

- **创建实体？** → [BACKEND_RULES.md#entity-层规范](./BACKEND_RULES.md#entity-层规范)
- **创建Service？** → [BACKEND_RULES.md#service-层规范](./BACKEND_RULES.md#service-层规范)
- **创建Controller？** → [BACKEND_RULES.md#controller-层规范](./BACKEND_RULES.md#controller-层规范)
- **数据库查询？** → [BACKEND_RULES.md#常用查询模式](./BACKEND_RULES.md#常用查询模式)
- **打包部署？** → [BACKEND_RULES.md#打包部署](./BACKEND_RULES.md#打包部署)
- **基础设施、工具类？** → [UTILS_REFERENCE.md#打包部署](./UTILS_REFERENCE.md)

### 我想理解业务...

- **训练流程？** → [BUSINESS_RULES.md#训练流程](./BUSINESS_RULES.md#训练流程)
- **开仓规则？** → [BUSINESS_RULES.md#开仓规则](./BUSINESS_RULES.md#开仓规则)
- **平仓规则？** → [BUSINESS_RULES.md#平仓规则](./BUSINESS_RULES.md#平仓规则)
- **盈亏计算？** → [BUSINESS_RULES.md#盈亏计算](./BUSINESS_RULES.md#盈亏计算)
- **快捷键？** → [BUSINESS_RULES.md#快捷键定义](./BUSINESS_RULES.md#快捷键定义)

### 我想解决问题...

- **启动报错？** → [DEVELOPMENT_GUIDE.md#常见问题](./DEVELOPMENT_GUIDE.md#常见问题)
- **调试方法？** → [DEVELOPMENT_GUIDE.md#调试技巧](./DEVELOPMENT_GUIDE.md#调试技巧)
- **性能优化？** → [DEVELOPMENT_GUIDE.md#性能优化](./DEVELOPMENT_GUIDE.md#性能优化)

### 我想了解框架...

- **框架概览？** → [FRAMEWORK_OVERVIEW.md](./FRAMEWORK_OVERVIEW.md)
- **枚举/异常？** → [FRAMEWORK_BASIC.md](./FRAMEWORK_BASIC.md)
- **常量/VO？** → [FRAMEWORK_BASIC.md](./FRAMEWORK_BASIC.md)
- **工具类？** → [FRAMEWORK_UTILS.md](./FRAMEWORK_UTILS.md)
- **模块功能？** → [FRAMEWORK_MODULES.md](./FRAMEWORK_MODULES.md)
- **验证码模块？** → [FRAMEWORK_MODULES.md#common-captcha](./FRAMEWORK_MODULES.md#common-captcha)
- **消息模块？** → [FRAMEWORK_MODULES.md#common-msg](./FRAMEWORK_MODULES.md#common-msg)
- **存储模块？** → [FRAMEWORK_MODULES.md#common-oss](./FRAMEWORK_MODULES.md#common-oss)
- **定时任务？** → [FRAMEWORK_MODULES.md#common-quartz](./FRAMEWORK_MODULES.md#common-quartz)

## 动态读取方式

在后续开发中，可以使用以下方式读取规则文档：

### 通过 read 直接读取

```
read file_path="assets/docs/rules/FRONTEND_RULES.md"
```

## 文档更新

当项目有新的规则或变更时，请更新对应的文档文件：

1. **新增功能** → 更新 PROJECT_OVERVIEW.md 和 DEVELOPMENT_GUIDE.md
2. **前端变更** → 更新 FRONTEND_RULES.md
3. **后端变更** → 更新 BACKEND_RULES.md
4. **业务变更** → 更新 BUSINESS_RULES.md

---

_最后更新：2026-04-10_
