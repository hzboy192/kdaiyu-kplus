# 后端架构规则

> Kplus 后端开发规范与架构说明

## 技术栈

### 核心框架

| 技术             | 版本   | 说明       |
| ---------------- | ------ | ---------- |
| Spring Boot      | 2.7.18 | 核心框架   |
| Spring Framework | 5.3.33 | Spring核心 |
| Spring Security  | 5.7.12 | 安全框架   |
| MyBatis-Flex     | 1.11.4 | ORM框架    |
| Java             | 8      | JDK版本    |

### 数据库与存储

| 技术       | 版本   | 说明       |
| ---------- | ------ | ---------- |
| PostgreSQL | 42.7.4 | 主数据库   |
| MySQL      | 8.0.33 | 可选数据库 |
| Druid      | 1.2.23 | 连接池     |

### 工具库

Common-Basic [基础设施](./COMMON_BASIC_INFRASTRUCTURE.md) 模块提供了大量工具类和公共组件，建议优先使用：

## 公共模块依赖

项目依赖 kdaiy 基础开发平台的公共模块：

| 模块           | 版本        | 功能                   |
| -------------- | ----------- | ---------------------- |
| common-boot    | 1.0-release | Spring Boot基础配置    |
| common-admin   | 1.0-release | Admin管理功能          |
| common-basic   | 1.0-release | 基础工具类             |
| common-captcha | 1.0-release | 验证码功能             |
| common-msg     | 1.0-release | 消息服务（邮件、短信） |
| common-oss     | 1.0-release | 对象存储               |
| common-pay     | 1.0-release | 支付相关               |
| common-quartz  | 1.0-release | 定时任务               |
| common-tools   | 1.0-release | 其他工具               |

### Maven 依赖方式

新项目通过 Maven 依赖引入脚手架模块：

```xml
<dependencies>
    <!-- 基础工具 -->
    <dependency>
        <groupId>cn.kdaiy</groupId>
        <artifactId>common-basic</artifactId>
        <version>1.0-release</version>
    </dependency>

    <!-- Spring Boot 基础配置 -->
    <dependency>
        <groupId>cn.kdaiy</groupId>
        <artifactId>common-boot</artifactId>
        <version>1.0-release</version>
    </dependency>

    <!-- 验证码 -->
    <dependency>
        <groupId>cn.kdaiy</groupId>
        <artifactId>common-captcha</artifactId>
        <version>1.0-release</version>
    </dependency>

    <!-- 消息服务 -->
    <dependency>
        <groupId>cn.kdaiy</groupId>
        <artifactId>common-msg</artifactId>
        <version>1.0-release</version>
    </dependency>

    <!-- 对象存储 -->
    <dependency>
        <groupId>cn.kdaiy</groupId>
        <artifactId>common-oss</artifactId>
        <version>1.0-release</version>
    </dependency>

    <!-- 定时任务 -->
    <dependency>
        <groupId>cn.kdaiy</groupId>
        <artifactId>common-quartz</artifactId>
        <version>1.0-release</version>
    </dependency>

    <!-- Admin管理 -->
    <dependency>
        <groupId>cn.kdaiy</groupId>
        <artifactId>common-admin</artifactId>
        <version>1.0-release</version>
    </dependency>
</dependencies>
```

### 模块详细说明请参考 [MODULE_REFERENCE.md](./MODULE_REFERENCE.md)

## 项目结构

