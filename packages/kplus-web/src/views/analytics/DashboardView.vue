<script setup>
import { ref, computed } from 'vue'
import { ElIcon, ElProgress } from 'element-plus'
import {
  Wallet,
  Coin,
  Aim,
  Refresh,
  CaretTop,
  CaretBottom,
  VideoPlay,
  DataLine,
  Trophy,
  Medal,
  Calendar,
  Histogram,
  Grid,
  Timer,
  Lock,
  Star,
  TrendCharts,
  ArrowRight
} from '@element-plus/icons-vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart } from 'echarts/charts'
import { GridComponent, TooltipComponent } from 'echarts/components'

use([CanvasRenderer, LineChart, GridComponent, TooltipComponent])

// ============ 待接入后端：以下数据均为 mock，结构对齐未来接口响应 ============

const stats = [
  { key: 'total', title: '总收益', value: '25,800', unit: '¥', change: 20.5, icon: Wallet },
  { key: 'today', title: '今日收益', value: '1,200', unit: '¥', change: 15.2, icon: Coin },
  { key: 'win', title: '胜率', value: '65.5', unit: '%', change: 5.3, icon: Aim },
  { key: 'count', title: '交易次数', value: '128', unit: '次', change: 12.8, icon: Refresh }
]

const genSeries = (n, start, growth, volatility, seed) => {
  const out = []
  let v = start
  for (let i = 0; i < n; i++) {
    const wave = Math.sin(i * 0.55 + seed) * volatility * 0.7 + Math.cos(i * 0.23 + seed * 2) * volatility * 0.3
    v = Math.max(20, v + growth + wave)
    out.push(Math.round(v))
  }
  return out
}

const rangeOptions = [
  { key: '7d', label: '近7天' },
  { key: '30d', label: '近30天' },
  { key: '90d', label: '近90天' }
]
const activeRange = ref('30d')
const rangeSeries = {
  '7d': genSeries(7, 400, 520, 260, 1),
  '30d': genSeries(30, 500, 280, 380, 2),
  '90d': genSeries(90, 120, 95, 260, 4)
}

// 交易品种分布（横向条形，单一蓝色系）
const pieData = [
  { value: 48, name: '上证指数' },
  { value: 32, name: '创业板指' },
  { value: 28, name: '科创50' },
  { value: 20, name: 'IF沪深300' }
]

const trainings = [
  {
    id: 1,
    symbol: 'IF2501 沪深300股指',
    period: '1分钟',
    duration: '32 分钟',
    finishedAt: '今天 14:32',
    profit: 2600,
    rate: 2.6,
    status: 'finished',
    icon: TrendCharts
  },
  {
    id: 2,
    symbol: 'RB2510 螺纹钢主力',
    period: '5分钟',
    duration: '45 分钟',
    finishedAt: '昨天 21:08',
    profit: -850,
    rate: -1.24,
    status: 'finished',
    icon: Histogram
  },
  {
    id: 3,
    symbol: 'CU2511 沪铜主力',
    period: '15分钟',
    duration: '26 分钟',
    finishedAt: '09-24 10:15',
    profit: 1350,
    rate: 1.72,
    status: 'finished',
    icon: Coin
  },
  {
    id: 4,
    symbol: 'AU2512 沪金主力',
    period: '1分钟',
    duration: '进行中',
    finishedAt: '09-24 09:30',
    profit: null,
    rate: null,
    status: 'running',
    icon: Star
  }
]

const achievements = [
  { name: '初出茅庐', desc: '完成首次训练', unlocked: true, icon: Medal },
  { name: '七日连训', desc: '连续训练 7 天', unlocked: true, icon: Calendar },
  { name: '百笔达成', desc: '累计交易 100 笔', unlocked: true, icon: Histogram },
  { name: '胜率王者', desc: '胜率突破 60%', unlocked: true, icon: Trophy },
  { name: '全品种大师', desc: '训练全部品种', unlocked: false, icon: Grid },
  { name: '千锤百炼', desc: '训练 1000 小时', unlocked: false, icon: Timer }
]

const level = { name: '训练达人', lv: 5, exp: 320, total: 500 }

