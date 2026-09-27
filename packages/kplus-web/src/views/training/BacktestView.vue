<script setup>
import { ref } from 'vue'
import { ElCard, ElButton, ElDatePicker, ElSelect, ElOption, ElProgress, ElIcon, ElTable, ElTableColumn, ElTag } from 'element-plus'
import { VideoPlay, Clock, TrendCharts, DataAnalysis } from '@element-plus/icons-vue'

const dateRange = (ref < [Date, Date]) | (null > null)
const selectedIndex = ref('000001')
const isRunning = ref(false)
const progress = ref(0)

const backtestResults = ref([
  { id: 1, date: '2024-01-15', action: '买入', price: 3045.2, profit: 1200, rate: 1.88 },
  { id: 2, date: '2024-01-18', action: '卖出', price: 3102.5, profit: -450, rate: -0.45 },
  { id: 3, date: '2024-01-22', action: '买入', price: 3080.8, profit: 860, rate: 0.91 }
])

const stats = [
  { label: '总收益', value: '¥12,580', change: '+15.2%' },
  { label: '胜率', value: '68.5%', change: '+5.3%' },
  { label: '最大回撤', value: '-8.2%', change: '-2.1%' },
  { label: '夏普比率', value: '1.85', change: '+0.12' }
]

const startBacktest = () => {
  isRunning.value = true
  progress.value = 0
  const interval = setInterval(() => {
    progress.value += 10
    if (progress.value >= 100) {
      clearInterval(interval)
      isRunning.value = false
    }
  }, 300)
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div>
      <h2 class="text-xl font-bold text-ink">历史回测</h2>
      <p class="text-ink-faint text-sm mt-1">对历史数据进行策略验证和分析</p>
    </div>

    <!-- Settings Panel -->
    <div class="bg-panel rounded-md border border-line p-6">
      <h3 class="text-lg font-semibold text-ink mb-4">回测设置</h3>
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
          <label class="block text-sm font-medium text-ink-secondary mb-2">交易品种</label>
          <el-select v-model="selectedIndex" class="!w-full">
            <el-option label="上证指数 (000001)" value="000001" />
            <el-option label="深证成指 (399001)" value="399001" />
            <el-option label="创业板指 (399006)" value="399006" />
            <el-option label="科创50 (000688)" value="000688" />
          </el-select>
        </div>
        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-ink-secondary mb-2">回测区间</label>
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            class="!w-full"
          />
        </div>
        <div class="flex items-end">
          <el-button type="primary" class="!w-full !rounded" :loading="isRunning" @click="startBacktest">
            <el-icon class="mr-1"><VideoPlay /></el-icon>
            开始回测
          </el-button>
        </div>
      </div>

      <!-- Progress -->
      <div v-if="isRunning" class="mt-6">
        <div class="flex items-center justify-between mb-2">
          <span class="text-sm text-ink-secondary">回测进度</span>
          <span class="text-sm font-medium text-primary-400">{{ progress }}%</span>
        </div>
        <el-progress :percentage="progress" :show-text="false" />
      </div>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div v-for="stat in stats" :key="stat.label" class="bg-panel rounded p-4 border border-line">
        <p class="text-sm text-ink-faint">{{ stat.label }}</p>
        <p class="text-xl font-bold text-ink mt-1 font-mono tabular-nums">{{ stat.value }}</p>
        <p class="text-xs mt-1" :class="stat.change.startsWith('+') ? 'text-down' : 'text-up'">
          {{ stat.change }}
        </p>
      </div>
    </div>

    <!-- Results Table -->
    <div class="bg-panel rounded-md border border-line overflow-hidden">
      <div class="px-6 py-4 border-b border-line">
        <h3 class="font-semibold text-ink">回测交易记录</h3>
      </div>
      <el-table :data="backtestResults" style="width: 100%">
        <el-table-column prop="date" label="日期" width="120" />
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <el-tag :type="row.action === '买入' ? 'danger' : 'success'" size="small">
              {{ row.action }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="price" label="价格" width="120">
          <template #default="{ row }"
            ><span class="font-mono tabular-nums">{{ row.price.toFixed(2) }}</span></template
          >
        </el-table-column>
        <el-table-column label="盈亏" width="120">
          <template #default="{ row }">
            <span class="font-mono tabular-nums" :class="row.profit >= 0 ? 'text-up' : 'text-down'">
              {{ row.profit >= 0 ? '+' : '' }}¥{{ row.profit }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="收益率">
          <template #default="{ row }">
            <span class="font-mono tabular-nums" :class="row.rate >= 0 ? 'text-up' : 'text-down'">
              {{ row.rate >= 0 ? '+' : '' }}{{ row.rate }}%
            </span>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>
