<script setup>
import { ref } from 'vue'
import { ElCard, ElSelect, ElOption, ElProgress, ElIcon } from 'element-plus'
import { TrendCharts, Aim, Warning, ArrowUp, ArrowDown } from '@element-plus/icons-vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { BarChart, LineChart } from 'echarts/charts'
import { GridComponent, TooltipComponent, LegendComponent } from 'echarts/components'

use([CanvasRenderer, BarChart, LineChart, GridComponent, TooltipComponent, LegendComponent])

const currentAccount = ref('all')
const timeRange = ref('month')

const metrics = [
  { label: '夏普比率', value: '1.85', desc: '风险调整后收益', status: 'good' },
  { label: '最大回撤', value: '-8.2%', desc: '最大亏损幅度', status: 'warning' },
  { label: '盈亏比', value: '2.35', desc: '平均盈利/平均亏损', status: 'good' },
  { label: '日均收益', value: '¥856', desc: '平均每日收益', status: 'good' }
]

const monthlyData = ref({
  tooltip: { trigger: 'axis' },
  grid: { left: '3%', right: '4%', bottom: '3%', top: '15%', containLabel: true },
  xAxis: {
    type: 'category',
    data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    axisLine: { lineStyle: { color: '#e2e8f0' } },
    axisLabel: { color: '#64748b' }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false },
    splitLine: { lineStyle: { color: '#f1f5f9' } },
    axisLabel: { color: '#64748b' }
  },
  series: [{
    data: [2800, 3200, -1500, 4500, 5200, 3800, 6100, 4200, 5800, 7200, 6500, 8200],
    type: 'bar',
    itemStyle: {
      color: (params) => params.value >= 0 ? '#ef4444' : '#10b981',
      borderRadius: [4, 4, 0, 0]
    }
  }]
})

const weekdayData = ref({
  tooltip: { trigger: 'axis' },
  grid: { left: '3%', right: '4%', bottom: '3%', top: '10%', containLabel: true },
  xAxis: {
    type: 'category',
    data: ['周一', '周二', '周三', '周四', '周五'],
    axisLine: { lineStyle: { color: '#e2e8f0' } },
    axisLabel: { color: '#64748b' }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false },
    splitLine: { lineStyle: { color: '#f1f5f9' } },
    axisLabel: { color: '#64748b', formatter: '{value}%' }
  },
  series: [{
    data: [72, 65, 58, 68, 75],
    type: 'bar',
    itemStyle: { color: '#4f46e5', borderRadius: [4, 4, 0, 0] }
  }]
})

const tradingHabits = [
  { label: '持仓时间', value: '平均 2.5 小时', progress: 65 },
  { label: '交易频率', value: '日均 8.5 次', progress: 78 },
  { label: '止损执行率', value: '92%', progress: 92 },
  { label: '计划执行率', value: '85%', progress: 85 }
]
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-gray-800">收益分析</h2>
        <p class="text-gray-500 text-sm mt-1">多维度数据分析，深入了解交易表现</p>
      </div>
      <div class="flex gap-3">
        <el-select v-model="currentAccount" class="!w-36">
          <el-option label="全部账户" value="all" />
          <el-option label="默认账户" value="default" />
          <el-option label="策略测试" value="strategy" />
        </el-select>
        <el-select v-model="timeRange" class="!w-32">
          <el-option label="近一周" value="week" />
          <el-option label="近一月" value="month" />
          <el-option label="近三月" value="quarter" />
          <el-option label="近一年" value="year" />
        </el-select>
      </div>
    </div>

    <!-- Key Metrics -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
      <div 
        v-for="metric in metrics" 
        :key="metric.label"
        class="bg-white rounded-xl p-5 border border-gray-100"
      >
        <div class="flex items-center justify-between mb-2">
          <span class="text-sm text-gray-500">{{ metric.label }}</span>
          <div 
            class="w-8 h-8 rounded-lg flex items-center justify-center"
            :class="metric.status === 'good' ? 'bg-green-100 text-green-600' : 'bg-orange-100 text-orange-600'"
          >
            <el-icon :size="16">
              <ArrowUp v-if="metric.status === 'good'" />
              <Warning v-else />
            </el-icon>
          </div>
        </div>
        <p class="text-2xl font-bold text-gray-800">{{ metric.value }}</p>
        <p class="text-xs text-gray-400 mt-1">{{ metric.desc }}</p>
      </div>
    </div>

    <!-- Charts -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Monthly P&L -->
      <div class="bg-white rounded-2xl p-6 border border-gray-100">
        <h3 class="font-semibold text-gray-800 mb-4">月度盈亏分布</h3>
        <v-chart :option="monthlyData" style="height: 280px" autoresize />
      </div>

      <!-- Weekday Win Rate -->
      <div class="bg-white rounded-2xl p-6 border border-gray-100">
        <h3 class="font-semibold text-gray-800 mb-4">周内胜率分布</h3>
        <v-chart :option="weekdayData" style="height: 280px" autoresize />
      </div>
    </div>

    <!-- Trading Habits -->
    <div class="bg-white rounded-2xl p-6 border border-gray-100">
      <h3 class="font-semibold text-gray-800 mb-6">交易习惯分析</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div 
          v-for="habit in tradingHabits" 
          :key="habit.label"
          class="space-y-2"
        >
          <div class="flex justify-between items-center">
            <span class="text-sm text-gray-600">{{ habit.label }}</span>
            <span class="text-sm font-semibold text-gray-800">{{ habit.value }}</span>
          </div>
          <el-progress 
            :percentage="habit.progress" 
            :show-text="false"
            :stroke-width="8"
            :color="habit.progress >= 80 ? '#10b981' : habit.progress >= 60 ? '#4f46e5' : '#f59e0b'"
          />
        </div>
      </div>
    </div>

    <!-- Insights -->
    <div class="bg-gradient-to-r from-primary-50 to-purple-50 rounded-2xl p-6 border border-primary-100">
      <h3 class="font-semibold text-gray-800 mb-4 flex items-center gap-2">
        <el-icon class="text-primary-600"><TrendCharts /></el-icon>
        AI 分析洞察
      </h3>
      <div class="space-y-3 text-sm text-gray-700">
        <p>1. 您在<span class="font-semibold text-primary-600">周五</span>的交易胜率最高(75%)，建议重点把握周五的交易机会。</p>
        <p>2. 您的<span class="font-semibold text-green-600">止损执行率(92%)</span>表现优秀，继续保持纪律性交易。</p>
        <p>3. 近期<span class="font-semibold text-orange-600">最大回撤(-8.2%)</span>略高于历史平均，建议适当降低仓位。</p>
        <p>4. <span class="font-semibold text-primary-600">盈亏比2.35</span>处于健康水平，可以适度增加交易频率。</p>
      </div>
    </div>
  </div>
</template>
