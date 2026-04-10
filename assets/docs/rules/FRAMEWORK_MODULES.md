# 模块功能说明

> kdaiy-parent 各公共模块的功能和使用方式

## 模块概览

| 模块           | 功能                          | 必要性       |
| -------------- | ----------------------------- | ------------ |
| common-basic   | 基础工具类、异常、VO、常量    | 必须         |
| common-boot    | Spring Boot基础配置、安全认证 | 必须         |
| common-admin   | Admin管理公共代码             | 业务模块需要 |
| common-captcha | 验证码功能                    | 按需引入     |
| common-msg     | 消息服务（邮件、短信）        | 按需引入     |
| common-oss     | 对象存储（MinIO）             | 按需引入     |
| common-quartz  | 定时任务调度                  | 按需引入     |
| common-pay     | 支付相关                      | 按需引入     |
| common-tools   | 其他工具（代码生成等）        | 按需引入     |

---

## common-basic

### 模块定位

提供基础工具类、异常处理、VO对象、常量定义等，是所有模块的核心依赖。

> **详细文档：** [FRAMEWORK_BASIC.md](./FRAMEWORK_BASIC.md) - 枚举、异常、常量、VO详解
> **工具类：** [FRAMEWORK_UTILS.md](./FRAMEWORK_UTILS.md) - 工具类使用方法

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-basic</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-boot

### 模块定位

Spring Boot核心配置模块，包含安全认证、配置管理、拦截器等。

