# 开发指南

> Kplus 项目开发流程与最佳实践

## 快速开始

### 环境准备

1. **Node.js 环境**
   ```bash
   # 安装 Node.js 18+ 或 20+
   node -v  # 确认版本
   
   # 安装 pnpm
   npm install -g pnpm
   ```

2. **Java 环境**
   ```bash
   # 安装 JDK 8
   java -version
   
   # 安装 Maven 3.6+
   mvn -v
   ```

3. **数据库**
   - PostgreSQL 12+ 或 MySQL 8+
   - 创建数据库 `kplus`

### 克隆项目

```bash
git clone <repository-url>
cd kdaiy-kplus
```

### 安装依赖

```bash
# 前端依赖
pnpm install

# 后端依赖（首次需要下载公共模块）
cd server
mvn clean install -DskipTests
```

### 配置文件

1. **前端环境变量**
   
   创建 `packages/kplus-web/.env.dev`：
   ```env
   VITE_APP_API_BASE=http://localhost:8080
   ```
   
   创建 `packages/kplus-web/.env.prod`：
   ```env
   VITE_APP_API_BASE=https://api.example.com
   ```

2. **后端数据源配置**
   
   修改 `server/kplus-futures/src/main/resources/application-ds.yaml`：
   ```yaml
   spring:
     datasource:
       url: jdbc:postgresql://localhost:5432/kplus
       username: postgres
       password: your_password
   ```

### 启动项目

```bash
# 启动后端
cd server
mvn spring-boot:run -pl kplus-futures

# 或使用脚本
cd server/kplus-futures/target/release
./run.sh start

# 启动前端（另一个终端）
pnpm web:run
```

### 访问应用

- **业务前端**：http://localhost
- **管理后台**：http://localhost:81（需单独启动）
- **后端API**：http://localhost:8080

## 开发流程

### 新增功能流程

1. **需求分析**
   - 明确功能目标
   - 确定涉及的模块（前端/后端）

2. **数据库设计**
   - 设计实体表结构
   - 编写DDL脚本
   - 放入 `server/assets/sql/` 目录

3. **后端开发**
   - 创建 Entity 实体类
   - 创建 Mapper 接口
   - 创建 Service 接口和实现类
   - 创建 Controller 控制器
   - 编写单元测试

4. **前端开发**
   - 创建 API 请求模块
   - 创建业务组件
   - 创建页面视图
   - 配置路由

5. **联调测试**
   - 本地测试功能
   - 处理边界情况
   - 优化用户体验

### 新增实体示例

#### 1. 创建实体类

```java
// entity/NewEntity.java
@Data
@Table(value = "fu_new_table")
public class NewEntity {
    @Id(keyType = KeyType.Generator, value = KeyGenerators.flexId)
    @JsonSerialize(using = ToStringSerializer.class)
    private Long id;
    
    @Column(value = "name")
    private String name;
    
    @Column(value = "create_time")
    private Date createTime;
}
```

#### 2. 创建 Mapper

```java
// mapper/NewMapper.java
public interface NewMapper extends BaseMapper<NewEntity> {
}
```

#### 3. 创建 Service

```java
// service/NewService.java
public interface NewService extends IService<NewEntity> {
    List<NewEntity> queryList(NewEntity entity);
}

// service/impl/NewServiceImpl.java
@Service
public class NewServiceImpl extends ServiceImpl<NewMapper, NewEntity> implements NewService {
    @Override
    public List<NewEntity> queryList(NewEntity entity) {
        QueryWrapper query = QueryWrapper.create(entity).from(NewEntity.class);
        return this.list(query);
    }
}
```

#### 4. 创建 Controller

```java
// controller/NewController.java
@RestController
@RequestMapping("/new")
public class NewController {
    @Resource
    private NewService newService;
    
    @GetMapping("/list")
    public Response<List<NewEntity>> list(NewEntity entity) {
        return Response.success(newService.queryList(entity));
    }
    
    @PostMapping
    public Response<?> add(@RequestBody NewEntity entity) {
        return Response.success(newService.save(entity));
    }
}
```

### 新增前端页面示例

#### 1. 创建 API 模块

```javascript
// data/new_data.js
import request from '@/utils/request'

export function getNewList(params) {
  return request({
    url: '/api/new/list',
    method: 'get',
    params
  })
}

export function addNew(data) {
  return request({
    url: '/api/new',
    method: 'post',
    data
  })
}
```

#### 2. 创建页面视图

```vue
<!-- views/NewView.vue -->
<script setup>
import { ref, onMounted } from 'vue'
import { getNewList } from '@d/new_data'

const list = ref([])

onMounted(() => {
  loadList()
})

const loadList = async () => {
  const { data } = await getNewList()
  list.value = data
}
</script>

<template>
  <div class="new-container">
    <el-table :data="list">
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="createTime" label="创建时间" />
    </el-table>
  </div>
</template>

<style scoped>
.new-container {
  padding: 20px;
}
</style>
```

#### 3. 配置路由

```javascript
// router/index.js
import NewView from '@/views/NewView.vue'

const routes = [
  {
    path: '/new',
    name: 'New',
    component: NewView
  }
]
```

## 构建与部署

### 前端构建

```bash
# 构建业务端
pnpm web:build

# 构建管理端
pnpm admin:build

# 构建所有
pnpm all:build
```

