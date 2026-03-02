# 后端代码迁移指导文档

本文档提供详细的后端代码迁移步骤，帮助你将独立的 Java 后端仓库整合到当前的 Monorepo 项目中。

## 📋 迁移检查清单

### 迁移前准备

- [ ] 备份前端项目 Git 提交
- [ ] 备份后端项目 Git 归档
- [ ] 确认后端可正常运行
- [ ] 确认前端项目配置文件已更新（已完成✅）

### 文件迁移

- [ ] 复制后端代码到 server/ 目录（已完成✅）
- [ ] 检查 pom.xml 配置
- [ ] 确认启动类位置
- [ ] 检查 application.yaml 配置

### 验证测试

- [ ] 后端可启动
- [ ] 前端可启动
- [ ] 前后端 API 通信正常
- [ ] WebSocket 连接正常（如有）

### Git 提交

- [ ] 提交所有更改到 Git
- [ ] 推送到远程仓库（可选）

---

## 🚀 详细迁移步骤

### 步骤 1：备份后端代码

**在后端仓库目录执行：**

```bash
# 确认所有更改已提交
git status

# 创建备份归档
git archive -o ../kplus-server-backup.zip HEAD

# 验证后端可以正常运行
mvn clean install
mvn spring-boot:run -pl kplus-admin
```

---

### 步骤 2：复制后端代码

**在当前前端项目根目录执行：**

```bash
# 进入 server 目录
cd E:\DevSpace\kdaiy-kplus\server

# 将后端仓库的所有文件复制到当前目录
# 注意：不要复制 .git 目录
```

**需要复制的文件和目录：**

- `kdaiy-futures/` - 业务模块（启动模块）
- `pom.xml` - 父级 POM 文件
- 其他配置文件（如果有）

**✅ 注意：**

- 其他模块（如 common-\*）通过 Maven 制品库依赖，不需要复制到本地

---

### 步骤 3：检查父级 pom.xml

**编辑 `server/pom.xml`，确认以下配置：**

```xml
<project>
    <!-- 确认 parent 配置正确 -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
    </parent>

    <!-- 确认 modules 配置正确 -->
    <modules>
        <module>kdaiy-futures</module>
    </modules>

    <!-- 其他配置保持不变 -->
</project>
```

**关键点：**

- `<modules>` 中的模块名称必须与实际目录名一致

---

### 步骤 4：配置跨域（如需要）

**编辑 `server/kdaiy-futures/src/main/resources/application.yaml`：**

```yaml
server:
  port: 8091

spring:
  mvc:
    cors:
      allowed-origins: 'http://localhost,http://localhost:80'
      allowed-methods: 'GET,POST,PUT,DELETE,OPTIONS'
      allowed-headers: '*'
      allow-credentials: true
```

**或者使用 Java 配置类：**

```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost", "http://localhost:80")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
```

---

### 步骤 6：验证后端可启动

**在项目根目录执行：**

```bash
# 方式 1：使用 pnpm 脚本
pnpm backend:run

# 方式 2：直接使用 Maven
cd server
mvn clean install -DskipTests
mvn spring-boot:run -pl kdaiy-futures
```

**验证：**

- 访问 `http://localhost:8091`（或你的后端地址）
- 检查控制台是否有错误
- 访问 API 文档（如有）：`http://localhost:8091/doc.html`

---

### 步骤 7：验证前端可启动

**在项目根目录执行：**

```bash
# 安装依赖（如果还没有）
pnpm install

# 启动前端
pnpm admin:run
```

**验证：**

- 访问 `http://localhost`
- 检查是否能正常访问后端 API
- 检查浏览器控制台是否有错误

---

### 步骤 8：验证前后端联调

**终端 1：启动后端**

```bash
pnpm backend:run
```

**终端 2：启动前端**

```bash
pnpm admin:run
```

**测试：**

1. 访问前端页面 `http://localhost`
2. 测试登录功能（如有）
3. 测试 API 调用是否正常
4. 测试 WebSocket 连接（如有）

---

## 🔧 常见问题排查

### 问题 1：后端启动失败 - 找不到父级 POM

**错误信息：**

```
Non-resolvable parent POM for com.kplus:kplus-admin:1.0.0
```

**解决方案：**
在 `server/pom.xml` 中添加 `<relativePath/>`

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.x.x</version>
    <relativePath/> <!-- 添加这行 -->
