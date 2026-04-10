# Common-Basic 基础设施清单

> **开发原则：优先使用 common-basic 提供的现有基础设施，禁止重复造轮子**

---

## 一、枚举类 (Enums)

### 1. BizExpEnum - 业务异常类型

**路径：** `cn.kdaiy.common.basic.enums.BizExpEnum`

| 枚举值               | 代码   | 说明             |
| -------------------- | ------ | ---------------- |
| SYSTEM_ERROR         | 500    | 系统异常         |
| PARAM_ERROR          | 400    | 参数错误         |
| USER_NOT_EXIST       | 400100 | 用户不存在       |
| USER_PASSWORD_ERROR  | 400101 | 用户名或密码错误 |
| USER_NOT_PERMISSION  | 400403 | 用户无权限       |
| USER_CAPTCHA_ERROR   | 400104 | 验证码错误       |
| USER_INPUT_ERROR     | 400105 | 用户输入非法     |
| USER_FORBIDDEN       | 400106 | 用户被禁止访问   |
| USER_LOCKED          | 400107 | 用户被锁定       |
| USER_REPEATED_SUBMIT | 400108 | 不允许重复提交   |
| USER_RATE_LIMIT      | 400109 | 访问过于频繁     |

**使用示例：**

```java
throw new BizException(BizExpEnum.USER_NOT_EXIST);
```

### 2. UserStatus - 用户状态

**路径：** `cn.kdaiy.common.basic.enums.UserStatus`

| 枚举值  | code | info |
| ------- | ---- | ---- |
| OK      | "0"  | 正常 |
| DISABLE | "1"  | 停用 |
| DELETED | "2"  | 删除 |

### 3. BusinessType - 业务操作类型

**路径：** `cn.kdaiy.common.basic.enums.BusinessType`

用于操作日志记录：OTHER, INSERT, UPDATE, DELETE, GRANT, EXPORT, IMPORT, FORCE, GENCODE, CLEAN, SEND_EMAIL, SEND_SMS

### 4. BusinessStatus - 操作状态

**路径：** `cn.kdaiy.common.basic.enums.BusinessStatus`

- SUCCESS - 成功
- FAIL - 失败

### 5. OperatorType - 操作人类别

**路径：** `cn.kdaiy.common.basic.enums.OperatorType`

- OTHER - 其它
- MANAGE - 后台用户
- MOBILE - 手机端用户

### 6. LimitType - 限流类型

**路径：** `cn.kdaiy.common.basic.enums.LimitType`

- DEFAULT - 默认策略全局限流
- IP - 根据请求者IP进行限流

### 7. DesensitizedType - 脱敏类型

**路径：** `cn.kdaiy.common.basic.enums.DesensitizedType`

| 类型        | 说明       | 示例                        |
| ----------- | ---------- | --------------------------- |
| USERNAME    | 姓名脱敏   | 张\*三                      |
| PASSWORD    | 密码脱敏   | **\*\***                    |
| ID_CARD     | 身份证脱敏 | 1101** \*\*** \*\*1234      |
| PHONE       | 手机号脱敏 | 138\*\*\*\*8888             |
| EMAIL       | 邮箱脱敏   | a\*\*\*\*@qq.com            |
| BANK_CARD   | 银行卡脱敏 | \***\* \*\*** \*\*\*\* 1234 |
| CAR_LICENSE | 车牌脱敏   | 京A\*\*\*\*12               |

**使用示例：**

```java
String masked = DesensitizedType.PHONE.desensitizer().apply("13812345678");
// 结果: 138****5678
```

### 8. DataSourceType - 数据源类型

**路径：** `cn.kdaiy.common.basic.enums.DataSourceType`

- MASTER - 主库
- SLAVE - 从库

---

## 二、异常类 (Exceptions)

### 1. BaseException - 基础异常

**路径：** `cn.kdaiy.common.basic.exception.base.BaseException`

**属性：**

- module - 所属模块
- code - 错误码
- args - 错误码参数
- defaultMessage - 默认错误消息

**构造方法：**

```java
new BaseException(String module, String code, Object[] args, String defaultMessage)
new BaseException(String module, String defaultMessage)
new BaseException(String defaultMessage)
```

### 2. BizException - 业务异常

**路径：** `cn.kdaiy.common.basic.exception.BizException`

**属性：**

- code - 错误码（默认400）
- data - 需要返回的数据

**构造方法：**

```java
new BizException(BaseExceptEnum be)                    // 使用枚举
new BizException(BaseExceptEnum be, Serializable data) // 带数据
new BizException(Integer code, String message)         // 自定义code和消息
new BizException(String message)                       // 仅消息
new BizException(String message, Throwable cause)      // 带异常链
```

**使用示例：**

