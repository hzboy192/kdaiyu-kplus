# 前端架构规则

> Kplus 前端开发规范与架构说明

## Monorepo 结构

项目采用 pnpm workspace 进行 monorepo 管理：

```
packages/
├── kplus-web/          # 业务前端 - K线训练
├── kplus-admin/        # 管理后台
└── components/         # 共享组件库 (kplus-components)
```

### 包依赖关系

```
kplus-admin ──依赖──> kplus-components
kplus-web ──依赖──> kplus-components
```

## 目录结构规范

### kplus-web 目录结构

```
kplus-web/src/
├── api/                 # API请求模块
├── assets/              # 静态资源
├── components/          # 业务组件
│   ├── chart/          # K线图表组件
│   │   ├── ChartPlusCore.js    # 图表核心逻辑
│   │   ├── TrainCore.js        # 训练核心逻辑
│   │   ├── customDatafeed.js   # 数据源适配
│   │   ├── default_style.js    # 图表样式
│   │   ├── GoodsList.vue       # 商品列表
│   │   ├── PeriodList.vue      # 周期列表
│   │   ├── ToolsBar.vue        # 工具栏
│   │   ├── UserInfo.vue        # 用户信息
│   │   ├── TrainSettingDialog.vue # 训练设置弹窗
│   │   └── TrainScoreDialog.vue   # 训练成绩弹窗
│   ├── train/          # 训练相关组件
│   ├── user/           # 用户相关组件
│   ├── captcha/        # 验证码组件
│   └── home/           # 首页组件
├── data/                # 数据请求模块
├── router/              # 路由配置
│   ├── index.js        # 路由定义
│   └── permist.js      # 权限控制
├── stores/              # Pinia状态管理
├── utils/               # 工具函数
│   ├── mitt.js         # 事件总线
│   ├── date-utils.js   # 日期处理
├── views/               # 页面视图
│   ├── klinePlus.vue   # K线训练主页面
│   ├── klinepro.vue    # K线专业版
│   ├── KlineView.vue   # K线视图
│   ├── loginView.vue   # 登录页
│   ├── registerView.vue # 注册页
│   ├── UserCenter.vue  # 用户中心
│   └── webMqtt.vue     # MQTT通信
└── App.vue              # 应用入口
```

### kplus-admin 目录结构

```
kplus-admin/src/
├── api/                 # API请求模块
├── assets/              # 静态资源
├── components/          # 业务组件
├── directive/           # 自定义指令
├── layout/              # 布局组件
├── plugins/             # 插件配置
├── router/              # 路由配置
├── store/               # Vuex状态管理
├── utils/               # 工具函数
├── views/               # 页面视图
│   ├── login.vue       # 登录页
│   ├── register.vue    # 注册页
│   ├── index.vue       # 主页
│   ├── system/         # 系统管理
│   ├── monitor/        # 监控管理
│   └── tool/           # 工具页面
└── App.vue              # 应用入口
```

## 路径别名配置

### vite.config.js 别名

```javascript
resolve: {
  alias: {
    '@': fileURLToPath(new URL('./src', import.meta.url)),
    '@c': fileURLToPath(new URL('./src/components', import.meta.url)),
    '@d': fileURLToPath(new URL('./src/data', import.meta.url)),
    '@r': fileURLToPath(new URL('./src/router', import.meta.url)),
    '@s': fileURLToPath(new URL('./src/stores', import.meta.url)),
    '@u': fileURLToPath(new URL('./src/utils', import.meta.url))
  }
}
```

### 使用示例

```javascript
import GoodsList from '@c/chart/GoodsList.vue'
import { getBarData } from '@d/kline_pro_data'
import emit from '@/utils/mitt'
```

## 组件开发规范

### 1. 组件命名

- **PascalCase**：单文件组件使用 PascalCase 呃名
- **语义化**：组件名应清晰表达其功能
- **目录归类**：相关组件放在同一目录下

### 2. 组件结构