const recentTrades = [
  { date: '09-26', symbol: '上证指数', direction: 'buy', profit: 1200, rate: 1.88 },
  { date: '09-26', symbol: 'IF沪深300', direction: 'sell', profit: -640, rate: -0.92 },
  { date: '09-25', symbol: '创业板指', direction: 'buy', profit: 860, rate: 1.31 },
  { date: '09-25', symbol: '科创50', direction: 'sell', profit: 420, rate: 0.66 },
  { date: '09-24', symbol: '深证成指', direction: 'buy', profit: -720, rate: -1.05 },
  { date: '09-23', symbol: '螺纹钢主力', direction: 'sell', profit: 350, rate: 0.48 }
]

// ============ 计算属性 ============

const greeting = computed(() => {
  const hour = new Date().getHours()
  if (hour < 6) return '夜深了'
  if (hour < 12) return '早上好'
  if (hour < 18) return '下午好'
  return '晚上好'
})

const todayText = computed(() =>
  new Date().toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' })
)

const lineChartOption = computed(() => {
  const data = rangeSeries[activeRange.value]
  return {
    tooltip: {
      trigger: 'axis',
      backgroundColor: '#1b1d22',
      borderColor: 'rgba(255,255,255,0.08)',
      borderWidth: 1,
      padding: [8, 12],
      textStyle: { color: '#e8eaed', fontSize: 12 },
      extraCssText: 'border-radius:4px;',
      valueFormatter: (value) => `¥${value.toLocaleString()}`,
      axisPointer: {
        type: 'cross',
        lineStyle: { color: 'var(--c-line-strong)', type: 'dashed' },
        crossStyle: { color: 'var(--c-line-strong)' },
        label: {
          backgroundColor: '#1b1d22',
          color: '#e8eaed',
          borderRadius: 3,
          borderColor: 'rgba(255,255,255,0.08)',
          borderWidth: 1,
          padding: [2, 6],
          fontSize: 11,
          fontFamily: 'Roboto Mono, Consolas, monospace'
        }
      }
    },
    grid: { left: 8, right: 12, bottom: 0, top: 20, containLabel: true },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: data.map((_, i) => `${i + 1}日`),
      axisLine: { lineStyle: { color: 'var(--c-line)' } },
      axisTick: { show: false },
      axisLabel: { color: 'var(--c-ink-faint)', fontSize: 11, interval: Math.ceil(data.length / 8) - 1 }
    },
    yAxis: {
      type: 'value',
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: 'var(--c-line)' } },
      axisLabel: {
        color: 'var(--c-ink-faint)',
        fontSize: 11,
        fontFamily: 'Roboto Mono, Consolas, monospace',
        formatter: (v) => `¥${Math.round(v / 1000)}k`
      }
    },
    series: [
      {
        name: '收益',
        type: 'line',
        data,
        smooth: true,
        symbol: 'circle',
        symbolSize: 5,
        showSymbol: false,
        lineStyle: { width: 2, color: '#2962ff' },
        itemStyle: { color: '#2962ff', borderColor: '#0a0a0a', borderWidth: 1 },
        areaStyle: { color: 'rgba(41,98,255,0.06)' },
        emphasis: { focus: 'series' }
      }
    ]
  }
})

// 横向条形图（纯 CSS 渲染，单一蓝色系）
const totalTrades = computed(() => pieData.reduce((sum, d) => sum + d.value, 0))
const barItems = computed(() => {
  const max = Math.max(...pieData.map((d) => d.value))
  return pieData.map((d, i) => ({
    ...d,
    width: (d.value / max) * 100,
    opacity: 1 - i * 0.2,
    percent: ((d.value / totalTrades.value) * 100).toFixed(0)
  }))
})

const levelPercent = computed(() => Math.round((level.exp / level.total) * 100))

// ============ 方法 ============

const switchRange = (key) => {
  activeRange.value = key
}

const formatIncome = (value) => `${value >= 0 ? '+' : ''}¥${Math.abs(value).toLocaleString()}`
</script>

