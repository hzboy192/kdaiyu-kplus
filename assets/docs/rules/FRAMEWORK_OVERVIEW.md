# kdaiy-parent 脚手架框架规则

> Java + Vue 前后端脚手架框架，后端打包为 Maven 制品部署到私仓

## 项目信息

| 项目       | 值                                                                |
| ---------- | ----------------------------------------------------------------- |
| 路径       | `/home/hao-peng/DevSpace/kdaiy-parent`                            |
| 仓库       | `git@codeup.aliyun.com:648a711fc3226d3f2e4e75fb/kdaiy-parent.git` |
| Maven 私服 | `https://packages.aliyun.com/648a711fc3226d3f2e4e75fb/maven/...`  |
| GroupId    | `cn.kdaiy`                                                        |

## 技术栈

| 技术             | 版本   |
| ---------------- | ------ |
| Spring Boot      | 2.7.18 |
| Spring Framework | 5.3.33 |
| Spring Security  | 5.7.12 |
| Java             | 8      |
| MyBatis-Flex     | 1.11.4 |
| PostgreSQL       | 42.7.4 |
| MySQL            | 8.0.33 |
| Hutool           | 5.8.18 |
| FastJSON2        | 2.0.53 |

## 模块结构

```
kdaiy-parent/
├── kdaiy-common/                 # 公共模块
│   ├── common-admin             # Admin管理公共代码
│   ├── common-basic             # 基础工具类
│   ├── common-boot              # Spring Boot基础配置
│   ├── common-captcha           # 验证码功能
│   ├── common-msg               # 消息服务（邮件、短信）
│   ├── common-oss               # 对象存储
│   ├── common-pay               # 支付相关
│   ├── common-quartz            # 定时任务
│   └── common-tools             # 其他通用工具
├── kdaiy-admin/                  # 后台管理模块
└── asserts/                      # 资源文件
```

## Maven 依赖方式

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

## 私仓配置

```xml
<repositories>
    <repository>
        <id>2388035-release-3aJtMF</id>
        <url>https://packages.aliyun.com/648a711fc3226d3f2e4e75fb/maven/2388035-release-3ajtmf</url>
        <releases><enabled>true</enabled></releases>
        <snapshots><enabled>false</enabled></snapshots>
    </repository>
</repositories>
```

---

## 详细文档

- **[基础设施清单](./FRAMEWORK_BASIC.md)** - common-basic 模块的枚举、异常、常量、VO、工具类（开发优先使用）
- **[模块功能说明](./FRAMEWORK_MODULES.md)** - 各模块详细功能、配置和使用方式（包含 captcha、msg、oss、quartz、admin、boot 等）
- [工具类清单](./FRAMEWORK_UTILS.md) - 所有可用工具类及用法
