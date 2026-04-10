# Kplus 项目概述

> K线模拟训练系统 - 期货交易仿真平台

## 项目定位

Kplus 是一个期货K线模拟训练系统，帮助用户通过历史K线数据进行交易训练，提升交易技能。

## 项目结构

```
kdaiy-kplus/
├── packages/                    # 前端 monorepo
│   ├── kplus-web/              # 业务前端（K线训练）
│   ├── kplus-admin/            # 管理后台
│   └── components/             # 共享组件库
├── server/                      # 后端服务
│   └── kplus-futures/          # 期货业务模块
│       └── src/main/java/cn/kdaiy/future/
│           ├── controller/     # API控制器
│           ├── service/        # 业务服务
│           ├── mapper/         # 数据访问
│           ├── entity/         # 实体类
│           └── vo/             # 视图对象
│       └── src/main/resources/
│           ├── bootstrap.yaml  # 启动配置
│           ├── application.yaml # 应用配置
│           └── application-ds.yaml # 数据源配置
├── docs/                        # 文档目录
│   └── rules/                  # 开发规则文档
└── assets/                      # 资源文件
```

## 技术栈

### 前端

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue 3 | 3.5.13 | 前端框架 |
| Vite | 6.0.11 | 构建工具 |
| Element Plus | 2.9.3 | UI组件库 |
| Pinia | 2.2.0 | 状态管理 |
| Vue Router | 4.5.0 | 路由管理 |
| klinecharts | 9.8.10 | K线图表库 |
| @klinecharts/pro | 0.1.1 | K线专业版 |
| echarts | 5.5.0 | 图表库 |
| mqtt | 5.9.0 | MQTT消息 |

### 后端

| 技术 | 版本 | 用途 |
|------|------|------|
| Spring Boot | 2.7.18 | 后端框架 |
| Java | 8 | 编程语言 |
| MyBatis-Flex | 1.11.4 | ORM框架 |
| PostgreSQL | 42.7.4 | 数据库 |
| Hutool | 5.8.18 | 工具库 |
| FastJSON2 | 2.0.53 | JSON处理 |
| Lombok | - | 代码简化 |

## 核心功能模块

### 1. K线训练模块 (kplus-web)

- **商品选择**：期货商品列表展示和选择
- **周期切换**：支持多种K线周期（1分钟、5分钟、15分钟、30分钟、60分钟、日K等）
- **训练模式**：
  - 设置训练时间范围
  - 设置初始资金
  - 设置开仓手数
  - K线逐根播放
- **交易操作**：
  - 开仓（做多/做空）
  - 平仓
  - 实时盈亏计算
- **成绩统计**：
  - 持仓收益
  - 平仓收益
  - 收益率

### 2. 管理后台模块 (kplus-admin)

- **用户管理**：用户注册、登录、权限管理
- **数据管理**：期货商品信息、K线数据管理
- **监控面板**：系统运行状态监控

### 3. 后端服务模块 (kplus-futures)

- **用户训练记录**：训练创建、查询、删除
- **交易记录**：开仓/平仓记录管理
- **资金账户**：账户管理、资金计算
- **K线数据**：历史K线数据查询
- **商品信息**：期货商品配置

## 数据模型

### 核心实体

| 实体 | 表名 | 说明 |
|------|------|------|
| UserTrainEntity | fu_user_train | 用户训练记录 |
| UserTrainDtlEntity | fu_user_train_dtl | 训练交易记录 |
| BarInfoEntity | fu_bar_info | K线数据 |
| GoodsInfoEntity | fu_goods_info | 期货商品信息 |
| FundAccountEntity | fu_fund_account | 资金账户 |
| ServiceChargeEntity | fu_service_charge | 手续费配置 |

### 实体关系

```
UserTrainEntity (训练记录)
    ├── 1:N → UserTrainDtlEntity (交易记录)
    ├── 1:1 → FundAccountEntity (资金账户)
    └── N:1 → GoodsInfoEntity (商品信息)

BarInfoEntity (K线数据)
    └── N:1 → GoodsInfoEntity (商品信息)
```

## 运行命令

```bash
# 前端开发
pnpm admin:run      # 运行管理端
pnpm web:run        # 运行业务端
pnpm all:build      # 构建所有前端

# 后端开发
cd server && mvn spring-boot:run -pl kplus-futures  # 运行后端
cd server && mvn clean package -DskipTests          # 构建后端
```

## 配置文件位置

| 配置 | 位置 |
|------|------|
| 前端环境变量 | packages/kplus-web/.env.dev, .env.prod |
| 后端启动配置 | server/kplus-futures/src/main/resources/bootstrap.yaml |
| 数据源配置 | server/kplus-futures/src/main/resources/application-ds.yaml |

## 相关文档

- [前端架构规则](./FRONTEND_RULES.md)
- [后端架构规则](./BACKEND_RULES.md)
- [业务规则](./BUSINESS_RULES.md)
- [开发指南](./DEVELOPMENT_GUIDE.md)