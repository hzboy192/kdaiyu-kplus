<script setup>
import { ref } from 'vue'
import { ElCard, ElButton, ElAvatar, ElTag, ElIcon, ElSelect, ElOption, ElSwitch, ElDialog, ElSlider, ElAlert } from 'element-plus'
import { Star, TrendCharts, User, Check, Plus, Lock } from '@element-plus/icons-vue'

const sortBy = ref('profit')
const showSubscribeDialog = ref(false)
const selectedTrader = ref < any > null
const copyRatio = ref(50)

const traders = ref([
  {
    id: 1,
    name: '股神在世',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=1',
    level: '大师',
    followers: 2856,
    winRate: 85.2,
    monthlyProfit: 256800,
    monthlyReturn: 28.5,
    maxDrawdown: -5.2,
    tradingDays: 365,
    description: '专注趋势交易，擅长捕捉大行情',
    subscribed: false,
    fee: 20
  },
  {
    id: 2,
    name: '交易小王子',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=2',
    level: '专业',
    followers: 1568,
    winRate: 78.5,
    monthlyProfit: 128500,
    monthlyReturn: 18.2,
    maxDrawdown: -8.5,
    tradingDays: 280,
    description: '量价结合，稳健操作',
    subscribed: true,
    fee: 15
  },
  {
    id: 3,
    name: '量化操盘手',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=3',
    level: '专业',
    followers: 986,
    winRate: 72.3,
    monthlyProfit: 98200,
    monthlyReturn: 15.8,
    maxDrawdown: -6.8,
    tradingDays: 220,
    description: '程序化交易，纪律执行',
    subscribed: false,
    fee: 12
  }
])