```
server/kplus-futures/src/main/java/cn/kdaiy/future/
├── FuturesApplication.java      # 启动类
├── AppServletInitializer.java   # Servlet初始化
├── config/                      # 配置类
│   └── FuturesStartedInitial.java # 启动初始化
├── controller/                  # 控制器层
│   ├── UserTrainController.java     # 用户训练控制器
│   ├── UserTrainDtlController.java  # 交易记录控制器
│   ├── BarInfoController.java       # K线数据控制器
│   ├── GoodsInfoController.java     # 商品信息控制器
│   ├── FundAccountController.java   # 资金账户控制器
│   ├── ServiceChargeController.java # 手续费控制器
│   └── HealthController.java        # 健康检查
├── service/                     # 服务层
│   ├── impl/                    # 服务实现
│   │   ├── UserTrainServiceImpl.java
│   │   ├── UserTrainDtlServiceImpl.java
│   │   ├── BarInfoServiceImpl.java
│   │   ├── GoodsInfoServiceImpl.java
│   │   ├── FundAccountServiceImpl.java
│   │   └── ServiceChargeServiceImpl.java
│   ├── UserTrainService.java
│   ├── UserTrainDtlService.java
│   ├── BarInfoService.java
│   ├── GoodsInfoService.java
│   ├── FundAccountService.java
│   └── ServiceChargeService.java
├── mapper/                      # 数据访问层
│   ├── UserTrainMapper.java
│   ├── UserTrainDtlMapper.java
│   ├── BarInfoMapper.java
│   ├── GoodsInfoMapper.java
│   ├── FundAccountMapper.java
│   └── ServiceChargeMapper.java
├── entity/                      # 实体类
│   ├── UserTrainEntity.java         # 训练记录实体
│   ├── UserTrainDtlEntity.java      # 交易记录实体
│   ├── BarInfoEntity.java           # K线数据实体
│   ├── GoodsInfoEntity.java         # 商品信息实体
│   ├── FundAccountEntity.java       # 资金账户实体
│   └── ServiceChargeEntity.java     # 手续费实体
│   └── MinMappingEntity.java        # 最小变动价位
└── vo/                          # 视图对象
    ├── BarVo.java                   # K线VO
    ├── SearchVo.java                # 搜索VO
    ├── SymbolInfoVo.java            # 合约信息VO
    └── TrainSummaryVo.java          # 训练汇总VO
```

## 分层架构规范

### Controller 层规范

```java
@RestController
@RequestMapping("/userTrain")
@Slf4j
public class UserTrainController {

    @Resource
    private UserTrainService userTrainService;

    /**
     * 保存用户训练记录
     */
    @PostMapping
    public Response<?> add(@RequestBody UserTrainEntity userTrain) {
        userTrain.setUserId(SecurityUtils.getUserId());
        boolean isSuccess = userTrainService.addUserTrain(userTrain);
        if (!isSuccess) {
            return Response.bizError("保存失败！");
        }
        return Response.success(userTrain);
    }

    /**
     * 分页查询
     */
    @GetMapping("/page")
    public Response<Page<UserTrainEntity>> page(Page<UserTrainEntity> page) {
        return Response.success(userTrainService.page(page));
    }
}
```

**规范要点：**

1. 使用 `@RestController` 注解
2. 路由使用 `@RequestMapping` 定义基础路径
3. 使用 `@Resource` 注入Service
4. 返回统一的 `Response` 包装对象
5. 使用 `SecurityUtils.getUserId()` 获取当前用户ID
6. 日志使用 `@Slf4j` 注解

### Service 层规范

```java
public interface UserTrainService extends IService<UserTrainEntity> {

    // 状态常量定义
    Integer TRAIN_STATUS_READY = 0;
    Integer TRAIN_STATUS_RUNNING = 1;
    Integer TRAIN_STATUS_FINISH = -1;

    /**
     * 添加用户训练记录
     */
    boolean addUserTrain(UserTrainEntity entity);

    /**
     * 获取合约信息
     */
    SymbolInfoVo getSymbolInfo(SymbolInfoVo infoVo);
}
```

**规范要点：**

1. 继承 `IService<T>` 获得基础CRUD能力
2. 业务状态常量在接口中定义
3. 方法命名语义化
4. 复杂业务逻辑封装在实现类中

### Entity 层规范

