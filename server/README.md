# Kdaiy 基础开发平台

## 1.项目介绍

Kdaiy 是一个基于 Spring Boot 的基础开发平台，旨在为开发者提供一套预配置、模块化的后端开发基础架构。它整合了企业应用开发中常用的功能模块，如用户认证、权限管理、定时任务、对象存储、消息通知等，帮助开发者快速启动项目，减少重复性工作，专注于业务逻辑的实现。

## 2.技术栈

*   **核心框架**: Spring Boot 2.7.18, Spring Framework 5.3.33
*   **编程语言**: Java 8
*   **构建工具**: Maven
*   **ORM 框架**: MyBatis-Flex 1.9.2
*   **数据库**: PostgreSQL, MySQL
*   **工具库**: Hutool 5.8.18, Lombok, FastJSON2
*   **其他**: Logback (日志), Kaptcha (验证码), Quartz (任务调度可选)

## 3.项目结构

项目采用 Maven 多模块结构进行组织，便于管理和复用。

```
kdaiy-parent (根项目)
├── kdaiy-common (公共模块)
│   ├── common-admin      # Admin管理相关公共代码
│   ├── common-basic      # 基础工具类
│   ├── common-boot       # Spring Boot 基础配置
│   ├── common-captcha    # 验证码功能
│   ├── common-msg        # 消息服务（邮件、短信等）
│   ├── common-oss        # 对象存储（如 MinIO）
│   ├── common-pay        # 支付相关
│   ├── common-quartz     # 定时任务
│   └── common-tools      # 其他通用工具
├── kplus-futures         # 业务模块，包含业务逻辑和数据访问层。
├── kdaiy-admin           # 后台管理模块，整合了common模块和Admin管理，提供后台管理功能。
├── asserts               # 项目相关资源文件，如sql文件、工具配置文件、项目文档等。
├── pom.xml               # 父 POM，管理所有子模块和公共依赖
└── README.md             # 项目根说明
```

## 4.项目依赖

项目的核心依赖已在根 `pom.xml` 的 `dependencyManagement` 中统一管理，包括 Spring Boot、Spring Framework、MyBatis-Flex、Hutool、数据库驱动等。各子模块根据需要引入具体依赖。

主要公共依赖包括：
*   `common-boot`: 提供 Spring Boot 的基础自动配置。
*   `common-basic`: 提供通用的 Java 工具类。
*   `common-captcha`: 提供图形验证码生成与验证功能。
*   `common-msg`: 提供邮件、短信等消息发送功能。
*   `common-oss`: 提供对象存储服务的抽象与实现。
*   `common-pay`: 提供支付接口的封装。
*   `common-quartz`: 提供定时任务的集成。
*   `common-admin`: 提供 Admin 相关的通用功能。

## 5.项目启动

1.  **环境准备**:
    *   安装 JDK 8 或更高版本。
    *   安装 Maven 3.6+。
    *   安装并配置好 PostgreSQL 或 MySQL 数据库。
2.  **配置**:
    *   在 `kdaiy-admin/src/main/resources` 目录下，根据你的环境修改 `bootstrap.yaml` 配置文件，特别是数据库连接信息。
3.  **构建**:
    *   在项目根目录 `kdaiy-parent` 下打开终端，执行 Maven 命令进行构建：
        ```shell
        mvn clean install
        ```
4.  **运行**:
    *   构建完成后，进入 `kdaiy-parent/kdaiy-admin/target/release` 目录。
    *   执行提供的启动脚本：
        ```shell
        ./run.sh start
        ```
    *   停止或重启应用可以使用：
        ```shell
        ./run.sh stop
        ./run.sh restart
        ```