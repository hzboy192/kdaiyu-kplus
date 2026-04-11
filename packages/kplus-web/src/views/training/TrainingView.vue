<script setup>
import { ref } from 'vue'
import { ElCard, ElButton, ElTag, ElIcon, ElSelect, ElOption } from 'element-plus'
import { VideoPlay, Opportunity, Aim, Timer } from '@element-plus/icons-vue'

const trainingModes = [
  { id: 'random', title: '随机模式', desc: '随机历史K线', icon: Opportunity },
  { id: 'continuous', title: '连续模式', desc: '连续30日走势', icon: VideoPlay },
  { id: 'special', title: '专项训练', desc: '突破/回调/震荡', icon: Aim },
  { id: 'exam', title: '考试模式', desc: '限时决策测试', icon: Timer }
]

const selectedMode = ref('random')
const currentPrice = ref(3052.34)
const priceChange = ref(1.2)
const currentDate = ref('2024-01-15')
const timeframe = ref('day')

// Mock K-line data
const klineData = ref([
  { type: 'down', height: 40 },
  { type: 'up', height: 60 },
  { type: 'down', height: 80 },
  { type: 'down', height: 50 },
  { type: 'up', height: 70 },
  { type: 'down', height: 100 },
  { type: 'up', height: 40 },
  { type: 'up', height: 55 },
  { type: 'down', height: 65 },
  { type: 'up', height: 85 }
])
</script>

<template>
  <div class="space-y-6">
    <!-- Training Mode Selection -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div
        v-for="mode in trainingModes"
        :key="mode.id"
        @click="selectedMode = mode.id"
        class="p-4 bg-white rounded-xl border-2 cursor-pointer transition-all duration-200 hover:shadow-md"
        :class="selectedMode === mode.id 
          ? 'border-primary-500 bg-primary-50 shadow-md shadow-primary-500/20' 
          : 'border-gray-200 hover:border-primary-300'"
      >
        <div class="flex items-center gap-3">
          <div 
            class="w-10 h-10 rounded-lg flex items-center justify-center"
            :class="selectedMode === mode.id ? 'bg-primary-500 text-white' : 'bg-gray-100 text-gray-600'"
          >
            <el-icon :size="20"><component :is="mode.icon" /></el-icon>
          </div>
          <div>
            <h3 class="font-bold text-gray-800">{{ mode.title }}</h3>
            <p class="text-xs text-gray-500">{{ mode.desc }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- K-Line Chart Area -->
    <div class="bg-gray-900 rounded-2xl p-6 shadow-xl">
      <!-- Chart Header -->
      <div class="flex items-center justify-between mb-6">
        <div class="flex items-center gap-6">
          <div class="flex items-center gap-3">
            <span class="text-white font-medium">上证指数</span>
            <span 
              class="text-lg font-bold"
              :class="priceChange >= 0 ? 'text-red-400' : 'text-green-400'"
            >
              {{ currentPrice.toFixed(2) }}
              <span class="text-sm ml-1">
                {{ priceChange >= 0 ? '+' : '' }}{{ priceChange }}%
              </span>
            </span>
          </div>
          <span class="text-gray-400 text-sm">{{ currentDate }}</span>
        </div>
        <div class="flex gap-2">
          <button 
            v-for="tf in ['1分', '5分', '15分', '30分', '日线']"
            :key="tf"
            @click="timeframe = tf"
            class="px-3 py-1.5 rounded-lg text-xs font-medium transition-colors"
            :class="timeframe === tf 
              ? 'bg-primary-500 text-white' 
              : 'bg-gray-800 text-gray-400 hover:bg-gray-700'"
          >
            {{ tf }}
          </button>
        </div>
      </div>

      <!-- K-Line Chart -->
      <div class="h-80 flex items-end justify-around gap-2 px-4 pb-4 border-b border-gray-700 relative">
        <!-- Y-axis labels -->
        <div class="absolute left-0 top-0 h-full flex flex-col justify-between text-gray-500 text-xs">
          <span>3,100</span>
          <span>3,050</span>
          <span>3,000</span>
        </div>
        
        <!-- Candlesticks -->
        <div
          v-for="(candle, index) in klineData"
          :key="index"
          class="flex flex-col items-center"
        >
          <div 
            class="w-1 bg-gray-600 opacity-50"
            :style="{ height: `${Math.random() * 20 + 10}px` }"
          ></div>
          <div
            class="w-4 rounded-sm"
            :class="candle.type === 'up' ? 'bg-red-500' : 'bg-green-500'"
            :style="{ height: `${candle.height}px` }"
          ></div>
          <div 
            class="w-1 bg-gray-600 opacity-50"
            :style="{ height: `${Math.random() * 15 + 5}px` }"
          ></div>
        </div>

        <!-- Decision line -->
        <div class="absolute right-1/4 top-0 h-full border-l-2 border-dashed border-yellow-500/50"></div>
      </div>

      <!-- Volume bars -->
      <div class="h-16 flex items-end justify-around gap-2 px-4 pt-2">
        <div
          v-for="(candle, index) in klineData"
          :key="index"
          class="w-4 rounded-t"
          :class="candle.type === 'up' ? 'bg-red-500/60' : 'bg-green-500/60'"
          :style="{ height: `${Math.random() * 40 + 10}px` }"
        ></div>
      </div>

      <!-- Action Buttons -->
      <div class="flex justify-center gap-4 mt-6 pt-6 border-t border-gray-700">
        <el-button type="danger" size="large" class="!px-12 !py-3 !text-base !font-semibold !rounded-xl">
          买入做多
        </el-button>
        <el-button type="success" size="large" class="!px-12 !py-3 !text-base !font-semibold !rounded-xl">
          卖出做空
        </el-button>
        <el-button size="large" class="!px-12 !py-3 !text-base !font-semibold !rounded-xl !bg-gray-700 !text-white !border-gray-600 hover:!bg-gray-600">
          跳过观望
        </el-button>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div class="bg-white rounded-xl p-4 border border-gray-100">
        <p class="text-sm text-gray-500 mb-1">今日训练</p>
        <p class="text-2xl font-bold text-gray-800">15 <span class="text-sm font-normal text-gray-400">次</span></p>
      </div>
      <div class="bg-white rounded-xl p-4 border border-gray-100">
        <p class="text-sm text-gray-500 mb-1">今日胜率</p>
        <p class="text-2xl font-bold text-green-600">68.5%</p>
      </div>
      <div class="bg-white rounded-xl p-4 border border-gray-100">
        <p class="text-sm text-gray-500 mb-1">今日盈亏</p>
        <p class="text-2xl font-bold text-red-500">+¥2,350</p>
      </div>
      <div class="bg-white rounded-xl p-4 border border-gray-100">
        <p class="text-sm text-gray-500 mb-1">连续正确</p>
        <p class="text-2xl font-bold text-primary-600">5 <span class="text-sm font-normal text-gray-400">次</span></p>
      </div>
    </div>
  </div>
</template>