```java
@Data
@Table(value = "fu_user_train")
public class UserTrainEntity {

    @Id(keyType = KeyType.Generator, value = KeyGenerators.flexId)
    @JsonSerialize(using = ToStringSerializer.class)
    private Long traId;

    @Column(value = "user_id")
    private Long userId;

    @Column(value = "symbol")
    private String symbol;

    @Column(value = "status")
    private Integer status;

    @Column(value = "create_time")
    private Date createTime;

    // 关联关系
    @RelationOneToMany(selfField = "traId", targetField = "traId")
    private List<UserTrainDtlEntity> dtlList;
}
```

**规范要点：**

1. 使用 `@Data` 注解简化getter/setter
2. `@Table` 指定表名
3. `@Id` 指定主键生成策略（雪花ID）
4. `@Column` 指定字段映射
5. 大数值类型使用 `@JsonSerialize` 防止精度丢失
6. 使用 `@RelationOneToMany` 定义关联关系

### Mapper 层规范

```java
public interface UserTrainMapper extends BaseMapper<UserTrainEntity> {
    // 继承BaseMapper获得基础CRUD
    // 复杂查询在XML中定义
}
```

**XML映射文件位置：**

```
src/main/resources/cn/kdaiy/future/mapper/
├── UserTrainMapper.xml
├── BarInfoMapper.xml
└── GoodsInfoMapper.xml
```

## 统一响应格式

```java
// 成功响应
Response.success(data)

// 业务错误
Response.bizError("错误消息")

// 系统错误
Response.error("系统异常")
```

**响应结构：**

```json
{
  "code": 200,
  "msg": "success",
  "data": { ... }
}
```

## 配置文件规范

### bootstrap.yaml - 启动配置

```yaml
spring:
  application:
    name: kplus-futures
  profiles:
    active: dev
```

### application.yaml - 应用配置

```yaml
server:
  port: 8080

spring:
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
```

### application-ds.yaml - 数据源配置

```yaml
spring:
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: org.postgresql.Driver
    url: jdbc:postgresql://localhost:5432/kplus
    username: postgres
    password: ${DB_PASSWORD}
```

## 安全认证

### SecurityUtils 工具类

```java
// 获取当前用户ID
Long userId = SecurityUtils.getUserId();

// 获取当前用户名
String username = SecurityUtils.getUsername();

// 检查是否登录
boolean isLogin = SecurityUtils.isLogin();
```

## 打包部署

### Maven 打包命令

```bash
# 清理并打包（跳过测试）
mvn clean package -DskipTests

# 安装到本地仓库
mvn clean install -DskipTests
```

### 打包输出结构

```
target/release/
├── lib/                  # 依赖jar包
├── conf/                 # 配置文件
│   ├── bootstrap.yaml
│   ├── application.yaml
│   └── application-ds.yaml
├── kplus-futures.jar     # 应用jar
└── run.sh                # 启动脚本
```

### 启动脚本

```bash
# 启动
./run.sh start

# 停止
./run.sh stop

# 重启
./run.sh restart
```

## 常用查询模式

### MyBatis-Flex 查询

```java
// 条件查询
QueryWrapper query = QueryWrapper.create()
    .where(USER_TRAIN_ENTITY.USER_ID.eq(userId))
    .and(USER_TRAIN_ENTITY.STATUS.eq(1));

List<UserTrainEntity> list = userTrainMapper.selectListByQuery(query);

// 分页查询
Page<UserTrainEntity> page = userTrainMapper.paginate(pageNum, pageSize, query);
```

### 关联查询

```java
// 使用 @RelationOneToMany 自动关联
UserTrainEntity train = userTrainMapper.selectOneById(traId);
// train.dtlList 自动填充关联数据
```

## 开发注意事项

1. **事务管理**：复杂业务操作使用 `@Transactional` 注解
2. **异常处理**：使用统一异常处理器
3. **日志规范**：
   - 使用 `@Slf4j` 注解
   - 关键操作记录日志
   - 异常记录堆栈信息
4. **安全性**：
   - 敏感接口验证用户权限
   - SQL参数使用预编译
   - 配置文件敏感信息使用环境变量
