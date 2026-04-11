<script setup>
import { ref, onMounted } from 'vue'
import { ElCard, ElSelect, ElOption, ElIcon, ElProgress, ElTag } from 'element-plus'
import { Wallet, Coin, Aim, Refresh, ArrowUp, ArrowDown } from '@element-plus/icons-vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, PieChart, BarChart } from 'echarts/charts'
import { GridComponent, TooltipComponent, LegendComponent } from 'echarts/components'

use([CanvasRenderer, LineChart, PieChart, BarChart, GridComponent, TooltipComponent, LegendComponent])

const currentAccount = ref('all')

const stats = [
  { 
    title: '总收益', 
    value: '25,800', 
    unit: '¥', 
    change: 20.5, 
    icon: Wallet, 
    gradient: 'stat-card-blue',
    iconBg: 'bg-blue-500'
  },
  { 
    title: '今日收益', 
    value: '1,200', 
    unit: '¥', 
    change: 15.2, 
    icon: Coin, 
    gradient: 'stat-card-green',
    iconBg: 'bg-green-500'
  },
  { 
    title: '胜率', 
    value: '65.5', 
    unit: '%', 
    change: 5.3, 
    icon: Aim, 
    gradient: 'stat-card-purple',
    iconBg: 'bg-purple-500'
  },
  { 
    title: '交易次数', 
    value: '128', 
    unit: '次', 
    change: 12.8, 
    icon: Refresh, 
    gradient: 'stat-card-orange',
    iconBg: 'bg-orange-500'
  }
]

const lineChartOption = ref({
  tooltip: {
    trigger: 'axis',
    backgroundColor: 'rgba(255,255,255,0.95)',
    borderColor: '#e2e8f0',
    textStyle: { color: '#1e293b' }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    top: '10%',
    containLabel: true
  },
  xAxis: {
    type: 'category',
    boundaryGap: false,
    data: ['1日', '5日', '10日', '15日', '20日', '25日', '30日'],
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
    data: [2500, 4200, 3800, 6500, 5800, 8200, 9500],
    type: 'line',
    smooth: true,
    symbol: 'circle',
    symbolSize: 8,
    lineStyle: { width: 3, color: '#4f46e5' },
    areaStyle: {
      color: {
        type: 'linear',
        x: 0, y: 0, x2: 0, y2: 1,
        colorStops: [
          { offset: 0, color: 'rgba(79,70,229,0.3)' },
          { offset: 1, color: 'rgba(79,70,229,0.05)' }
        ]
      }
    },
    itemStyle: { color: '#4f46e5' }
  }]
})

const pieChartOption = ref({
  tooltip: {
    trigger: 'item',
    formatter: '{b}: {c}%'
  },
  legend: {
    orient: 'vertical',
    right: '5%',
    top: 'center',
    textStyle: { color: '#64748b' }
  },
  series: [{
    type: 'pie',
    radius: ['45%', '70%'],
    center: ['35%', '50%'],
    avoidLabelOverlap: false,
    itemStyle: {
      borderRadius: 8,
      borderColor: '#fff',
      borderWidth: 2
    },
    label: { show: false },
    data: [
      { value: 40, name: '上证指数', itemStyle: { color: '#3b82f6' } },
      { value: 30, name: '深证成指', itemStyle: { color: '#10b981' } },
      { value: 20, name: '创业板指', itemStyle: { color: '#f59e0b' } },
      { value: 10, name: '科创50', itemStyle: { color: '#ef4444' } }
    ]
  }]
})

