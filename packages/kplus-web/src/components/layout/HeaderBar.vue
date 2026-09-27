<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElDropdown, ElDropdownMenu, ElDropdownItem, ElAvatar, ElIcon, ElSelect, ElOption, ElMessage, ElTooltip } from 'element-plus'
import { Bell, Setting, SwitchButton, User, Wallet, Moon, Sunny } from '@element-plus/icons-vue'
import useUserStore from '@s/user'
import { getTheme, applyTheme } from '@/utils/theme'

const router = useRouter()
const userStore = useUserStore()

defineProps({
  title: String
})

defineEmits(['toggle-sidebar'])

const currentAccount = ref('default')

const isDark = ref(getTheme() === 'dark')

const toggleTheme = () => {
  isDark.value = applyTheme(isDark.value ? 'light' : 'dark') === 'dark'
}

// 退出登录
const handleLogout = () => {
  userStore
    .logout()
    .then(() => {
      ElMessage.success('退出登录成功')
      router.push('/login')
    })
    .catch(() => {
      ElMessage.error('退出登录失败')
    })
}
const accounts = [
  { id: 'default', name: '默认账户', balance: 100000 },
  { id: 'strategy', name: '策略测试账户', balance: 55000 },
  { id: 'futures', name: '期货交易账户', balance: 30000, disabled: true }
]

const notifications = ref([
  { id: 1, title: '交易提醒', content: '您的止盈单已触发', time: '5分钟前', read: false },
  { id: 2, title: '系统通知', content: '账户资金变动提醒', time: '1小时前', read: false },
  { id: 3, title: '社区消息', content: '您关注的用户发布了新策略', time: '2小时前', read: true }
])

const unreadCount = ref(2)
</script>

<template>
  <header class="h-16 bg-panel border-b border-line px-6 flex items-center justify-between sticky top-0 z-40">
    <!-- Left: Page Title -->
    <div class="flex items-center gap-4">
      <h1 class="text-lg font-semibold text-ink tracking-wide">{{ title }}</h1>
    </div>

    <!-- Right: Actions -->
    <div class="flex items-center gap-3">
      <!-- Account Selector -->
      <div class="flex items-center gap-2 px-3 py-1 border border-line rounded bg-black/[0.02] dark:bg-white/[0.02]">
        <el-icon class="text-primary-400">
          <Wallet />
        </el-icon>
        <el-select v-model="currentAccount" size="small" style="width: 168px" :teleported="false">
          <el-option
            v-for="account in accounts"
            :key="account.id"
            :label="`${account.name} (¥${account.balance.toLocaleString()})`"
            :value="account.id"
            :disabled="account.disabled"
          />
        </el-select>
      </div>

      <!-- Theme Toggle -->
      <el-tooltip :content="isDark ? '切换为浅色' : '切换为暗色'" placement="bottom">
        <button
          class="p-2 text-ink-secondary hover:text-ink hover:bg-black/5 dark:hover:bg-white/5 rounded transition-colors"
          @click="toggleTheme"
        >
          <el-icon :size="20">
            <Sunny v-if="isDark" />
            <Moon v-else />
          </el-icon>
        </button>
      </el-tooltip>

      <!-- Notifications -->
      <el-dropdown trigger="click" :teleported="false">
        <button class="relative p-2 text-ink-secondary hover:text-ink hover:bg-black/5 dark:hover:bg-white/5 rounded transition-colors">
          <el-icon :size="20">
            <Bell />
          </el-icon>
          <span v-if="unreadCount > 0" class="absolute top-1.5 right-1.5 w-1.5 h-1.5 bg-up rounded-full"></span>
        </button>
        <template #dropdown>
          <div class="w-80 bg-panel-raised border border-line rounded-md shadow-xl">
            <div class="px-4 py-3 border-b border-line">
              <div class="flex items-center justify-between">
                <span class="font-medium text-ink text-sm">通知消息</span>
                <span class="text-xs text-primary-400 cursor-pointer hover:text-primary-300">全部已读</span>
              </div>
            </div>
            <div class="max-h-80 overflow-y-auto">
              <div
                v-for="notification in notifications"
                :key="notification.id"
                class="px-4 py-3 hover:bg-black/5 dark:hover:bg-white/5 cursor-pointer border-b border-line last:border-0"
                :class="{ 'bg-primary-500/5': !notification.read }"
              >
                <div class="flex items-start gap-3">
                  <div
                    class="w-1.5 h-1.5 rounded-full mt-2 flex-shrink-0"
                    :class="notification.read ? 'bg-black/15 dark:bg-white/15' : 'bg-primary-500'"
                  ></div>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-ink">{{ notification.title }}</p>
                    <p class="text-xs text-ink-secondary mt-0.5 truncate">{{ notification.content }}</p>
                    <p class="text-xs text-ink-faint mt-1">{{ notification.time }}</p>
                  </div>
                </div>
              </div>
            </div>
            <div class="px-4 py-2 border-t border-line text-center">
              <span class="text-sm text-primary-400 cursor-pointer hover:text-primary-300">查看全部</span>
            </div>
          </div>
        </template>
      </el-dropdown>

      <!-- User Menu -->
      <el-dropdown trigger="click" :teleported="false">
        <div class="flex items-center gap-3 cursor-pointer hover:bg-black/5 dark:hover:bg-white/5 rounded px-2 py-1.5 transition-colors">
          <el-avatar :size="34" src="https://api.dicebear.com/7.x/avataaars/svg?seed=Felix" class="border border-line" />
          <div class="hidden md:block text-left">
            <p class="text-sm text-ink leading-tight">泊远万里</p>
            <p class="mt-0.5">
              <span class="text-[10px] text-primary-400 border border-primary-500/40 rounded-[3px] px-1 py-px">VIP会员</span>
            </p>
          </div>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item>
              <el-icon class="mr-2">
                <User />
              </el-icon>
              个人中心
            </el-dropdown-item>
            <el-dropdown-item>
              <el-icon class="mr-2">
                <Setting />
              </el-icon>
              系统设置
            </el-dropdown-item>
            <el-dropdown-item divided @click="handleLogout">
              <el-icon class="mr-2">
                <SwitchButton />
              </el-icon>
              退出登录
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </header>
</template>