```java
// 方式1：使用枚举
throw new BizException(BizExpEnum.USER_NOT_EXIST);

// 方式2：自定义消息
throw new BizException("自定义业务错误");

// 方式3：带数据返回
throw new BizException(BizExpEnum.PARAM_ERROR, errorData);
```

### 3. 文件相关异常

**路径：** `cn.kdaiy.common.basic.exception.file.*`

| 异常类                               | 说明           |
| ------------------------------------ | -------------- |
| FileException                        | 文件通用异常   |
| FileUploadException                  | 文件上传异常   |
| FileSizeLimitExceededException       | 文件大小超限   |
| FileNameLengthLimitExceededException | 文件名长度超限 |
| InvalidExtensionException            | 文件扩展名无效 |

---

## 三、静态常量 (Constants)

### 1. Constants - 全局静态常量

**路径：** `cn.kdaiy.common.basic.Constants`

#### HTTP状态码

```java
HTTP_STATUS_SUCCESS = 200              // 成功
HTTP_STATUS_ERROR = 500                // 系统错误
HTTP_STATUS_BIZ_ERROR = 400            // 业务异常
HTTP_STATUS_NOT_AUTH_FAILED = 401      // 未认证
HTTP_STATUS_BIZ_VALID_FAILED = 402     // 验证失败
HTTP_STATUS_NOT_ALLOW = 403            // 无权限
HTTP_STATUS_NOT_FOUND = 404            // 未找到
HTTP_STATUS_BIZ_PARAM_ERROR = 422      // 参数错误
HTTP_STATUS_WARN = 601                 // 警告
```

#### 通用标识

```java
SUCCESS_CHAR_0 = "0"                   // 成功标识
FAIL_CHAR_1 = "1"                      // 失败标识
ENABLE_Y = "Y"                         // 启用
DISABLE_N = "N"                        // 禁用
STATUS_0 = "0"                         // 正常
STATUS_1 = "1"                         // 关闭/异常
FLAG_TRUE = "1"                        // 已删除
FLAG_FALSE = "0"                       // 未删除
```

#### Token相关

```java
HEADER_AUTHORIZATION = "Authorization"
TOKEN = "token"
TOKEN_PREFIX = "Bearer "
JWT_USERID = "userid"
JWT_USERNAME = "sub"
JWT_AVATAR = "avatar"
JWT_CREATED = "created"
JWT_AUTHORITIES = "authorities"
CAPTCHA_EXPIRATION = 2                 // 验证码有效期（分钟）
```

#### 权限相关

```java
ALL_PERMISSION = "*:*:*"               // 所有权限
SUPER_ADMIN = "admin"                  // 管理员角色
ROLE_DELIMETER = ","                   // 角色分隔符
PERMISSION_DELIMETER = ","             // 权限分隔符
```

#### 长度限制

```java
USERNAME_MIN_LENGTH = 2
USERNAME_MAX_LENGTH = 30
PASSWORD_MIN_LENGTH = 6
PASSWORD_MAX_LENGTH = 120
```

#### 协议相关

```java
UTF8 = "UTF-8"
GBK = "GBK"
HTTP = "http://"
HTTPS = "https://"
WWW = "www."
RESOURCE_PREFIX = "/files"
```

#### 安全白名单

```java
JSON_WHITELIST_STR = {"org.springframework", "cn.kdaiy"}
JOB_WHITELIST_STR = {"cn.kdaiy.qrtz.task"}
```

### 2. CacheConstants - 缓存Key常量

**路径：** `cn.kdaiy.common.basic.CacheConstants`

```java
APP_PREFIX_KEY = "app:"                           // 应用前缀
LOGIN_TOKEN_KEY = "app:login_tokens:"             // 登录Token
CAPTCHA_CODE_KEY = "app:captcha_codes:"           // 验证码
SYS_CONFIG_KEY = "app:sys_config:"                // 系统配置
SYS_DICT_KEY = "app:sys_dict:"                    // 数据字典
REPEAT_SUBMIT_KEY = "app:security:rep_limit:"     // 防重提交
RATE_LIMIT_KEY = "app:security:rate_limit:"       // 限流
PWD_ERR_CNT_KEY = "app:pwd_err_cnt:"              // 密码错误次数
TRY_LOGIN_ERR_CNT_KEY = "app:try_login_err_cnt:"  // 登录尝试错误次数
CAPTCHA_TYPE_PHONE = "app:captcha_codes:phone:"   // 手机验证码
CAPTCHA_TYPE_EMAIL = "app:captcha_codes:email:"   // 邮箱验证码
PWD_RESET_EMAIL = "app:pwd:reset:"                // 密码重置邮件
```

### 3. UserConstants - 用户常量

**路径：** `cn.kdaiy.common.basic.UserConstants`