const recentTrades = [
  { date: '01-15', symbol: '上证指数', direction: 'buy', profit: 1200, rate: 1.88 },
  { date: '01-14', symbol: '创业板指', direction: 'sell', profit: 860, rate: 0.91 },
  { date: '01-13', symbol: '科创50', direction: 'buy', profit: -720, rate: -0.81 },
  { date: '01-12', symbol: '深证成指', direction: 'sell', profit: 450, rate: 0.55 }
]
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-gray-800">数据总览</h2>
        <p class="text-gray-500 text-sm mt-1">个人账户核心数据指标展示</p>
      </div>
      <el-select v-model="currentAccount" class="!w-40">
        <el-option label="全部账户" value="all" />
        <el-option label="默认账户" value="default" />
        <el-option label="策略测试账户" value="strategy" />
      </el-select>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
      <div
        v-for="stat in stats"
        :key="stat.title"
        class="p-5 rounded-2xl card-hover"
        :class="stat.gradient"
      >
        <div class="flex items-center justify-between mb-3">
          <span class="text-gray-600 text-sm font-medium">{{ stat.title }}</span>
          <div 
            class="w-9 h-9 rounded-lg flex items-center justify-center text-white"
            :class="stat.iconBg"
          >
            <el-icon :size="18"><component :is="stat.icon" /></el-icon>
          </div>
        </div>
        <div class="text-2xl font-bold text-gray-800">
          <span v-if="stat.unit === '¥'">¥</span>{{ stat.value }}<span v-if="stat.unit !== '¥'" class="text-sm font-normal text-gray-500 ml-1">{{ stat.unit }}</span>
        </div>
        <div class="flex items-center gap-1 mt-2 text-sm">
          <el-icon :size="14" :class="stat.change >= 0 ? 'text-green-600' : 'text-red-600'">
            <ArrowUp v-if="stat.change >= 0" />
            <ArrowDown v-else />
          </el-icon>
          <span :class="stat.change >= 0 ? 'text-green-600' : 'text-red-600'">
            {{ stat.change >= 0 ? '+' : '' }}{{ stat.change }}%
          </span>
          <span class="text-gray-400 text-xs ml-1">较上月</span>
        </div>
      </div>
    </div>

    <!-- Charts -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Line Chart -->
      <div class="lg:col-span-2 bg-white rounded-2xl p-6 border border-gray-100">
        <h3 class="font-semibold text-gray-800 mb-4">近30天收益曲线</h3>
        <v-chart :option="lineChartOption" style="height: 280px" autoresize />
      </div>

      <!-- Pie Chart -->
      <div class="bg-white rounded-2xl p-6 border border-gray-100">
        <h3 class="font-semibold text-gray-800 mb-4">交易品种分布</h3>
        <v-chart :option="pieChartOption" style="height: 280px" autoresize />
      </div>
    </div>

    <!-- Recent Trades -->
    <div class="bg-white rounded-2xl p-6 border border-gray-100">
      <div class="flex items-center justify-between mb-4">
        <h3 class="font-semibold text-gray-800">近期交易</h3>
        <el-button type="primary" link>查看全部</el-button>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead>
            <tr class="text-left text-sm text-gray-500 border-b border-gray-100">
              <th class="pb-3 font-medium">日期</th>
              <th class="pb-3 font-medium">品种</th>
              <th class="pb-3 font-medium">方向</th>
              <th class="pb-3 font-medium text-right">盈亏</th>
              <th class="pb-3 font-medium text-right">收益率</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="trade in recentTrades" 
              :key="trade.date"
              class="border-b border-gray-50 last:border-0"
            >
              <td class="py-3 text-sm text-gray-600">{{ trade.date }}</td>
              <td class="py-3 text-sm font-medium text-gray-800">{{ trade.symbol }}</td>
              <td class="py-3">
                <el-tag 
                  :type="trade.direction === 'buy' ? 'danger' : 'success'" 
                  size="small"
                  effect="light"
                >
                  {{ trade.direction === 'buy' ? '买入' : '卖出' }}
                </el-tag>
              </td>
              <td 
                class="py-3 text-sm font-semibold text-right"
                :class="trade.profit >= 0 ? 'text-red-500' : 'text-green-500'"
              >
                {{ trade.profit >= 0 ? '+' : '' }}¥{{ trade.profit }}
              </td>
              <td 
                class="py-3 text-sm text-right"
                :class="trade.rate >= 0 ? 'text-red-500' : 'text-green-500'"
              >
                {{ trade.rate >= 0 ? '+' : '' }}{{ trade.rate }}%
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