</parent>
```

---

### 问题 2：前端无法访问后端 API

**错误信息：**

```
Access to XMLHttpRequest at 'http://localhost:8091/api/...' from origin 'http://localhost'
has been blocked by CORS policy
```

**解决方案：**

**方式 A：后端配置跨域（推荐）**

```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost", "http://localhost:80")
                .allowedMethods("*")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
```

**方式 B：使用 Vite 代理（已配置）**
前端开发环境已配置代理到 `http://localhost:8091/api`，通常不需要额外配置。

---

### 问题 3：Maven 构建失败

**错误信息：**

```
Failed to execute goal on project kplus-admin: Could not resolve dependencies
```

**解决方案：**

```bash
cd server
mvn clean install -U -DskipTests
```

`-U` 参数强制更新依赖。

---

### 问题 4：后端端口冲突

**错误信息：**

```
Web server failed to start. Port 8091 was already in use.
```

**解决方案：**

**方式 A：修改后端端口**

```yaml
# server/kplus-admin/src/main/resources/application.yml
server:
  port: 8092 # 改为其他端口
```

同时需要更新前端代理配置：

```javascript
// packages/kplus-admin/vite.config.js
proxy: {
  '/api': {
    target: 'http://localhost:8092/api',  // 更新端口
    changeOrigin: true,
  }
}
```

**方式 B：关闭占用端口的进程**

```bash
# Windows
netstat -ano | findstr :8091
taskkill /PID <进程ID> /F

# Linux/Mac
lsof -i :8091
kill -9 <进程ID>
```

---

### 问题 5：找不到启动类

**错误信息：**

```
Unable to find a suitable main class
```

**解决方案：**

确认启动类路径：

```bash
# 启动类应该在
server/kplus-admin/src/main/java/com/kplus/Application.java
```

或者在 `pom.xml` 中指定启动类：

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <mainClass>com.kplus.Application</mainClass>
            </configuration>
        </plugin>
    </plugins>
</build>
```

---

## 📝 迁移后的开发工作流

### 开发模式 A：分终端启动（推荐）

**终端 1：启动后端**

```bash
pnpm backend:run
```

**终端 2：启动前端**

```bash
pnpm admin:run
```

### 开发模式 B：IDE 分开

- **IntelliJ IDEA**：打开 `E:\DevSpace\kdaiy-kplus\server\` 目录
- **VS Code / Cursor**：打开 `E:\DevSpace\kdaiy-kplus\` 根目录

### 开发模式 C：一键启动（需要额外配置）

创建 `scripts/dev.sh`（Linux/Mac）或 `scripts/dev.bat`（Windows）脚本：

**Windows (`scripts/dev.bat`)：**

```batch
@echo off
echo 启动后端服务...
start cmd /k "cd server && mvn spring-boot:run -pl kplus-admin"

timeout /t 10

echo 启动前端服务...
start cmd /k "pnpm admin:run"

echo 前后端服务已启动！
pause
```

**Linux/Mac (`scripts/dev.sh`)：**

```bash
#!/bin/bash
echo "启动后端服务..."
cd server && mvn spring-boot:run -pl kplus-admin &

echo "等待后端启动..."
sleep 10

echo "启动前端服务..."
cd .. && pnpm admin:run &

wait
```

---

## 🎯 迁移完成后的下一步

### 1. 配置 API 文档（可选）

如果你的后端使用了 Swagger/Knife4j，访问地址：

```
http://localhost:8091/doc.html
```

### 2. 配置数据库迁移工具（可选）

建议使用 Flyway 或 Liquibase 进行数据库版本管理：

```xml
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
```

### 3. 配置 Docker（可选）

创建 `docker-compose.yml` 一键启动前后端 + 数据库：

```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: kplus
    ports:
      - '3306:3306'

  backend:
    build: ./server
    ports:
      - '8091:8091'
    depends_on:
      - mysql

  frontend:
    build: ./packages/kplus-admin
    ports:
      - '80:80'
    depends_on:
      - backend
```

### 4. 配置 CI/CD（可选）

创建 GitHub Actions 或 GitLab CI 配置文件，自动化测试和部署。

---

## 📞 获取帮助

如果在迁移过程中遇到问题，可以：

1. 检查本文档的"常见问题排查"部分
2. 查看后端启动日志，定位具体错误
3. 检查前端浏览器控制台，查看 API 调用错误
4. 使用 AI 编程助手（Claude Code、Cursor、GitHub Copilot）辅助排查

---

**祝你迁移顺利！🎉**