const openSubscribe = (trader) => {
  selectedTrader.value = trader
  showSubscribeDialog.value = true
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-ink">跟单大厅</h2>
        <p class="text-ink-faint text-sm mt-1">订阅高手策略，自动跟随交易</p>
      </div>
      <div class="flex gap-3">
        <el-select v-model="sortBy" class="!w-36">
          <el-option label="按收益排序" value="profit" />
          <el-option label="按胜率排序" value="winRate" />
          <el-option label="按粉丝排序" value="followers" />
        </el-select>
      </div>
    </div>

    <!-- My Subscriptions -->
    <div class="bg-primary-500/10 rounded-md p-5 border border-primary-500/30">
      <div class="flex items-center justify-between mb-4">
        <h3 class="font-semibold text-ink">我的订阅</h3>
        <el-tag type="primary" effect="light">已订阅 1 位交易员</el-tag>
      </div>
      <div class="flex items-center gap-4 bg-panel-raised rounded p-4">
        <el-avatar src="https://api.dicebear.com/7.x/avataaars/svg?seed=2" :size="56" />
        <div class="flex-1">
          <div class="flex items-center gap-2">
            <span class="font-semibold text-ink">交易小王子</span>
            <el-tag type="warning" size="small">专业</el-tag>
          </div>
          <p class="text-sm text-ink-faint mt-1">跟单比例: 50% | 本月跟单收益: +¥2,450</p>
        </div>
        <div class="text-right">
          <p class="text-sm text-ink-faint">今日信号</p>
          <p class="font-semibold text-primary-400">3 笔交易</p>
        </div>
        <el-button type="primary" link>管理</el-button>
      </div>
    </div>

    <!-- Trader Cards -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div
        v-for="trader in traders"
        :key="trader.id"
        class="bg-panel rounded-md border border-line p-6 hover:border-white/20 transition-all"
      >
        <!-- Header -->
        <div class="flex items-start gap-4 mb-4">
          <el-avatar :src="trader.avatar" :size="64" class="border-2 border-primary-500/30" />
          <div class="flex-1">
            <div class="flex items-center gap-2">
              <h3 class="font-bold text-lg text-ink">{{ trader.name }}</h3>
              <el-tag :type="trader.level === '大师' ? 'danger' : 'warning'" size="small">
                {{ trader.level }}
              </el-tag>
              <el-icon v-if="trader.subscribed" class="text-primary-400"><Check /></el-icon>
            </div>
            <p class="text-sm text-ink-faint mt-1">{{ trader.description }}</p>
            <div class="flex items-center gap-4 mt-2 text-xs text-ink-faint">
              <span
                ><el-icon><User /></el-icon> {{ trader.followers }} 粉丝</span
              >
              <span>交易 {{ trader.tradingDays }} 天</span>
            </div>
          </div>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-4 gap-3 p-4 bg-white/[0.03] rounded mb-4">
          <div class="text-center">
            <p class="text-xs text-ink-faint">胜率</p>
            <p class="font-bold text-down font-mono tabular-nums">{{ trader.winRate }}%</p>
          </div>
          <div class="text-center">
            <p class="text-xs text-ink-faint">月收益</p>
            <p class="font-bold text-up font-mono tabular-nums">+{{ trader.monthlyReturn }}%</p>
          </div>
          <div class="text-center">
            <p class="text-xs text-ink-faint">最大回撤</p>
            <p class="font-bold text-ink-secondary font-mono tabular-nums">{{ trader.maxDrawdown }}%</p>
          </div>
          <div class="text-center">
            <p class="text-xs text-ink-faint">月收益额</p>
            <p class="font-bold text-ink font-mono tabular-nums">¥{{ (trader.monthlyProfit / 10000).toFixed(1) }}万</p>
          </div>
        </div>

        <!-- Actions -->
        <div class="flex items-center justify-between">
          <span class="text-sm text-ink-faint">
            订阅费: <span class="font-semibold text-ink font-mono tabular-nums">¥{{ trader.fee }}/月</span>
          </span>
          <div class="flex gap-2">
            <el-button size="small">查看详情</el-button>
            <el-button v-if="!trader.subscribed" type="primary" size="small" @click="openSubscribe(trader)">
              <el-icon class="mr-1"><Plus /></el-icon>
              订阅跟单
            </el-button>
            <el-button v-else type="success" size="small" disabled>
              <el-icon class="mr-1"><Check /></el-icon>
              已订阅
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- VIP Notice -->
    <el-alert type="info" :closable="false" show-icon class="!rounded">
      <template #title>
        <div class="flex items-center gap-2">
          <el-icon><Lock /></el-icon>
          <span>跟单大厅为VIP专属功能</span>
        </div>
      </template>
      <div class="mt-1">
        免费用户仅可查看交易员信息，升级VIP后可订阅跟单服务。
        <el-button type="primary" link class="!p-0 !ml-2">了解更多</el-button>
      </div>
    </el-alert>

    <!-- Subscribe Dialog -->
    <el-dialog v-model="showSubscribeDialog" title="订阅跟单" width="480" :close-on-click-modal="false">
      <div v-if="selectedTrader" class="space-y-6">
        <div class="flex items-center gap-4 p-4 bg-white/[0.03] rounded">
          <el-avatar :src="selectedTrader.avatar" :size="48" />
          <div>
            <p class="font-semibold text-ink">{{ selectedTrader.name }}</p>
            <p class="text-sm text-ink-faint">胜率 {{ selectedTrader.winRate }}% | 月收益 +{{ selectedTrader.monthlyReturn }}%</p>
          </div>
        </div>

        <div>
          <label class="block text-sm font-medium text-ink-secondary mb-3">跟单比例</label>
          <el-slider v-model="copyRatio" :min="10" :max="100" :step="10" show-stops />
          <p class="text-sm text-ink-faint mt-2">
            当交易员开仓时，您将以 <span class="font-semibold">{{ copyRatio }}%</span> 的比例跟随交易
          </p>
        </div>

        <div class="p-4 bg-white/[0.04] rounded border border-line">
          <p class="text-sm text-warning-500">
            <span class="font-semibold">风险提示：</span>跟单交易存在风险，历史收益不代表未来收益。请根据自身风险承受能力合理配置。
          </p>
        </div>
      </div>
      <template #footer>
        <el-button @click="showSubscribeDialog = false">取消</el-button>
        <el-button type="primary" @click="showSubscribeDialog = false"> 确认订阅 (¥{{ selectedTrader?.fee }}/月) </el-button>
      </template>
    </el-dialog>
  </div>
</template>
