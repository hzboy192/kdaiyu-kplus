# AGENTS.md - Kplus 项目开发指南

_开发本项目时，此文件会自动加载。请遵循以下规则。_

## 开发前必读

⚠️ **开发本项目任何功能时，必须先读取规则文档**：

### 步骤 1：读取索引

```
read assets/docs/rules/INDEX.md
```

### 步骤 2：按开发类型读取规则

| 开发类型 | 必读文档 |
|----------|----------|
| 新增功能/了解项目 | `assets/docs/rules/PROJECT_OVERVIEW.md` |
| 前端开发 | `assets/docs/rules/FRONTEND_RULES.md` |
| 后端开发 | `assets/docs/rules/BACKEND_RULES.md` |
| 业务逻辑 | `assets/docs/rules/BUSINESS_RULES.md` |
| 遇到问题 | `assets/docs/rules/DEVELOPMENT_GUIDE.md` |

### 步骤 3：遵循规则开发

- 代码结构遵循架构规则
- 业务逻辑遵循业务规则
- 命名规范遵循开发指南

## 项目快速参考

### 基本信息

| 项目 | 路径 | 类型 |
|------|------|------|
| kplus-web | `packages/kplus-web` | 业务前端（K线训练） |
| kplus-admin | `packages/kplus-admin` | 管理后台 |
| kplus-futures | `server/kplus-futures` | 后端服务 |

### 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Vue 3 + Vite + Element Plus + klinecharts + Pinia |
| 后端 | Spring Boot 2.7.18 + MyBatis-Flex + PostgreSQL |
| Java | JDK 8 |
| Node | 18+ |

### 运行命令

```bash
# 前端
pnpm web:run        # 业务端
pnpm admin:run      # 管理端
pnpm all:build      # 构建

# 后端
cd server && mvn spring-boot:run -pl kplus-futures
cd server && mvn clean package -DskipTests
```

### 核心功能

- K线逐根播放训练
- 开仓/平仓操作（快捷键：S/D/A/W）
- 实时盈亏计算
- 训练成绩统计

## 开发规范速查

### 前端规范

```javascript
// 路径别名
import GoodsList from '@c/chart/GoodsList.vue'  // @c = components
import { getBarData } from '@d/kline_pro_data'  // @d = data

// 事件通信（mitt）
emit.emit('doOpenTrade', tradeList)
emit.on('doOpenTrade', (list) => { ... })
```

### 后端规范

```java
// Entity
@Data @Table("fu_user_train")
public class UserTrainEntity { ... }

// Service
public interface XxxService extends IService<XxxEntity> { ... }

// Controller
@RestController @RequestMapping("/xxx")
public class XxxController { ... }
```

### 业务规则

| 状态 | 值 | 说明 |
|------|-----|------|
| TRAIN_STATUS | 0/1/-1 | 未开始/进行中/已结束 |
| TRADE_DIRECTION | 1/-1/0 | 多/空/平 |
| TRADE_STATUS | 1/0 | 持有中/已平仓 |

## 注意事项

1. **不支持反向开仓**：持有多单不能开空单
2. **同一时间多次开仓**：数量累加
3. **手续费双向收取**：开仓和平仓各收一次
4. **K线分批加载**：每批约 2000 根

---

_最后更新：2026-04-03_