<template>
  <div class="space-y-8">
    <!-- 顶部极简区：问候 + 核心数据 + 快捷入口 -->
    <div class="flex flex-col xl:flex-row xl:items-end justify-between gap-6">
      <div>
        <h2 class="text-2xl font-semibold text-ink tracking-tight">{{ greeting }}，泊远万里</h2>
        <p class="mt-2 text-sm text-ink-secondary">连续训练第 12 天 · {{ todayText }}</p>
      </div>

      <div class="flex flex-wrap items-center gap-6">
        <!-- 核心数据 -->
        <div class="flex items-center gap-8">
          <div>
            <p class="text-xs text-ink-faint mb-1">账户余额</p>
            <p class="text-lg font-medium text-ink font-mono tabular-nums">¥100,000</p>
          </div>
          <div class="w-px h-8 bg-line"></div>
          <div>
            <p class="text-xs text-ink-faint mb-1">今日盈亏</p>
            <p class="text-lg font-medium text-up font-mono tabular-nums">+¥1,200</p>
          </div>
        </div>

        <!-- 幽灵按钮 -->
        <div class="flex items-center gap-3">
          <router-link to="/kline-plus" class="ghost-btn">
            <el-icon :size="14"><VideoPlay /></el-icon>
            开始训练
          </router-link>
          <router-link to="/main/statistics" class="ghost-btn">
            <el-icon :size="14"><DataLine /></el-icon>
            查看战绩
          </router-link>
          <router-link to="/main/leaderboard" class="ghost-btn">
            <el-icon :size="14"><Trophy /></el-icon>
            排行榜
          </router-link>
        </div>
      </div>
    </div>

    <!-- KPI 4 卡：细描边、无彩色底、等宽大数字、无 sparkline -->
    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
      <div
        v-for="stat in stats"
        :key="stat.key"
        class="bg-panel border border-line rounded-md p-6 hover:border-primary-500/40 transition-colors"
      >
        <div class="flex items-center justify-between">
          <p class="text-sm text-ink-secondary">{{ stat.title }}</p>
          <el-icon :size="16" class="text-ink-faint"><component :is="stat.icon" /></el-icon>
        </div>
        <p class="mt-3 text-3xl font-medium text-ink leading-none font-mono tabular-nums">
          <template v-if="stat.unit === '¥'"> <span class="mr-0.5 text-base text-ink-faint">¥</span>{{ stat.value }} </template>
          <template v-else>
            {{ stat.value }}<span class="ml-1 text-sm text-ink-faint font-sans">{{ stat.unit }}</span>
          </template>
        </p>
        <div class="mt-4 flex items-center gap-2">
          <span
            class="inline-flex items-center gap-0.5 px-1.5 py-0.5 rounded-[3px] text-xs font-medium border font-mono tabular-nums"
            :class="stat.change >= 0 ? 'text-up border-up/30 bg-up-dim' : 'text-down border-down/30 bg-down-dim'"
          >
            <el-icon :size="10"><CaretTop v-if="stat.change >= 0" /><CaretBottom v-else /></el-icon>
            {{ stat.change >= 0 ? '+' : '' }}{{ stat.change }}%
          </span>
          <span class="text-xs text-ink-faint">较上月</span>
        </div>
      </div>
    </div>

    <!-- 图表区：收益趋势 + 品种分布 -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
      <div class="lg:col-span-2 bg-panel border border-line rounded-md p-6">
        <div class="flex items-center justify-between mb-4">
          <div>
            <h3 class="text-sm font-medium text-ink">收益趋势</h3>
            <p class="text-xs text-ink-faint mt-0.5">训练结算收益累计走势</p>
          </div>
          <div class="inline-flex items-center gap-0.5 border border-line rounded p-0.5">
            <button
              v-for="r in rangeOptions"
              :key="r.key"
              @click="switchRange(r.key)"
              class="px-3 py-1 rounded-[3px] text-xs transition-colors"
              :class="activeRange === r.key ? 'bg-primary-500/15 text-primary-400' : 'text-ink-faint hover:text-ink-secondary'"
            >
              {{ r.label }}
            </button>
          </div>
        </div>
        <v-chart :option="lineChartOption" class="chart-box" autoresize />
      </div>

      <div class="bg-panel border border-line rounded-md p-6">
        <div class="flex items-center justify-between mb-6">
          <div>
            <h3 class="text-sm font-medium text-ink">交易品种分布</h3>
            <p class="text-xs text-ink-faint mt-0.5">共 {{ totalTrades }} 笔</p>
          </div>
        </div>
        <div class="space-y-5">
          <div v-for="bar in barItems" :key="bar.name">
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-xs text-ink-secondary">{{ bar.name }}</span>
              <span class="text-xs text-ink-faint font-mono tabular-nums">{{ bar.percent }}%</span>
            </div>
            <div class="h-1.5 bg-white/[0.04] rounded-[2px] overflow-hidden">
              <div
                class="h-full rounded-[2px]"
                :style="{ width: bar.width + '%', backgroundColor: `rgba(41,98,255,${bar.opacity})` }"
              ></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 训练动态 + 成就 -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
      <div class="lg:col-span-2 bg-panel border border-line rounded-md p-6">
        <div class="flex items-center justify-between mb-2">
          <h3 class="text-sm font-medium text-ink">最近训练</h3>
          <router-link
            to="/main/statistics"
            class="flex items-center gap-1 text-xs text-primary-400 hover:text-primary-300 transition-colors"
          >
            查看全部
            <el-icon :size="12"><ArrowRight /></el-icon>
          </router-link>
        </div>
        <div class="divide-y divide-line">
          <div v-for="t in trainings" :key="t.id" class="py-4 first:pt-2 last:pb-0 flex items-center gap-4">
            <div
              class="w-9 h-9 rounded flex items-center justify-center shrink-0 border"
              :class="
                t.status === 'running'
                  ? 'border-primary-500/30 bg-primary-500/10 text-primary-400'
                  : 'border-line bg-white/[0.03] text-ink-faint'
              "
            >
              <el-icon :size="16"><component :is="t.icon" /></el-icon>
            </div>
            <div class="min-w-0 flex-1">
              <div class="flex items-center gap-2.5">
                <p class="text-sm text-ink truncate">{{ t.symbol }}</p>
                <span class="flex items-center gap-1.5 text-xs" :class="t.status === 'running' ? 'text-primary-400' : 'text-ink-faint'">
                  <span
                    class="w-1.5 h-1.5 rounded-full"
                    :class="t.status === 'running' ? 'bg-primary-500 animate-pulse' : 'bg-ink-faint'"
                  ></span>
                  {{ t.status === 'running' ? '进行中' : '已结束' }}
                </span>
              </div>
              <p class="text-xs text-ink-faint mt-1">{{ t.period }}周期 · 训练 {{ t.duration }} · {{ t.finishedAt }}</p>
            </div>
            <div class="text-right shrink-0">
              <p
                v-if="t.profit !== null"
                class="text-sm font-medium font-mono tabular-nums"
                :class="t.profit >= 0 ? 'text-up' : 'text-down'"
              >
                {{ formatIncome(t.profit) }}
              </p>
              <p v-if="t.rate !== null" class="text-xs mt-1 font-mono tabular-nums" :class="t.rate >= 0 ? 'text-up/80' : 'text-down/80'">
                收益率 {{ t.rate >= 0 ? '+' : '' }}{{ t.rate }}%
              </p>
              <p v-else class="text-sm text-ink-faint">--</p>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-panel border border-line rounded-md p-6">
        <h3 class="text-sm font-medium text-ink mb-4">成就徽章</h3>
        <div class="grid grid-cols-3 gap-3">
          <div
            v-for="a in achievements"
            :key="a.name"
            class="flex flex-col items-center text-center p-3 rounded border transition-colors"
            :class="a.unlocked ? 'border-primary-500/25 bg-primary-500/[0.04]' : 'border-line bg-white/[0.02] opacity-50'"
          >
            <div class="relative">
              <div
                class="w-10 h-10 rounded flex items-center justify-center border"
                :class="
                  a.unlocked ? 'border-primary-500/40 text-primary-400 bg-primary-500/10' : 'border-line text-ink-faint bg-white/[0.03]'
                "
              >
                <el-icon :size="18"><component :is="a.icon" /></el-icon>
              </div>
              <span
                v-if="!a.unlocked"
                class="absolute -bottom-1 -right-1 w-4 h-4 rounded-[3px] bg-panel-raised border border-line text-ink-faint flex items-center justify-center"
              >
                <el-icon :size="9"><Lock /></el-icon>
              </span>
            </div>
            <p class="mt-2 text-xs text-ink-secondary">{{ a.name }}</p>
            <p class="text-[10px] text-ink-faint leading-tight mt-0.5">{{ a.desc }}</p>
          </div>
        </div>
        <div class="mt-6 pt-5 border-t border-line">
          <div class="flex items-center justify-between mb-2.5">
            <span class="text-sm text-ink-secondary">
              {{ level.name }} <span class="text-primary-400 font-medium">Lv.{{ level.lv }}</span>
            </span>
            <span class="text-xs text-ink-faint font-mono tabular-nums">{{ level.exp }} / {{ level.total }}</span>
          </div>
          <el-progress :percentage="levelPercent" :show-text="false" :stroke-width="4" color="#2962ff" />
        </div>
      </div>
    </div>

    <!-- 近期交易 -->
    <div class="bg-panel border border-line rounded-md p-6">
      <div class="flex items-center justify-between mb-4">
        <div>
          <h3 class="text-sm font-medium text-ink">近期交易</h3>
          <p class="text-xs text-ink-faint mt-0.5">最近 6 笔训练交易记录</p>
        </div>
        <router-link
          to="/main/statistics"
          class="flex items-center gap-1 text-xs text-primary-400 hover:text-primary-300 transition-colors"
        >
          查看全部
          <el-icon :size="12"><ArrowRight /></el-icon>
        </router-link>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full min-w-[560px]">
          <thead>
            <tr class="text-left text-xs text-ink-faint border-b border-line">
              <th class="pb-3 font-normal">日期</th>
              <th class="pb-3 font-normal">品种</th>
              <th class="pb-3 font-normal">方向</th>
              <th class="pb-3 font-normal text-right">盈亏</th>
              <th class="pb-3 font-normal text-right">收益率</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="trade in recentTrades"
              :key="trade.date + trade.symbol"
              class="border-b border-line last:border-0 hover:bg-white/[0.02] transition-colors"
            >
              <td class="py-3.5 text-sm text-ink-faint font-mono tabular-nums">{{ trade.date }}</td>
              <td class="py-3.5 text-sm text-ink">{{ trade.symbol }}</td>
              <td class="py-3.5">
                <span
                  class="inline-flex items-center gap-0.5 px-1.5 py-0.5 rounded-[3px] text-xs border"
                  :class="trade.direction === 'buy' ? 'text-up border-up/30 bg-up-dim' : 'text-down border-down/30 bg-down-dim'"
                >
                  <el-icon :size="10">
                    <CaretTop v-if="trade.direction === 'buy'" />
                    <CaretBottom v-else />
                  </el-icon>
                  {{ trade.direction === 'buy' ? '做多' : '做空' }}
                </span>
              </td>
              <td class="py-3.5 text-sm font-medium text-right font-mono tabular-nums" :class="trade.profit >= 0 ? 'text-up' : 'text-down'">
                {{ formatIncome(trade.profit) }}
              </td>
              <td class="py-3.5">
                <div class="flex items-center justify-end gap-2">
                  <div class="w-16 h-1 rounded-full bg-white/[0.06] overflow-hidden">
                    <div
                      class="h-full rounded-full bg-primary-500"
                      :style="{ width: Math.min(Math.abs(trade.rate) * 40, 100) + '%' }"
                    ></div>
                  </div>
                  <span class="text-sm font-mono tabular-nums" :class="trade.rate >= 0 ? 'text-up' : 'text-down'">
                    {{ trade.rate >= 0 ? '+' : '' }}{{ trade.rate }}%
                  </span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<style scoped>
.chart-box {
  height: 300px;
}

.ghost-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 34px;
  padding: 0 14px;
  border-radius: 4px;
  border: 1px solid var(--c-line-strong);
  color: var(--c-ink-secondary);
  font-size: 13px;
  transition: all 0.15s;
}

.ghost-btn:hover {
  border-color: #2962ff;
  background: #2962ff;
  color: #ffffff;
}
</style>