```java
SYS_USER = "SYS_USER"          // 系统用户标识
NORMAL = "0"                   // 正常状态
EXCEPTION = "1"                // 异常状态
USER_DISABLE = "1"             // 用户封禁
ROLE_DISABLE = "1"             // 角色封禁
DEPT_NORMAL = "0"              // 部门正常
DEPT_DISABLE = "1"             // 部门停用
DICT_NORMAL = "0"              // 字典正常
YES = "Y"                      // 是
YES_FRAME = 0                  // 是外链
NO_FRAME = 1                   // 否外链
TYPE_DIR = "M"                 // 目录菜单
TYPE_MENU = "C"                // 菜单
TYPE_BUTTON = "F"              // 按钮
LAYOUT = "Layout"              // Layout组件
PARENT_VIEW = "ParentView"     // ParentView组件
INNER_LINK = "InnerLink"       // InnerLink组件
UNIQUE = true                  // 唯一
NOT_UNIQUE = false             // 不唯一
USERNAME_MIN_LENGTH = 2        // 用户名最小长度
USERNAME_MAX_LENGTH = 20       // 用户名最大长度
PASSWORD_MIN_LENGTH = 5        // 密码最小长度
PASSWORD_MAX_LENGTH = 20       // 密码最大长度
```

---

## 四、值对象 (VO)

### 1. Response<T> - 统一响应对象

**路径：** `cn.kdaiy.common.basic.vo.Response`

**属性：**

- status - HTTP状态码
- data - 响应数据
- message - 响应消息

**静态方法：**

```java
// 成功响应
Response.success(data)                    // 成功+数据
Response.success()                        // 仅成功
Response.success(data, message)           // 成功+数据+消息

// 业务错误
Response.bizError(message)                // 业务错误
Response.bizError(status, data, message)  // 自定义状态

// 系统错误
Response.error()                          // 系统错误
Response.error(message)                   // 系统错误+消息

// 其他
Response.warn(data, msg)                  // 警告
Response.toAjax(flag)                     // 根据flag返回成功/失败
Response.authenticationFailed(data)       // 认证失败
Response.notFound(data)                   // 资源不存在
```

**响应结构：**

```json
{
  "status": 200,
  "data": { ... },
  "message": "success"
}
```

### 2. DataItem - 数据项

**路径：** `cn.kdaiy.common.basic.vo.DataItem`

**属性：**

- key - 键（Integer）
- label - 标签
- value - 值

**使用场景：** 下拉框选项、键值对数据

### 3. UploadResult - 文件上传结果

**路径：** `cn.kdaiy.common.basic.vo.UploadResult`

**属性：**

- fileName - 存储文件名
- filePath - 存储路径
- url - 访问URL
- fileSize - 文件大小
- fileType - 文件类型
- fileExt - 文件扩展名
- originalFileName - 原始文件名

---

## 五、使用规范

> **工具类详细用法请参考 [FRAMEWORK_UTILS.md](./FRAMEWORK_UTILS.md)**

### 1. 异常抛出规范

```java
// ✅ 推荐：使用枚举定义业务异常
throw new BizException(BizExpEnum.USER_NOT_EXIST);

// ✅ 推荐：带数据的业务异常
throw new BizException(BizExpEnum.PARAM_ERROR, errorData);

// ❌ 避免：直接new RuntimeException
throw new RuntimeException("用户不存在");
```

### 2. 响应规范

```java
// ✅ 推荐：Controller返回统一Response
@GetMapping("/user/{id}")
public Response<User> getUser(@PathVariable Long id) {
    User user = userService.getById(id);
    return Response.success(user);
}

// ✅ 推荐：业务错误
return Response.bizError("用户不存在");
```

### 3. 常量使用规范

```java
// ✅ 推荐：使用常量而非硬编码
if (Constants.STATUS_0.equals(status)) { ... }

// ✅ 推荐：缓存Key使用常量
redisTemplate.opsForValue().get(CacheConstants.LOGIN_TOKEN_KEY + userId);

// ❌ 避免：硬编码字符串
if ("0".equals(status)) { ... }
```

### 4. 工具类使用规范

```java
// ✅ 推荐：使用StringUtils进行空判断
if (StringUtils.isNotBlank(str)) { ... }

// ❌ 避免：手动判断
if (str != null && !"".equals(str.trim())) { ... }

// ✅ 推荐：使用DateUtils处理日期
String dateStr = DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, new Date());

// ✅ 推荐：使用雪花ID作为主键
Long id = Seq.getId();
```

---

## 六、模块依赖

使用 common-basic 基础设施需要在 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>cn.kdaiy</groupId>
    <artifactId>common-basic</artifactId>
    <version>${project.version}</version>
</dependency>
```

---

_最后更新：2026-04-07_
