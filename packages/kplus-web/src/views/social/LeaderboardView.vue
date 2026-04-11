<script setup>
import { ref } from 'vue'
import { ElTabs, ElTabPane, ElButton, ElAvatar, ElTag, ElIcon } from 'element-plus'
import { Plus, Star } from '@element-plus/icons-vue'

const activeTab = ref('daily')

const topThree = [
  {
    rank: 2,
    name: '交易小王子',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=2',
    winRate: 78.5,
    profit: 128500,
    badge: 'silver'
  },
  {
    rank: 1,
    name: '股神在世',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=1',
    winRate: 85.2,
    profit: 256800,
    badge: 'gold'
  },
  {
    rank: 3,
    name: '量化操盘手',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=3',
    winRate: 72.3,
    profit: 98200,
    badge: 'bronze'
  }
]

const otherRanks = [
  { rank: 4, name: '韭菜收割机', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=4', winRate: 68.9, profit: 76500 },
  { rank: 5, name: '价值投资者', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=5', winRate: 65.2, profit: 58200 },
  { rank: 6, name: '趋势追踪', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=6', winRate: 62.8, profit: 45800 },
  { rank: 7, name: '短线猎手', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=7', winRate: 60.5, profit: 38500 },
  { rank: 8, name: '稳健派', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=8', winRate: 58.9, profit: 32100 },
  { rank: 9, name: '新手上路', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=9', winRate: 55.2, profit: 25600 },
  { rank: 10, name: '学习中', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=10', winRate: 52.8, profit: 18900 }
]

const getBadgeStyles = (badge) => {
  switch (badge) {
    case 'gold':
      return 'bg-gradient-to-b from-yellow-50 to-yellow-100 border-yellow-300'
    case 'silver':
      return 'bg-gray-50 border-gray-200'
    case 'bronze':
      return 'bg-gradient-to-b from-orange-50 to-orange-100 border-orange-200'
    default:
      return 'bg-white border-gray-200'
  }
}

const getAvatarSize = (rank) => {
  return rank === 1 ? 80 : 64
}

const getMedalEmoji = (rank) => {
  switch (rank) {
    case 1: return '🥇'
    case 2: return '🥈'
    case 3: return '🥉'
    default: return ''
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-gray-800">排行榜</h2>
        <p class="text-gray-500 text-sm mt-1">全站用户交易战绩排名（日/周/月/总榜）</p>
      </div>
      <div class="flex bg-gray-100 rounded-xl p-1">
        <button 
          v-for="tab in ['日榜', '周榜', '月榜', '总榜']"
          :key="tab"
          @click="activeTab = tab"
          class="px-4 py-2 rounded-lg text-sm font-medium transition-all"
          :class="activeTab === tab 
            ? 'bg-white text-gray-800 shadow-sm' 
            : 'text-gray-600 hover:text-gray-800'"
        >
          {{ tab }}
        </button>
      </div>
    </div>

    <!-- Top 3 Podium -->
    <div class="grid grid-cols-3 gap-4 md:gap-6 items-end">
      <template v-for="user in topThree" :key="user.rank">
        <div 
          class="rounded-2xl p-4 md:p-6 text-center border-2 transition-all hover:shadow-lg"
          :class="[
            getBadgeStyles(user.badge),
            user.rank === 1 ? 'order-2' : user.rank === 2 ? 'order-1 mt-8' : 'order-3 mt-8'
          ]"
        >
          <div 
            class="mx-auto mb-3 rounded-full flex items-center justify-center text-2xl md:text-3xl"
            :class="user.rank === 1 ? 'w-20 h-20 bg-yellow-400 shadow-lg shadow-yellow-400/30' : 'w-16 h-16 bg-gray-200'"
          >
            {{ getMedalEmoji(user.rank) }}
          </div>
          <h3 
            class="font-bold text-gray-800"
            :class="user.rank === 1 ? 'text-lg md:text-xl' : 'text-base'"
          >
            {{ user.name }}
          </h3>
          <p class="text-sm text-gray-500 mt-1">胜率 {{ user.winRate }}%</p>
          <div 
            class="font-bold mt-2"
            :class="user.rank === 1 ? 'text-xl md:text-2xl text-yellow-600' : 'text-lg text-gray-800'"
          >
            ¥{{ user.profit.toLocaleString() }}
          </div>
          <p class="text-xs text-gray-400">本月收益</p>
          <el-button 
            v-if="user.rank === 1"
            type="warning" 
            round 
            size="small" 
            class="mt-3"
          >
            <el-icon class="mr-1"><Plus /></el-icon>
            关注
          </el-button>
        </div>
      </template>
    </div>

    <!-- Other Rankings -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <div class="divide-y divide-gray-100">
        <div
          v-for="user in otherRanks"
          :key="user.rank"
          class="flex items-center p-4 hover:bg-gray-50 transition-colors"
        >
          <span 
            class="w-8 text-center font-bold text-lg"
            :class="user.rank <= 10 ? 'text-primary-600' : 'text-gray-400'"
          >
            {{ user.rank }}
          </span>
          <el-avatar 
            :src="user.avatar" 
            :size="44" 
            class="mx-4 border-2 border-gray-100"
          />
          <div class="flex-1">
            <div class="font-semibold text-gray-800">{{ user.name }}</div>
            <div class="text-xs text-gray-500">胜率 {{ user.winRate }}%</div>
          </div>
          <div class="text-right">
            <div class="font-bold text-gray-800">¥{{ user.profit.toLocaleString() }}</div>
            <div class="text-xs text-gray-500">本月收益</div>
          </div>
          <el-button type="primary" link size="small" class="ml-4">
            <el-icon><Plus /></el-icon>
            关注
          </el-button>
        </div>
      </div>
    </div>

    <!-- My Rank -->
    <div class="bg-primary-50 rounded-2xl p-4 border border-primary-100">
      <div class="flex items-center">
        <span class="w-8 text-center font-bold text-lg text-primary-600">56</span>
        <el-avatar 
          src="https://api.dicebear.com/7.x/avataaars/svg?seed=Felix" 
          :size="44" 
          class="mx-4 border-2 border-primary-200"
        />
        <div class="flex-1">
          <div class="flex items-center gap-2">
            <span class="font-semibold text-gray-800">泊远万里</span>
            <el-tag type="warning" size="small" effect="light">VIP</el-tag>
            <el-tag type="info" size="small">我</el-tag>
          </div>
          <div class="text-xs text-gray-500">胜率 65.5%</div>
        </div>
        <div class="text-right">
          <div class="font-bold text-gray-800">¥25,800</div>
          <div class="text-xs text-gray-500">本月收益</div>
        </div>
      </div>
    </div>
  </div>
</template>