> **工具类：** [FRAMEWORK_UTILS.md](./FRAMEWORK_UTILS.md#common-boot-工具类) - SecurityUtils、ServletUtils等

### 核心配置类

| 配置类            | 功能                    |
| ----------------- | ----------------------- |
| SecurityConfig    | Spring Security安全配置 |
| RedisConfig       | Redis缓存配置           |
| MyBatisFlexConfig | MyBatis-Flex配置        |
| ThreadPoolConfig  | 线程池配置              |
| FastJson2Config   | JSON序列化配置          |
| I18nConfig        | 国际化配置              |
| ResourcesConfig   | 资源访问配置            |
| FilterConfig      | 过滤器配置              |

### 拦截器与注解

| 拦截器     | 功能         | 注解                 | 功能         |
| ---------- | ------------ | -------------------- | ------------ |
| 认证拦截器 | Token验证    | @Log                 | 操作日志记录 |
| 权限拦截器 | 权限校验     | @RequiresPermissions | 权限校验     |
| 日志拦截器 | 操作日志记录 | @RepeatSubmit        | 防重复提交   |

### 基类

**BaseController** - 控制器基类，提供响应封装方法

```java
@RestController
@RequestMapping("/api/user")
public class UserController extends BaseController {
    @GetMapping("/list")
    public Response<List<User>> list() {
        return success(userService.list());
    }
}
```

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-boot</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-admin

### 模块定位

后台管理公共代码，包含用户、角色、菜单、日志等管理功能。

### 核心功能

#### 1. Service层

| Service              | 功能         |
| -------------------- | ------------ |
| SysUserOnlineService | 用户在线管理 |

#### 2. Controller层

| Controller | 功能                               |
| ---------- | ---------------------------------- |
| sys/\*     | 系统管理接口（用户、角色、菜单等） |
| monitor/\* | 监控接口（在线用户、服务器信息等） |

#### 3. Domain层

包含用户、角色、菜单、日志等实体对象。

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-admin</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-captcha

### 模块定位

验证码功能模块，支持多种验证码类型。

### 验证码类型

| 类型     | codeValue    | 说明                   |
| -------- | ------------ | ---------------------- |
| 旋转拼图 | rotatePuzzle | 旋转拼图验证码         |
| 滑块拼图 | blockPuzzle  | 滑块拼图验证码（推荐） |
| 文字点选 | clickWord    | 文字点选验证码         |

### 核心组件

#### 1. 枚举类

**CaptchaTypeEnum - 验证码类型**

路径：`cn.kdaiy.captcha.enums.CaptchaTypeEnum`

```java
CaptchaTypeEnum.parseFromCodeValue(String codeValue)  // 根据code获取枚举
CaptchaTypeEnum.validateCodeValue(String codeValue)   // 验证code是否有效
```

**RepCodeEnum - 验证码响应码**

路径：`cn.kdaiy.captcha.enums.RepCodeEnum`

| 枚举值                       | code   | desc           |
| ---------------------------- | ------ | -------------- |
| SUCCESS                      | "0000" | 成功           |
| ERROR                        | "0001" | 操作失败       |
| EXCEPTION                    | "9999" | 服务器内部异常 |
| API_CAPTCHA_INVALID          | "6110" | 验证码已失效   |
| API_CAPTCHA_COORDINATE_ERROR | "6111" | 验证失败       |

**StorageType - 存储类型**

路径：`cn.kdaiy.captcha.enums.StorageType`

- **local** - 内存存储
- **redis** - Redis存储

#### 2. 常量接口

路径：`cn.kdaiy.captcha.constant.Constants`

```java
// 图片路径配置
CAPTCHA_BG_IMG = "captcha.bg.img"                    // 滑块底图路径
CAPTCHA_ROTATE_BLOCK_IMG = "captcha.rotate.block"    // 旋转抠图路径
CAPTCHA_SLIDING_BLOCK_IMG = "captcha.sliding.block"  // 滑动抠图路径

// 存储和类型
CAPTCHA_CACHETYPE = "captcha.cacheType"              // 缓存类型
CAPTCHA_TYPE = "captcha.type"                        // 验证码类型

// 水印和字体
CAPTCHA_WATER_MARK = "captcha.water.mark"            // 水印文字
CAPTCHA_WATER_FONT = "captcha.water.font"            // 水印字体
CAPTCHA_FONT_TYPE = "captcha.font.type"              // 字体类型
CAPTCHA_FONT_STYLE = "captcha.font.style"            // 字体样式
CAPTCHA_FONT_SIZE = "captcha.font.size"              // 字体大小

// 功能配置
CAPTCHA_SLIP_OFFSET = "captcha.slip.offset"          // 滑动误差偏移量
CAPTCHA_AES_STATUS = "captcha.aes.status"            // AES加密开关
CAPTCHA_INTERFERENCE_OPTIONS = "captcha.interference.options"  // 干扰项
CAPTCHA_WORD_COUNT = "captcha.word.count"            // 点选文字个数

// 限流配置
REQ_FREQUENCY_LIMIT_ENABLE = "captcha.req.frequency.limit.enable"
REQ_GET_MINUTE_LIMIT = "captcha.req.get.minute.limit"
REQ_GET_LOCK_LIMIT = "captcha.req.get.lock.limit"
REQ_GET_LOCK_SECONDS = "captcha.req.get.lock.seconds"
REQ_VALIDATE_MINUTE_LIMIT = "captcha.req.verify.minute.limit"
REQ_CHECK_MINUTE_LIMIT = "captcha.req.check.minute.limit"
```

#### 3. 配置类

**AjCaptchaProperties - AJ验证码配置**

路径：`cn.kdaiy.captcha.config.properties.AjCaptchaProperties`

配置前缀：`captcha.aj`

| 属性                    | 类型            | 默认值                | 说明                 |
| ----------------------- | --------------- | --------------------- | -------------------- |
| type                    | CaptchaTypeEnum | BLOCKPUZZLE           | 验证码类型           |
| captBg                  | String          | ""                    | 底图路径             |
| slidingBlock            | String          | ""                    | 滑动拼图抠图路径     |
| rotateBlock             | String          | ""                    | 旋转抠图路径         |
| waterMark               | String          | "我的水印"            | 水印文字             |
| waterFont               | String          | "WenQuanZhengHei.ttf" | 水印字体             |
| fontType                | String          | "WenQuanZhengHei.ttf" | 点选字体             |
| slipOffset              | String          | "5"                   | 滑动误差偏移量(像素) |
| aesStatus               | Boolean         | true                  | AES加密开关          |
| interferenceOptions     | String          | "0"                   | 滑块干扰项(0/1/2)    |
| cacheNumber             | String          | "1000"                | 缓存阈值             |
| timingClear             | String          | "180"                 | 清理间隔(秒)         |
| historyDataClearEnable  | boolean         | false                 | 历史数据清除开关     |
| reqFrequencyLimitEnable | boolean         | false                 | 限流开关             |
| reqGetLockLimit         | int             | 5                     | 验证失败锁定次数     |
| reqGetLockSeconds       | int             | 300                   | 锁定时间(秒)         |
| reqGetMinuteLimit       | int             | 100                   | get接口限流          |
| reqCheckMinuteLimit     | int             | 100                   | check接口限流        |
| reqVerifyMinuteLimit    | int             | 100                   | verify接口限流       |
| fontStyle               | int             | Font.BOLD             | 字体样式             |
| fontSize                | int             | 25                    | 字体大小             |
| clickWordCount          | int             | 4                     | 点选文字个数         |

#### 4. 值对象

**CaptchaVO - 验证码信息**

路径：`cn.kdaiy.captcha.vo.CaptchaVO`

| 属性                | 类型         | 说明               |
| ------------------- | ------------ | ------------------ |
| captchaId           | String       | 验证码ID           |
| captchaType         | String       | 验证码类型         |
| originalImageBase64 | String       | 原生图片base64     |
| jigsawImageBase64   | String       | 滑块图片base64     |
| point               | PointVO      | 滑块点选坐标       |
| wordList            | List<String> | 点选文字列表       |
| pointList           | List<Point>  | 点选坐标           |
| pointJson           | String       | 点坐标(base64加密) |
| token               | String       | UUID唯一标识       |
| result              | Boolean      | 校验结果           |
| captchaVerification | String       | 后台二次校验参数   |
| clientUid           | String       | 客户端UI组件ID     |
| ts                  | Long         | 客户端请求时间     |
| browserInfo         | String       | 客户端信息         |

**PointVO - 坐标点**

路径：`cn.kdaiy.captcha.vo.PointVO`

| 属性 | 类型 | 说明  |
| ---- | ---- | ----- |
| x    | int  | X坐标 |
| y    | int  | Y坐标 |

#### 5. 服务接口

**CaptchaService - 验证码服务**

路径：`cn.kdaiy.captcha.service.CaptchaService`

```java
// 获取验证码
CaptchaVO get(CaptchaVO captchaVO);

// 校验验证码（一次校验）
boolean check(CaptchaVO captchaVO);

// 二次校验（后端验证）
boolean verification(CaptchaVO captchaVO);
```

#### 6. Controller层

| Controller        | 功能            |
| ----------------- | --------------- |
| CaptchaController | 获取/校验验证码 |

### 使用示例

```java
// 获取验证码
CaptchaVO vo = new CaptchaVO();
vo.setCaptchaType("blockPuzzle");
CaptchaVO result = captchaService.get(vo);

// 校验验证码
boolean valid = captchaService.check(vo);

// 二次验证
boolean verified = captchaService.verification(vo);
```

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-captcha</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-msg

### 模块定位

消息服务模块，支持邮件和短信发送。

### 核心组件

#### 1. 值对象

**MessageVo - 消息信息**

路径：`cn.kdaiy.msg.vo.MessageVo`

| 属性         | 类型   | 说明               |
| ------------ | ------ | ------------------ |
| from         | String | 发送方             |
| to           | String | 接收方（加密传输） |
| code         | String | 验证码             |
| type         | String | 验证码类型         |
| subject      | String | 主题（邮件）       |
| content      | String | 内容               |
| signName     | String | 短信签名           |
| templateCode | String | 短信模板code       |

#### 2. 服务接口

**MsgService - 消息服务**

路径：`cn.kdaiy.msg.service.MsgService`

```java
// 发送验证码
void sendVerificationCode(MessageVo messageVo);

// 发送邮件/短信
void sendMessage(MessageVo messageVo);
```

#### 3. 配置类

**EmailConfig - 邮件配置**

路径：`cn.kdaiy.msg.config.EmailConfig`

配置项（从sys_config表读取）：

```java
sys.mail.host              // SMTP服务器
sys.mail.username          // 邮箱账号
sys.mail.password          // 邮箱密码
sys.mail.protocol          // 协议（默认smtp）
sys.mail.port              // 端口（默认25）
sys.mail.captcha.expire-time  // 验证码有效期（默认5分钟）
```

#### 4. Controller层

| Controller    | 功能         |
| ------------- | ------------ |
| MsgController | 消息发送接口 |

### 使用示例

```java
@Resource
private MsgService msgService;

// 发送验证码邮件
MessageVo msg = new MessageVo();
msg.setTo("user@example.com");
msg.setCode("123456");
msg.setType("email");
msgService.sendVerificationCode(msg);

// 发送普通邮件
msg.setSubject("邮件主题");
msg.setContent("邮件内容");
msgService.sendMessage(msg);
```

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-msg</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-oss

### 模块定位

对象存储模块，集成MinIO。

### 核心组件

#### 1. 配置类

**MinioProperties - MinIO配置**

路径：`cn.kdaiy.oss.config.MinioProperties`

配置前缀：`oss.minio`

| 属性       | 类型    | 说明          |
| ---------- | ------- | ------------- |
| endpoint   | String  | 服务端点URL   |
| port       | Integer | TCP/IP端口号  |
| accessKey  | String  | 访问密钥      |
| secretKey  | String  | 秘密密钥      |
| secure     | boolean | 是否使用HTTPS |
| bucketName | String  | 默认存储桶    |
| prefix     | String  | 存储对象前缀  |
| partSize   | long    | 分块大小      |
| proxyUrl   | String  | 代理地址      |

#### 2. 服务接口

**StorageService - 存储服务**

路径：`cn.kdaiy.oss.service.StorageService`

```java
// 存储桶操作
boolean bucketExists(String bucketName);
void createBucket(String bucketName);
List<Bucket> listBuckets();
List<String> listBucketName();
boolean removeBucket(String bucketName);

// 文件上传
String putFile(MultipartFile multipartFile, String bucketName, String path);
String putFile(InputStream inputStream, String bucketName, String path);

// 文件删除
boolean removeFile(String bucketName, String objectName);
boolean removeFiles(String bucketName, List<String> objectNameList);
boolean removeFile(String url);

// 文件查询和下载
List<String> listFiles(String bucketName);
String getFileUrl(String bucketName, String objectName);
String getFileUrl(String bucketName, String objectName, int expires);
InputStream downloadFile(String bucketName, String objectName);
String downloadFile2Local(String bucketName, String objectName, String path);
```

### 使用示例

```java
@Resource
private StorageService storageService;

// 上传文件
String url = storageService.putFile(multipartFile, "bucket", "path");

// 获取文件URL
String fileUrl = storageService.getFileUrl("bucket", "objectName");

// 删除文件
storageService.removeFile("bucket", "objectName");
```

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-oss</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-quartz

### 模块定位

定时任务调度模块，基于Quartz。

### 核心组件

#### 1. 常量类

**ScheduleConstants - 任务调度常量**

路径：`cn.kdaiy.qrtz.ScheduleConstants`

```java
// 任务属性
TASK_CLASS_NAME = "TASK_CLASS_NAME"      // 任务类名
TASK_PROPERTIES = "TASK_PROPERTIES"      // 执行目标key

// 计划策略
MISFIRE_DEFAULT = "0"                    // 默认
MISFIRE_IGNORE_MISFIRES = "1"            // 立即触发执行
MISFIRE_FIRE_AND_PROCEED = "2"           // 触发一次执行
MISFIRE_DO_NOTHING = "3"                 // 不触发立即执行

// 状态枚举
ScheduleConstants.Status.NORMAL          // 正常("0")
ScheduleConstants.Status.PAUSE           // 暂停("1")
```

#### 2. 实体类

**SysJob - 定时任务**

路径：`cn.kdaiy.qrtz.domain.SysJob`

表名：`sys_job`

| 属性           | 类型   | 说明                  |
| -------------- | ------ | --------------------- |
| jobId          | Long   | 任务ID                |
| jobName        | String | 任务名称              |
| jobGroup       | String | 任务组名              |
| invokeTarget   | String | 调用目标字符串        |
| cronExpression | String | cron执行表达式        |
| misfirePolicy  | String | 计划策略(0/1/2/3)     |
| concurrent     | String | 是否并发(0允许/1禁止) |
| status         | String | 任务状态(0正常/1暂停) |

方法：

```java
Date getNextValidTime()  // 获取下次执行时间
```

#### 3. 工具类

**CronUtils - Cron表达式工具**

路径：`cn.kdaiy.qrtz.util.CronUtils`

```java
// 验证表达式有效性
boolean isValid(String cronExpression);

// 获取无效信息
String getInvalidMessage(String cronExpression);

// 获取下次执行时间
Date getNextExecution(String cronExpression);
```

**ScheduleUtils - 定时任务工具**

路径：`cn.kdaiy.qrtz.util.ScheduleUtils`

```java
// 构建任务键
TriggerKey getTriggerKey(Long jobId, String jobGroup);
JobKey getJobKey(Long jobId, String jobGroup);

// 创建定时任务
void createScheduleJob(Scheduler scheduler, SysJob job);

// 设置任务策略
CronScheduleBuilder handleCronScheduleMisfirePolicy(SysJob job, CronScheduleBuilder cb);

// 白名单检查
boolean whiteList(String invokeTarget);
```

#### 4. 示例任务

**RyTask - 示例任务类**

路径：`cn.kdaiy.qrtz.task.RyTask`

Bean名称：`ryTask`

```java
// 多参数方法
public void ryMultipleParams(String s, Boolean b, Long l, Double d, Integer i);

// 单参数方法
public void ryParams(String params);

// 无参方法
public void ryNoParams();
```

调用格式：

```
ryTask.ryMultipleParams('字符串', true, 100L, 3.14, 10)
ryTask.ryParams('参数内容')
ryTask.ryNoParams()
```

#### 5. Controller层

| Controller         | 功能         |
| ------------------ | ------------ |
| 定时任务Controller | 任务CRUD接口 |

### 使用示例

```java
// 创建任务
SysJob job = new SysJob();
job.setJobName("测试任务");
job.setJobGroup("DEFAULT");
job.setInvokeTarget("ryTask.ryNoParams()");
job.setCronExpression("0/5 * * * * ?");
job.setMisfirePolicy(ScheduleConstants.MISFIRE_DEFAULT);
job.setConcurrent("1");  // 禁止并发
job.setStatus(ScheduleConstants.Status.NORMAL.getValue());

// 使用ScheduleUtils创建
ScheduleUtils.createScheduleJob(scheduler, job);

// 验证cron表达式
boolean valid = CronUtils.isValid("0/5 * * * * ?");
Date nextTime = CronUtils.getNextExecution("0/5 * * * * ?");
```

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-quartz</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-pay

### 模块定位

支付功能模块（预留）。

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-pay</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## common-tools

### 模块定位

其他通用工具模块（代码生成等）。

### Maven依赖

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-tools</artifactId>
    <version>1.0-release</version>
</dependency>
```

---

## 新项目模块选择建议

### 最小依赖（仅基础功能）

```xml
<!-- 必须引入 -->
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-basic</artifactId>
    <version>1.0-release</version>
</dependency>
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-boot</artifactId>
    <version>1.0-release</version>
</dependency>
```

### 标准依赖（带管理功能）

```xml
<!-- 必须 -->
common-basic
common-boot
common-admin

<!-- 按需 -->
common-captcha  <!-- 验证码 -->
common-msg      <!-- 邮件/短信 -->
common-oss      <!-- 文件存储 -->
common-quartz   <!-- 定时任务 -->
```

---

_最后更新：2026-04-10_