构建产物位置：
- kplus-web: `packages/kplus-web/dist/`
- kplus-admin: `packages/kplus-admin/dist/`

### 后端构建

```bash
cd server
mvn clean package -DskipTests
```

构建产物位置：`server/kplus-futures/target/release/`

### 部署流程

#### 前端部署（静态文件）

```bash
# 上传到服务器
scp -r packages/kplus-web/dist/* user@server:/path/to/web/

# 或使用 Nginx
# 配置 nginx.conf 指向 dist 目录
```

#### 后端部署

```bash
# 上传 release 目录到服务器
scp -r server/kplus-futures/target/release/* user@server:/opt/kplus/

# 启动服务
cd /opt/kplus
./run.sh start
```

## 调试技巧

### 前端调试

1. **Vue DevTools**
   - 安装 Vue DevTools 浏览器扩展
   - 查看组件状态和 Pinia store

2. **Console 日志**
   ```javascript
   // 使用 key('p') 打印训练状态
   console.debug('DEBUG:', trainOption.transList)
   ```

3. **Network 面板**
   - 检查 API 请求响应
   - 查看 Vite 代理是否正常

### 后端调试

1. **IDE 断点调试**
   - 在 IntelliJ IDEA 或 VSCode 中配置远程调试
   - 或直接本地运行调试

2. **日志调试**
   ```java
   log.debug("训练记录: {}", trainEntity);
   log.error("异常信息: {}", exception.getMessage(), exception);
   ```

3. **SQL 日志**
   ```yaml
   # application.yaml 开启 SQL 日志
   mybatis-flex:
     configuration:
       log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
   ```

## 常见问题

### Q1: 前端启动报错 "找不到模块"

```bash
# 确认依赖安装
pnpm install

# 清理缓存重新安装
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

### Q2: 后端启动报错 "数据库连接失败"

检查：
1. 数据库服务是否启动
2. 数据源配置是否正确
3. 网络连接是否正常

### Q3: 图表不显示

检查：
1. K线数据是否正确加载
2. klinecharts 是否正确初始化
3. DOM 容器是否正确渲染

### Q4: 交易操作无响应

检查：
1. 快捷键是否正确绑定
2. 训练状态是否为 RUNNING
3. emit 事件是否正确监听

## 性能优化

### 前端优化

1. **K线数据分批加载**
   ```javascript
   // 每次加载 2000 根左右
   let drawData = list.splice(0, list.length / 2)
   ```

2. **防抖处理**
   ```javascript
   import debounce from 'lodash-es/debounce'
   key('s', debounce(updateNewData, 80))
   ```

3. **组件按需加载**
   ```javascript
   const AsyncComponent = defineAsyncComponent(() => 
     import('./components/HeavyComponent.vue')
   )
   ```

### 后端优化

1. **数据库索引**
   ```sql
   CREATE INDEX idx_user_train_user_id ON fu_user_train(user_id);
   CREATE INDEX idx_bar_info_code_cycle ON fu_bar_info(code, cycle);
   ```

2. **分页查询**
   ```java
   Page<UserTrainEntity> page = userTrainService.paginate(pageNum, pageSize, query);
   ```

3. **缓存策略**
   - 商品信息可缓存
   - 手续费配置可缓存
   - K线数据按时间范围缓存

## 代码规范

### 前端规范

1. **命名规范**
   - 组件：PascalCase (GoodsList.vue)
   - 方法：camelCase (loadList)
   - 常量：UPPER_SNAKE_CASE (TRADE_DIRECTION)

2. **文件组织**
   - 相关文件放同一目录
   - API 模块放在 data 目录
   - 组件放在 components 目录

3. **注释规范**
   ```javascript
   /**
    * 开仓操作
    * @param direction 方向：1.多, -1.空
    */
   let openTrade = (direction) => { ... }
   ```

### 后端规范

1. **命名规范**
   - 类名：PascalCase (UserTrainEntity)
   - 方法名：camelCase (addUserTrain)
   - 常量：UPPER_SNAKE_CASE (TRAIN_STATUS_READY)

2. **包结构**
   - controller：API 控制器
   - service：业务逻辑
   - mapper：数据访问
   - entity：实体类
   - vo：视图对象

3. **注释规范**
   ```java
   /**
    * 用户训练记录 服务层
    * @author hzboy192
    * @since v1
    */
   public interface UserTrainService { ... }
   ```

## 版本管理

### Git 分支策略

```
main        # 主分支（稳定版本）
  ├── dev   # 开发分支
  │   ├── feature/xxx  # 功能分支
  │   ├── bugfix/xxx   # 修复分支
  │   └── refactor/xxx # 重构分支
```

### 提交规范

```
feat: 新增功能
fix: 修复问题
docs: 文档更新
style: 代码格式
refactor: 代码重构
test: 测试相关
chore: 构建/工具
```

## 相关资源

### 技术文档

- [Vue 3 文档](https://vuejs.org/)
- [Element Plus 文档](https://element-plus.org/)
- [klinecharts 文档](https://klinecharts.com/)
- [Spring Boot 文档](https://spring.io/projects/spring-boot)
- [MyBatis-Flex 文档](https://mybatis-flex.com/)

### 项目文档

- [项目概述](./PROJECT_OVERVIEW.md)
- [前端架构规则](./FRONTEND_RULES.md)
- [后端架构规则](./BACKEND_RULES.md)
- [业务规则](./BUSINESS_RULES.md)