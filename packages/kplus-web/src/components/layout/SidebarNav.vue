<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElTooltip, ElIcon } from 'element-plus'
import {
  TrendCharts,
  PieChart,
  Grid,
  DataAnalysis,
  Wallet,
  Sort,
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

const hoverExpand = ref(false)
const expanded = computed(() => !props.collapsed || hoverExpand.value)

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

const goTraining = () => {
  router.push('/kline-plus')
}

const activeMenu = computed(() => route.path)
</script>

<template>
  <aside
    class="fixed left-0 top-0 h-full bg-panel border-r border-line z-50 flex flex-col transition-all duration-200 overflow-hidden"
    :class="expanded ? 'w-60' : 'w-[72px]'"
    @mouseenter="hoverExpand = true"
    @mouseleave="hoverExpand = false"
  >
    <!-- Logo -->
    <div class="h-16 flex items-center gap-3 px-5 border-b border-line flex-shrink-0">
      <div
        class="w-9 h-9 rounded flex items-center justify-center flex-shrink-0 bg-primary-500/15 text-primary-400 border border-primary-500/30"
      >
        <svg viewBox="0 0 24 24" class="w-5 h-5" fill="currentColor">
          <path
            d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"
          />
        </svg>
      </div>
      <span v-if="expanded" class="text-lg font-semibold text-ink whitespace-nowrap tracking-wide">口袋鱼</span>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 overflow-y-auto py-4 px-3">
      <!-- 训练入口 -->
      <div class="mb-4">
        <p v-if="expanded" class="px-3 mb-2 text-[11px] font-medium text-ink-faint tracking-widest">核心训练</p>
        <div v-else class="h-px bg-line mx-2 my-3"></div>
        <el-tooltip content="K线训练营" placement="right" :disabled="expanded">
          <button
            @click="goTraining"
            class="w-full relative flex items-center gap-3 px-3 py-2.5 rounded text-sm transition-colors duration-150 text-ink-secondary hover:text-ink hover:bg-black/5 dark:hover:bg-white/5"
          >
            <el-icon :size="18" class="flex-shrink-0">
              <TrendCharts />
            </el-icon>
            <span v-if="expanded" class="truncate">K线训练营</span>
          </button>
        </el-tooltip>
      </div>

      <div v-for="group in menuGroups" :key="group.label" class="mb-4">
        <p v-if="expanded" class="px-3 mb-2 text-[11px] font-medium text-ink-faint tracking-widest">
          {{ group.label }}
        </p>
        <div v-else class="h-px bg-line mx-2 my-3"></div>

        <div class="space-y-0.5">
          <template v-for="item in group.items" :key="item.path">
            <el-tooltip :content="item.title" placement="right" :disabled="expanded">
              <router-link
                :to="item.path"
                class="relative flex items-center gap-3 px-3 py-2.5 rounded text-sm transition-colors duration-150"
                :class="
                  activeMenu === item.path
                    ? 'text-primary-400 bg-primary-500/10'
                    : 'text-ink-secondary hover:text-ink hover:bg-black/5 dark:hover:bg-white/5'
                "
              >
                <span v-if="activeMenu === item.path" class="absolute left-0 top-1/2 -translate-y-1/2 w-0.5 h-5 bg-primary-500"></span>
                <el-icon :size="18" class="flex-shrink-0">
                  <component :is="item.icon" />
                </el-icon>
                <span v-if="expanded" class="truncate">{{ item.title }}</span>
              </router-link>
            </el-tooltip>
          </template>
        </div>
      </div>
    </nav>

    <!-- Collapse Toggle -->
    <div class="p-3 border-t border-line flex-shrink-0">
      <button
        @click="emit('toggle')"
        class="w-full flex items-center justify-center gap-2 px-3 py-2.5 rounded text-ink-faint hover:text-ink hover:bg-black/5 dark:hover:bg-white/5 transition-colors"
      >
        <el-icon :size="16">
          <Fold v-if="!collapsed" />
          <Expand v-else />
        </el-icon>
        <span v-if="expanded" class="text-xs">{{ collapsed ? '展开菜单' : '收起菜单' }}</span>
      </button>
    </div>
  </aside>
</template>
