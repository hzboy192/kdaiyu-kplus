<script setup>
import { ref } from 'vue'
import { ElButton, ElCard, ElTag, ElIcon, ElDialog, ElInput, ElSelect, ElOption, ElAlert } from 'element-plus'
import { Plus, Edit, Delete, VideoPlay, Document, Lock } from '@element-plus/icons-vue'

const strategies = ref([
  {
    id: 1,
    name: '双均线交叉策略',
    description: '使用5日和20日均线交叉信号进行买卖',
    status: 'active',
    winRate: 68.5,
    trades: 45,
    lastRun: '2024-01-15'
  },
  {
    id: 2,
    name: 'MACD背离策略',
    description: '基于MACD指标背离信号的交易策略',
    status: 'draft',
    winRate: 0,
    trades: 0,
    lastRun: '-'
  },
  {
    id: 3,
    name: '突破追踪策略',
    description: '突破前高后追踪止盈止损的趋势跟踪策略',
    status: 'active',
    winRate: 72.3,
    trades: 128,
    lastRun: '2024-01-14'
  }
])

const showEditor = ref(false)
const isVip = ref(false)

const sampleCode = `// 双均线交叉策略示例
function strategy(data) {
  const ma5 = calculateMA(data, 5);
  const ma20 = calculateMA(data, 20);
  
  // 金叉买入
  if (ma5 > ma20 && prevMA5 <= prevMA20) {
    return { action: 'BUY', reason: '金叉信号' };
  }
  
  // 死叉卖出
  if (ma5 < ma20 && prevMA5 >= prevMA20) {
    return { action: 'SELL', reason: '死叉信号' };
  }
  
  return { action: 'HOLD' };
}`
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-gray-800">策略编辑器</h2>
        <p class="text-gray-500 text-sm mt-1">编写和管理自动化交易策略</p>
      </div>
      <el-button 
        type="primary" 
        @click="showEditor = true"
        :disabled="!isVip"
        class="!rounded-xl"
      >
        <el-icon class="mr-1"><Plus /></el-icon>
        新建策略
      </el-button>
    </div>

    <!-- VIP Notice -->
    <el-alert
      v-if="!isVip"
      type="warning"
      :closable="false"
      show-icon
      class="!rounded-xl"
    >
      <template #title>
        <div class="flex items-center gap-2">
          <el-icon><Lock /></el-icon>
          <span>策略编辑器为VIP专属功能</span>
        </div>
      </template>
      <div class="mt-1">
        升级到专业版或大师版即可解锁策略编辑器，编写自动化交易策略。
        <el-button type="warning" link class="!p-0 !ml-2">立即升级</el-button>
      </div>
    </el-alert>

    <!-- Strategy List -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div
        v-for="strategy in strategies"
        :key="strategy.id"
        class="bg-white rounded-2xl border border-gray-100 p-5 hover:shadow-md hover:border-gray-200 transition-all"
      >
        <div class="flex items-start justify-between mb-3">
          <div>
            <h3 class="font-semibold text-gray-800">{{ strategy.name }}</h3>
            <el-tag 
              :type="strategy.status === 'active' ? 'success' : 'info'" 
              size="small"
              class="mt-1"
            >
              {{ strategy.status === 'active' ? '运行中' : '草稿' }}
            </el-tag>
          </div>
          <div class="flex gap-1">
            <el-button text circle size="small">
              <el-icon><Edit /></el-icon>
            </el-button>
            <el-button text circle size="small" type="danger">
              <el-icon><Delete /></el-icon>
            </el-button>
          </div>
        </div>
        
        <p class="text-sm text-gray-500 mb-4 line-clamp-2">{{ strategy.description }}</p>
        
        <div class="grid grid-cols-3 gap-2 text-center py-3 bg-gray-50 rounded-xl mb-4">
          <div>
            <p class="text-xs text-gray-500">胜率</p>
            <p class="font-semibold text-gray-800">{{ strategy.winRate }}%</p>
          </div>
          <div>
            <p class="text-xs text-gray-500">交易次数</p>
            <p class="font-semibold text-gray-800">{{ strategy.trades }}</p>
          </div>
          <div>
            <p class="text-xs text-gray-500">最近运行</p>
            <p class="font-semibold text-gray-800 text-xs">{{ strategy.lastRun }}</p>
          </div>
        </div>

        <div class="flex gap-2">
          <el-button type="primary" size="small" class="flex-1 !rounded-lg">
            <el-icon class="mr-1"><VideoPlay /></el-icon>
            回测
          </el-button>
          <el-button size="small" class="flex-1 !rounded-lg">
            <el-icon class="mr-1"><Document /></el-icon>
            详情
          </el-button>
        </div>
      </div>

      <!-- Create New Card -->
      <div
        @click="isVip && (showEditor = true)"
        class="border-2 border-dashed rounded-2xl p-5 flex flex-col items-center justify-center text-gray-400 transition-all min-h-[240px]"
        :class="isVip 
          ? 'border-gray-300 hover:border-primary-400 hover:text-primary-600 cursor-pointer' 
          : 'border-gray-200 cursor-not-allowed opacity-60'"
      >
        <el-icon :size="48" class="mb-2">
          <Lock v-if="!isVip" />
          <Plus v-else />
        </el-icon>
        <span class="font-medium">{{ isVip ? '创建新策略' : 'VIP专属功能' }}</span>
        <span class="text-xs mt-1">{{ isVip ? '使用策略编辑器' : '升级解锁' }}</span>
      </div>
    </div>

    <!-- Code Preview -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
        <h3 class="font-semibold text-gray-800">策略代码示例</h3>
        <el-tag type="info" size="small">只读预览</el-tag>
      </div>
      <pre class="p-6 bg-gray-900 text-gray-100 text-sm overflow-x-auto"><code>{{ sampleCode }}</code></pre>
    </div>
  </div>
</template>
