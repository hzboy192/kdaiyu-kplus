# 工具类清单

> kdaiy-parent 脚手架提供的所有工具类及使用说明

## 概述

项目提供丰富的工具类，分布在各模块中。使用时只需引入对应模块依赖即可。

---

## common-basic 工具类

### 字符串工具

| 类名        | 路径                                      | 功能                               |
| ----------- | ----------------------------------------- | ---------------------------------- |
| StringUtils | `cn.kdaiy.common.basic.utils.StringUtils` | 字符串处理（空判断、截取、拼接等） |

**常用方法：**

```java
// 判断非空
StringUtils.isNotEmpty(str)
StringUtils.isNotBlank(str)

// 判断为空
StringUtils.isEmpty(str)
StringUtils.isBlank(str)

// 截取
StringUtils.substring(str, start, end)
StringUtils.truncate(str, maxLength)

// 格式化
StringUtils.format(template, args...)
```

### 日期工具

| 类名      | 路径                                    | 功能                   |
| --------- | --------------------------------------- | ---------------------- |
| DateUtils | `cn.kdaiy.common.basic.utils.DateUtils` | 日期处理、格式化、计算 |

**常用方法：**

```java
// 获取当前时间
DateUtils.getNowDate()
DateUtils.getNowTime()

// 格式化
DateUtils.format(date, "yyyy-MM-dd HH:mm:ss")
DateUtils.parseDate("2024-01-01", "yyyy-MM-dd")

// 计算
DateUtils.addDays(date, 5)      // 加5天
DateUtils.addMonths(date, 1)    // 加1月
DateUtils.diffDays(date1, date2) // 相差天数
```

### 加密工具

| 类名        | 路径                                             | 功能            |
| ----------- | ------------------------------------------------ | --------------- |
| Md5Utils    | `cn.kdaiy.common.basic.utils.secure.Md5Utils`    | MD5加密         |
| AESUtils    | `cn.kdaiy.common.basic.utils.secure.AESUtils`    | AES加密/解密    |
| RSAUtils    | `cn.kdaiy.common.basic.utils.secure.RSAUtils`    | RSA加密/解密    |
| Base64Utils | `cn.kdaiy.common.basic.utils.secure.Base64Utils` | Base64编码/解码 |

**常用方法：**

```java
// MD5
Md5Utils.hash(str)
Md5Utils.hashFile(file)

// AES（需配置密钥）
AESUtils.encrypt(data, key)
AESUtils.decrypt(encrypted, key)

// RSA
RSAUtils.encryptByPublicKey(data, publicKey)
RSAUtils.decryptByPrivateKey(encrypted, privateKey)

// Base64
Base64Utils.encode(bytes)
Base64Utils.decode(str)
```

### UUID工具

| 类名    | 路径                                       | 功能       |
| ------- | ------------------------------------------ | ---------- |
| IdUtils | `cn.kdaiy.common.basic.utils.uuid.IdUtils` | ID生成     |
| UUID    | `cn.kdaiy.common.basic.utils.uuid.UUID`    | UUID生成   |
| Seq     | `cn.kdaiy.common.basic.utils.uuid.Seq`     | 序列号生成 |

**常用方法：**

```java
// UUID
IdUtils.simpleUUID()      // 无横线的UUID
IdUtils.fastUUID()        // 带横线的UUID

// 雪花ID（推荐用于数据库主键）
Seq.getId()               // 雪花算法生成Long型ID
```

### 文件工具

| 类名          | 路径                                              | 功能         |
| ------------- | ------------------------------------------------- | ------------ |
| FileTypeUtils | `cn.kdaiy.common.basic.utils.files.FileTypeUtils` | 文件类型判断 |
| MimeTypeUtils | `cn.kdaiy.common.basic.utils.files.MimeTypeUtils` | MIME类型     |
| ImageUtils    | `cn.kdaiy.common.basic.utils.files.ImageUtils`    | 图片处理     |

**常用方法：**

```java
// 获取文件扩展名
FileTypeUtils.getExtension(file)
FileTypeUtils.getExtension(fileName)

// 判断图片类型
ImageUtils.getImageType(file)

// 获取MIME类型
MimeTypeUtils.getMimeType(extension)
```

### 其他工具

| 类名             | 路径                                           | 功能       |
| ---------------- | ---------------------------------------------- | ---------- |
| MathUtils        | `cn.kdaiy.common.basic.utils.MathUtils`        | 数学计算   |
| RandomUtils      | `cn.kdaiy.common.basic.utils.RandomUtils`      | 随机数生成 |
| PathUtils        | `cn.kdaiy.common.basic.utils.PathUtils`        | 路径处理   |
| DesensitizedUtil | `cn.kdaiy.common.basic.utils.DesensitizedUtil` | 数据脱敏   |
| SystemInfoUtils  | `cn.kdaiy.common.basic.utils.SystemInfoUtils`  | 系统信息   |
| Threads          | `cn.kdaiy.common.basic.utils.Threads`          | 线程工具   |
| Convert          | `cn.kdaiy.common.basic.utils.text.Convert`     | 类型转换   |
| EscapeUtil       | `cn.kdaiy.common.basic.utils.html.EscapeUtil`  | HTML转义   |

