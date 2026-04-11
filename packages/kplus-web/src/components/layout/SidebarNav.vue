<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElTooltip, ElIcon } from 'element-plus'
import {
  TrendCharts,
  Timer,
  EditPen,
  Wallet,
  Sort,
  PieChart,
  Grid,
  DataAnalysis,
  Trophy,
  ChatDotRound,
  UserFilled,
  Medal,
  User,
  Setting,
  Fold,
  Expand
} from '@element-plus/icons-vue'

const props = defineProps({
  collapsed: Boolean
})

const emit = defineEmits(['toggle'])

const route = useRoute()
const router = useRouter()

const menuGroups = [
  {
    label: '数据中心',
    items: [
      { path: '/main/dashboard', title: '数据总览', icon: PieChart },
      { path: '/main/statistics', title: '交易统计', icon: Grid },
      { path: '/main/analysis', title: '收益分析', icon: DataAnalysis }
    ]
  },
  {
    label: '账户中心',
    items: [
      { path: '/main/accounts', title: '账户管理', icon: Wallet },
      { path: '/main/transfer', title: '资金调拨', icon: Sort }
    ]
  },
  {
    label: '社交激励',
    items: [
      { path: '/main/leaderboard', title: '排行榜', icon: Trophy },
      { path: '/main/community', title: '交流社区', icon: ChatDotRound },
      { path: '/main/copytrading', title: '跟单大厅', icon: UserFilled }
    ]
  },
  {
    label: '个人体系',
    items: [
      { path: '/main/packages', title: '会员套餐', icon: Medal },
      { path: '/main/profile', title: '个人中心', icon: User },
      { path: '/main/settings', title: '系统设置', icon: Setting }
    ]
  }
]

// 训练功能跳转到 /kline-plus
const goTraining = () => {
  router.push('/kline-plus')
}

const activeMenu = computed(() => route.path)

const handleSelect = (path) => {
  router.push(path)
}
</script>

<template>
  <aside class="fixed left-0 top-0 h-full bg-white shadow-lg z-50 transition-all duration-300 flex flex-col"
    :class="collapsed ? 'w-20' : 'w-64'">
    <!-- Logo -->
    <div class="h-16 flex items-center gap-3 px-5 border-b border-gray-100 flex-shrink-0">
      <div
        class="w-10 h-10 rounded-xl bg-gradient-to-br from-orange-400 to-red-500 flex items-center justify-center text-white flex-shrink-0">
        <svg viewBox="0 0 24 24" class="w-6 h-6" fill="currentColor">
          <path
            d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z" />
        </svg>
      </div>
      <span v-if="!collapsed" class="text-xl font-bold text-gray-800 whitespace-nowrap">口袋鱼</span>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 overflow-y-auto py-4 px-3">
      <!-- 训练入口 -->
      <div class="mb-4">
        <p v-if="!collapsed" class="px-3 mb-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
          核心训练
        </p>
        <div v-else class="h-px bg-gray-100 mx-2 my-3"></div>
        <div class="space-y-1">
          <el-tooltip content="K线训练营" placement="right" :disabled="!collapsed">
            <button @click="goTraining"
              class="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200 text-gray-600 hover:bg-primary-50 hover:text-primary-600">
              <el-icon :size="20" class="flex-shrink-0">
                <TrendCharts />
              </el-icon>
              <span v-if="!collapsed" class="truncate">K线训练营</span>
            </button>
          </el-tooltip>
        </div>
      </div>

      <div v-for="group in menuGroups" :key="group.label" class="mb-4">
        <p v-if="!collapsed" class="px-3 mb-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
          {{ group.label }}
        </p>
        <div v-else class="h-px bg-gray-100 mx-2 my-3"></div>

        <div class="space-y-1">
          <template v-for="item in group.items" :key="item.path">
            <el-tooltip :content="item.title" placement="right" :disabled="!collapsed">
              <router-link :to="item.path"
                class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200"
                :class="[
                  activeMenu === item.path
                    ? 'bg-primary-600 text-white shadow-md shadow-primary-500/30'
                    : 'text-gray-600 hover:bg-primary-50 hover:text-primary-600'
                ]">
                <el-icon :size="20" class="flex-shrink-0">
                  <component :is="item.icon" />
                </el-icon>
                <span v-if="!collapsed" class="truncate">{{ item.title }}</span>
              </router-link>
            </el-tooltip>
          </template>
        </div>
      </div>
    </nav>

    <!-- Collapse Toggle -->
    <div class="p-3 border-t border-gray-100 flex-shrink-0">
      <button @click="emit('toggle')"
        class="w-full flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl text-gray-500 hover:bg-gray-100 transition-colors">
        <el-icon :size="18">
          <Fold v-if="!collapsed" />
          <Expand v-else />
        </el-icon>
        <span v-if="!collapsed" class="text-sm">收起菜单</span>
      </button>
    </div>
  </aside>
</template>