```vue
<script setup>
// 1. 导入依赖
import { ref, reactive, onMounted, computed } from 'vue'

// 2. 定义props和emits
const props = defineProps({
  // props定义
})

const emit = defineEmits(['event-name'])

// 3. 定义响应式状态
const state = reactive({})

// 4. 定义计算属性
const computedValue = computed(() => {})

// 5. 定义方法
const handleClick = () => {}

// 6. 生命周期钩子
onMounted(() => {})
</script>

<template>
  <!-- 模板内容 -->
</template>

<style scoped>
/* 样式内容 */
</style>
```

### 3. 状态管理

#### Pinia Store 规范

```javascript
// stores/trainStore.js
import { defineStore } from 'pinia'

export const useTrainStore = defineStore('train', {
  state: () => ({
    trainId: null,
    status: 0,
    holdingNum: 0
  }),
  
  getters: {
    isTraining: (state) => state.status === 1
  },
  
  actions: {
    startTrain(config) {
      this.status = 1
      this.trainId = config.traId
    }
  }
})
```

### 4. 事件通信

项目使用 mitt 作为事件总线：

```javascript
// utils/mitt.js
import mitt from 'mitt'
const emit = mitt()

// 发送事件
emit.emit('doOpenTrade', tradeList)

// 监听事件
emit.on('doOpenTrade', (tradeList) => {
  // 处理逻辑
})
```

**常用事件列表：**

| 事件名 | 参数 | 说明 |
|--------|------|------|
| doOpenTrade | tradeList | 开仓交易 |
| doCloseTrade | tradeList | 平仓交易 |
| onTrainSummary | summary | 训练汇总数据 |
| changeTradeNum | num | 修改交易手数 |
| trainFinish | trainOption | 训练结束 |

## API 请求规范

### 数据模块结构

```
data/
├── kline_pro_data.js    # K线数据请求
├── train_trade_data.js  # 训练交易数据请求
├── fund_account.js      # 资金账户请求
└── goods_info.js        # 商品信息请求
```

### 请求示例

```javascript
// data/train_trade_data.js
import request from '@/utils/request'

export function saveTrainData(params) {
  return request({
    url: '/api/userTrain',
    method: 'post',
    data: params
  })
}

export function openTrainDtl(data) {
  return request({
    url: '/api/userTrainDtl',
    method: 'post',
    data: data
  })
}

export function closeTrainDtl(list) {
  return request({
    url: '/api/userTrainDtl/close',
    method: 'post',
    data: list
  })
}
```

## Vite 配置要点

### 开发服务器代理

```javascript
server: {
  port: 80,
  proxy: {
    '/api': {
      target: env.VITE_APP_API_BASE,
      changeOrigin: true
    }
  }
}
```

### 自动导入配置

```javascript
autoImport({
  dts: './assets/types/auto-imports.d.ts',
  imports: ['vue', 'vue-router'],
  resolvers: [
    IconsResolver({ prefix: 'Icon' })
  ]
})
```

## 样式规范

### CSS 变量

项目使用 CSS 变量管理主题：

```css
/* 暗色主题 */
.dark {
  --kline-border-color: #2c3e50;
  --el-bg-color: #1a1a1a;
}

/* 亮色主题 */
.light {
  --kline-border-color: #ebeef5;
  --el-bg-color: #ffffff;
}
```

### scoped 样式

组件样式使用 `scoped` 防止样式污染：

```vue
<style scoped>
.chart-container {
  width: 100%;
  background: var(--el-bg-color);
}
</style>
```

## 图表集成

### klinecharts 使用

```javascript
// ChartPlusCore.js
import { init, dispose } from 'klinecharts'

// 初始化图表
const chart = init('chart', {
  styles: default_style
})

// 应用数据
chart.applyNewData(dataList)

// 更新数据
chart.updateData(newData)
```

### 数据源适配

```javascript
// customDatafeed.js
export default {
  history: (callback) => {
    // 获取历史数据
  },
  realtime: (callback) => {
    // 获取实时数据
  }
}
```

## 开发注意事项

1. **路由守卫**：所有需要登录的页面应在路由配置中添加权限检查
2. **错误处理**：API请求应统一处理错误响应
3. **性能优化**：
   - 大列表使用虚拟滚动
   - 图表数据分批加载
   - 组件按需加载
4. **主题切换**：通过 `document.documentElement.setAttribute('class', 'dark/light')` 切换主题