---

## common-boot 工具类

### 安全工具

| 类名          | 路径                                       | 功能         |
| ------------- | ------------------------------------------ | ------------ |
| SecurityUtils | `cn.kdaiy.common.boot.utils.SecurityUtils` | 安全认证相关 |

**常用方法：**

```java
// 获取当前登录用户信息
SecurityUtils.getUserId()           // 用户ID
SecurityUtils.getUsername()         // 用户名
SecurityUtils.getLoginUser()        // 登录用户对象
SecurityUtils.isLogin()             // 是否已登录
SecurityUtils.isAdmin()             // 是否管理员
```

### Servlet工具

| 类名         | 路径                                      | 功能         |
| ------------ | ----------------------------------------- | ------------ |
| ServletUtils | `cn.kdaiy.common.boot.utils.ServletUtils` | HTTP请求处理 |

**常用方法：**

```java
// 获取请求参数
ServletUtils.getParameter("name")
ServletUtils.getParameterToInt("id")

// 获取请求信息
ServletUtils.getRequest()
ServletUtils.getResponse()
ServletUtils.getSession()

// 客户端信息
ServletUtils.getClientIP()
ServletUtils.getHeader("User-Agent")
```

### Spring工具

| 类名        | 路径                                     | 功能           |
| ----------- | ---------------------------------------- | -------------- |
| SpringUtils | `cn.kdaiy.common.boot.utils.SpringUtils` | Spring容器工具 |

**常用方法：**

```java
// 获取Bean
SpringUtils.getBean(Class<T> clazz)
SpringUtils.getBean(String name)

// 获取环境配置
SpringUtils.getActiveProfile()
SpringUtils.getProperty("key")
```

### 字典工具

| 类名      | 路径                                   | 功能     |
| --------- | -------------------------------------- | -------- |
| DictUtils | `cn.kdaiy.common.boot.utils.DictUtils` | 数据字典 |

**常用方法：**

```java
// 根据字典类型和键获取值
DictUtils.getDictLabel("sys_normal_disable", "0")
DictUtils.getDictValue("sys_normal_disable", "正常")
```

### HTTP工具

| 类名      | 路径                                        | 功能     |
| --------- | ------------------------------------------- | -------- |
| HttpUtils | `cn.kdaiy.common.boot.utils.http.HttpUtils` | HTTP请求 |

**常用方法：**

```java
// 发送HTTP请求
HttpUtils.sendGet(url)
HttpUtils.sendPost(url, params)
```

### IP工具

| 类名    | 路径                                    | 功能       |
| ------- | --------------------------------------- | ---------- |
| IpUtils | `cn.kdaiy.common.boot.utils.ip.IpUtils` | IP地址查询 |

**常用方法：**

```java
// 获取IP地址信息
IpUtils.getIpInfo(ip)        // 返回地址信息对象
IpUtils.getRegion(ip)        // 获取地区
IpUtils.getCity(ip)          // 获取城市
```

### POI工具（Excel）

| 类名       | 路径                                        | 功能          |
| ---------- | ------------------------------------------- | ------------- |
| ExcelUtils | `cn.kdaiy.common.boot.utils.poi.ExcelUtils` | Excel导入导出 |

**常用方法：**

```java
// 导出Excel
ExcelUtils.exportExcel(list, "导出文件名", response)

// 导入Excel
List<T> list = ExcelUtils.importExcel(file, Class<T>)
```

---

## common-captcha 工具类

| 类名       | 路径                                | 功能           |
| ---------- | ----------------------------------- | -------------- |
| CacheUtil  | `cn.kdaiy.captcha.utils.CacheUtil`  | 验证码缓存     |
| ImageUtils | `cn.kdaiy.captcha.utils.ImageUtils` | 验证码图片生成 |

---

## common-oss 工具类

| 类名          | 路径                               | 功能         |
| ------------- | ---------------------------------- | ------------ |
| FileTypeUtils | `cn.kdaiy.oss.utils.FileTypeUtils` | 文件类型校验 |

---

## 使用建议

1. **优先使用项目工具类**：避免重复造轮子
2. **字符串判断**：使用 `StringUtils.isNotBlank()` 而非 `!= null && !"".equals()`
3. **日期处理**：复杂日期操作可结合 Hutool 的 `DateUtil`
4. **ID生成**：数据库主键推荐使用雪花ID（`Seq.getId()`）
5. **安全相关**：必须通过 `SecurityUtils` 获取用户信息，不要自行解析Token

---

_最后更新：2026-04-06_
