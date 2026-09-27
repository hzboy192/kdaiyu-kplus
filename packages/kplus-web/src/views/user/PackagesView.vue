<script setup lang="ts">
import { ref } from 'vue'
import { ElButton, ElTag, ElIcon } from 'element-plus'
import { Check, Close, Medal } from '@element-plus/icons-vue'

const currentPlan = ref('free')

const plans = [
  {
    id: 'free',
    name: '免费版',
    price: 0,
    period: '月',
    description: '适合初学者体验',
    features: [
      { text: '基础K线训练', included: true },
      { text: '1个模拟账户', included: true },
      { text: '基础数据统计', included: true },
      { text: '多账户管理', included: false },
      { text: '高级收益分析', included: false },
      { text: '策略编辑器', included: false }
    ],
    buttonText: '当前方案',
    buttonType: 'default' as const,
    highlight: false
  },
  {
    id: 'pro',
    name: '专业版',
    price: 68,
    period: '月',
    description: '适合进阶交易者',
    features: [
      { text: '无限K线训练', included: true },
      { text: '5个模拟账户', included: true },
      { text: '账户间资金调拨', included: true },
      { text: '高级收益分析', included: true },
      { text: '策略编辑器', included: true },
      { text: '专属客服支持', included: true }
    ],
    buttonText: '立即升级',
    buttonType: 'primary' as const,
    highlight: true,
    badge: '最受欢迎'
  },
  {
    id: 'master',
    name: '大师版',
    price: 168,
    period: '月',
    description: '适合职业交易员',
    features: [
      { text: '无限模拟账户', included: true },
      { text: '高级账户分析报表', included: true },
      { text: '子账户权限管理', included: true },
      { text: 'API接口调用', included: true },
      { text: '一对一策略指导', included: true },
      { text: '优先功能体验', included: true }
    ],
    buttonText: '立即升级',
    buttonType: 'default' as const,
    highlight: false,
    gradient: true
  }
]

const comparisons = [
  { feature: '模拟账户数量', free: '1个', pro: '5个', master: '无限' },
  { feature: 'K线训练次数', free: '10次/天', pro: '无限', master: '无限' },
  { feature: '历史数据回测', free: '近3个月', pro: '近3年', master: '全部历史' },
  { feature: '策略编辑器', free: '不支持', pro: '支持', master: '支持+API' },
  { feature: '数据导出', free: '不支持', pro: 'CSV导出', master: '全格式导出' },
  { feature: '客服支持', free: '社区支持', pro: '工单支持', master: '专属客服' }
]
</script>

<template>
  <div class="space-y-8">
    <!-- Header -->
    <div class="text-center">
      <h2 class="text-2xl font-bold text-ink">会员套餐</h2>
      <p class="text-ink-faint mt-2">选择适合您的方案，解锁更多高级功能</p>
    </div>

    <!-- Pricing Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div
        v-for="plan in plans"
        :key="plan.id"
        class="rounded-md p-6 border transition-all relative"
        :class="[
          plan.highlight
            ? 'border-primary-500/40 bg-primary-500/10 scale-105'
            : plan.gradient
              ? 'border-line bg-panel'
              : 'border-line bg-panel hover:border-white/20'
        ]"
      >
        <!-- Badge -->
        <div v-if="plan.badge" class="absolute -top-3 left-1/2 -translate-x-1/2">
          <el-tag type="primary" effect="dark" round>{{ plan.badge }}</el-tag>
        </div>

        <h3 class="text-lg font-bold text-ink">{{ plan.name }}</h3>
        <div class="my-4">
          <span
            class="text-3xl font-bold font-mono tabular-nums"
            :class="plan.highlight ? 'text-primary-400' : plan.gradient ? 'text-primary-400' : 'text-ink'"
          >
            ¥{{ plan.price }}
          </span>
          <span class="text-sm text-ink-faint">/{{ plan.period }}</span>
        </div>
        <p class="text-sm text-ink-faint mb-6">{{ plan.description }}</p>

        <ul class="space-y-3 mb-6">
          <li
            v-for="feature in plan.features"
            :key="feature.text"
            class="flex items-center gap-2 text-sm"
            :class="feature.included ? 'text-ink-secondary' : 'text-ink-faint'"
          >
            <el-icon :size="16" :class="feature.included ? 'text-down' : 'text-ink-faint'">
              <Check v-if="feature.included" />
              <Close v-else />
            </el-icon>
            {{ feature.text }}
          </li>
        </ul>

        <el-button
          :type="plan.buttonType"
          class="w-full !rounded"
          :class="{
            '!bg-primary-500 !border-primary-500 !text-white hover:!bg-primary-600': plan.gradient && plan.buttonType === 'default'
          }"
          :disabled="plan.id === currentPlan"
        >
          {{ plan.id === currentPlan ? '当前方案' : plan.buttonText }}
        </el-button>
      </div>
    </div>

    <!-- Feature Comparison Table -->
    <div class="bg-panel rounded-md border border-line overflow-hidden">
      <div class="p-6 border-b border-line">
        <h3 class="text-lg font-bold text-ink">功能对比</h3>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-white/[0.03]">
            <tr>
              <th class="px-6 py-4 text-left text-sm font-medium text-ink-faint">功能</th>
              <th class="px-6 py-4 text-center text-sm font-medium text-ink-faint">免费版</th>
              <th class="px-6 py-4 text-center text-sm font-medium text-primary-400 bg-primary-500/10">专业版</th>
              <th class="px-6 py-4 text-center text-sm font-medium text-primary-400">大师版</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-line">
            <tr v-for="item in comparisons" :key="item.feature">
              <td class="px-6 py-4 text-sm text-ink-secondary font-medium">{{ item.feature }}</td>
              <td class="px-6 py-4 text-center text-sm text-ink-faint">{{ item.free }}</td>
              <td class="px-6 py-4 text-center text-sm text-primary-400 bg-primary-500/10 font-medium">{{ item.pro }}</td>
              <td class="px-6 py-4 text-center text-sm text-primary-400 font-medium">{{ item.master }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- FAQ -->
    <div class="bg-white/[0.03] rounded-md p-6">
      <h3 class="text-lg font-bold text-ink mb-4">常见问题</h3>
      <div class="grid md:grid-cols-2 gap-4">
        <div class="bg-panel rounded p-4">
          <h4 class="font-medium text-ink mb-2">如何升级会员？</h4>
          <p class="text-sm text-ink-faint">点击对应套餐的"立即升级"按钮，完成支付后立即生效。</p>
        </div>
        <div class="bg-panel rounded p-4">
          <h4 class="font-medium text-ink mb-2">可以随时取消吗？</h4>
          <p class="text-sm text-ink-faint">可以，取消后当前周期结束前仍可使用会员功能。</p>
        </div>
        <div class="bg-panel rounded p-4">
          <h4 class="font-medium text-ink mb-2">支持哪些支付方式？</h4>
          <p class="text-sm text-ink-faint">支持微信支付、支付宝、银行卡等多种支付方式。</p>
        </div>
        <div class="bg-panel rounded p-4">
          <h4 class="font-medium text-ink mb-2">有优惠活动吗？</h4>
          <p class="text-sm text-ink-faint">年付享受8折优惠，新用户首月可享7折优惠。</p>
        </div>
      </div>
    </div>
  </div>
</template>
