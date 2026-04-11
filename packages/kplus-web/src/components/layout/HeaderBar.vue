<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElBadge, ElDropdown, ElDropdownMenu, ElDropdownItem, ElAvatar, ElIcon, ElSelect, ElOption, ElMessage } from 'element-plus'
import { Bell, Setting, SwitchButton, User, Wallet } from '@element-plus/icons-vue'
import useUserStore from '@s/user'

const router = useRouter()
const userStore = useUserStore()

defineProps({
  title: String
})

const emit = defineEmits(['toggle-sidebar'])

const currentAccount = ref('default')

// 退出登录
const handleLogout = () => {
  userStore.logout().then(() => {
    ElMessage.success('退出登录成功')
    router.push('/login')
  }).catch(() => {
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
  <header class="h-16 bg-white border-b border-gray-100 px-6 flex items-center justify-between sticky top-0 z-40">
    <!-- Left: Page Title -->
    <div class="flex items-center gap-4">
      <h1 class="text-xl font-bold text-gray-800">{{ title }}</h1>
    </div>

    <!-- Right: Actions -->
    <div class="flex items-center gap-4">
      <!-- Account Selector -->
      <div class="flex items-center gap-2 px-3 py-1.5 bg-primary-50 rounded-lg border border-primary-100">
        <el-icon class="text-primary-500">
          <Wallet />
        </el-icon>
        <el-select v-model="currentAccount" size="small" style="width: 160px" :teleported="false">
          <el-option v-for="account in accounts" :key="account.id"
            :label="`${account.name} (¥${account.balance.toLocaleString()})`" :value="account.id"
            :disabled="account.disabled" />
        </el-select>
      </div>

      <!-- Notifications -->
      <el-dropdown trigger="click" :teleported="false">
        <button class="relative p-2 text-gray-500 hover:text-gray-700 hover:bg-gray-100 rounded-lg transition-colors">
          <el-icon :size="22">
            <Bell />
          </el-icon>
          <span v-if="unreadCount > 0" class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
        </button>
        <template #dropdown>
          <div class="w-80">
            <div class="px-4 py-3 border-b border-gray-100">
              <div class="flex items-center justify-between">
                <span class="font-semibold text-gray-800">通知消息</span>
                <span class="text-xs text-primary-600 cursor-pointer hover:underline">全部已读</span>
              </div>
            </div>
            <div class="max-h-80 overflow-y-auto">
              <div v-for="notification in notifications" :key="notification.id"
                class="px-4 py-3 hover:bg-gray-50 cursor-pointer border-b border-gray-50 last:border-0"
                :class="{ 'bg-primary-50/50': !notification.read }">
                <div class="flex items-start gap-3">
                  <div class="w-2 h-2 rounded-full mt-2 flex-shrink-0"
                    :class="notification.read ? 'bg-gray-300' : 'bg-primary-500'"></div>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-800">{{ notification.title }}</p>
                    <p class="text-xs text-gray-500 mt-0.5 truncate">{{ notification.content }}</p>
                    <p class="text-xs text-gray-400 mt-1">{{ notification.time }}</p>
                  </div>
                </div>
              </div>
            </div>
            <div class="px-4 py-2 border-t border-gray-100 text-center">
              <span class="text-sm text-primary-600 cursor-pointer hover:underline">查看全部</span>
            </div>
          </div>
        </template>
      </el-dropdown>

      <!-- User Menu -->
      <el-dropdown trigger="click" :teleported="false">
        <div class="flex items-center gap-3 cursor-pointer hover:bg-gray-50 rounded-xl px-2 py-1.5 transition-colors">
          <el-avatar :size="38" src="https://api.dicebear.com/7.x/avataaars/svg?seed=Felix"
            class="border-2 border-primary-100" />
          <div class="hidden md:block">
            <p class="text-sm font-semibold text-gray-800">泊远万里</p>
            <p class="text-xs text-gray-500">VIP会员</p>
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
