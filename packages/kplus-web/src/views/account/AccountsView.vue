<script setup lang="ts">
import { ref } from 'vue'
import {
  ElCard,
  ElButton,
  ElInput,
  ElSelect,
  ElOption,
  ElTag,
  ElIcon,
  ElDialog,
  ElForm,
  ElFormItem,
  ElAlert,
  ElPopconfirm
} from 'element-plus'
import { Plus, Search, View, Edit, Delete, CircleCheck, VideoPause } from '@element-plus/icons-vue'

interface Account {
  id
  name
  type
  balance
  profit
  profitRate
  status: 'active' | 'disabled' | 'default'
  createdAt
}

const searchQuery = ref('')
const statusFilter = ref('')
const typeFilter = ref('')
const showCreateDialog = ref(false)

const accounts = ref<Account[]>([
  {
    id: '1',
    name: '默认账户',
    type: '股票账户',
    balance: 100000,
    profit: 0,
    profitRate: 0,
    status: 'default',
    createdAt: '2024-01-01'
  },
  {
    id: '2',
    name: '策略测试账户',
    type: '股票账户',
    balance: 50000,
    profit: 5000,
    profitRate: 11.1,
    status: 'active',
    createdAt: '2024-02-15'
  },
  {
    id: '3',
    name: '期货交易账户',
    type: '期货账户',
    balance: 30000,
    profit: -10000,
    profitRate: -25.0,
    status: 'disabled',
    createdAt: '2024-03-10'
  }
])

const newAccount = ref({
  name: '',
  type: '股票账户',
  initialBalance: 100000
})

const formatMoney = (value) => {
  return value.toLocaleString('zh-CN')
}

const getStatusTag = (status) => {
  switch (status) {
    case 'default':
      return { text: '默认', type: 'primary' }
    case 'active':
      return { text: '正常', type: 'success' }
    case 'disabled':
      return { text: '已禁用', type: 'info' }
    default:
      return { text: '未知', type: 'info' }
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-gray-800">账户管理</h2>
        <p class="text-gray-500 text-sm mt-1">多账户体系：支持股票、期货、期权等账户类型，独立核算盈亏</p>
      </div>
      <el-button type="primary" @click="showCreateDialog = true" class="!rounded-xl">
        <el-icon class="mr-1"><Plus /></el-icon>
        创建账户
      </el-button>
    </div>

    <!-- Filters -->
    <div class="flex flex-wrap gap-4">
      <el-input v-model="searchQuery" placeholder="搜索账户名称" :prefix-icon="Search" clearable class="!w-64" />
      <el-select v-model="statusFilter" placeholder="全部状态" clearable class="!w-32">
        <el-option label="正常" value="active" />
        <el-option label="已禁用" value="disabled" />
      </el-select>
      <el-select v-model="typeFilter" placeholder="全部类型" clearable class="!w-32">
        <el-option label="股票账户" value="stock" />
        <el-option label="期货账户" value="futures" />
        <el-option label="期权账户" value="options" />
      </el-select>
    </div>

    <!-- Account Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Account Cards -->
      <div
        v-for="account in accounts"
        :key="account.id"
        class="bg-white rounded-2xl p-6 border-2 transition-all duration-200 relative"
        :class="[
          account.status === 'default'
            ? 'border-primary-500 bg-primary-50/30'
            : account.status === 'disabled'
              ? 'border-gray-200 bg-gray-50 opacity-75'
              : 'border-gray-200 hover:border-gray-300 hover:shadow-md'
        ]"
      >
        <!-- Status Badge -->
        <div v-if="account.status === 'default'" class="absolute -top-3 left-6">
          <el-tag type="primary" effect="dark" size="small" round>默认</el-tag>
        </div>
        <div v-else-if="account.status === 'disabled'" class="absolute -top-3 left-6">
          <el-tag type="info" effect="dark" size="small" round>已禁用</el-tag>
        </div>

        <!-- Header -->
        <div class="flex justify-between items-start mb-4">
          <div>
            <h3 class="text-lg font-bold text-gray-800">{{ account.name }}</h3>
            <el-tag size="small" type="info" class="mt-1">{{ account.type }}</el-tag>
          </div>
          <div class="flex gap-1">
            <el-button text circle size="small">
              <el-icon><View /></el-icon>
            </el-button>
            <el-button text circle size="small">
              <el-icon><Edit /></el-icon>
            </el-button>
            <el-button v-if="account.status === 'disabled'" text circle size="small" type="success">
              <el-icon><CircleCheck /></el-icon>
            </el-button>
            <el-button v-else-if="account.status !== 'default'" text circle size="small" type="warning">
              <el-icon><VideoPause /></el-icon>
            </el-button>
            <el-popconfirm title="确定要删除此账户吗？" confirm-button-text="确定" cancel-button-text="取消">
              <template #reference>
                <el-button text circle size="small" type="danger" :disabled="account.status === 'default'">
                  <el-icon><Delete /></el-icon>
                </el-button>
              </template>
            </el-popconfirm>
          </div>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-2 gap-4 mb-4">
          <div>
            <p class="text-xs text-gray-500 mb-1">账户余额</p>
            <p class="text-xl font-bold text-gray-800">¥{{ formatMoney(account.balance) }}</p>
          </div>
          <div>
            <p class="text-xs text-gray-500 mb-1">账户盈亏</p>
            <p class="text-xl font-bold" :class="account.profit >= 0 ? 'text-red-500' : 'text-green-500'">
              {{ account.profit >= 0 ? '+' : '' }}¥{{ formatMoney(account.profit) }}
            </p>
            <p class="text-xs" :class="account.profitRate >= 0 ? 'text-red-400' : 'text-green-400'">
              {{ account.profitRate >= 0 ? '+' : '' }}{{ account.profitRate.toFixed(2) }}%
            </p>
          </div>
        </div>

        <!-- Footer -->
        <div class="flex justify-between items-center pt-4 border-t border-gray-100">
          <span class="text-xs text-gray-400">创建时间: {{ account.createdAt }}</span>
          <el-button v-if="account.status !== 'disabled'" type="primary" link size="small">
            {{ account.status === 'default' ? '当前交易账户' : '切换到此账户' }}
          </el-button>
          <span v-else class="text-xs text-gray-400">暂停使用</span>
        </div>
      </div>

      <!-- Create New Account Card -->
      <div
        @click="showCreateDialog = true"
        class="border-2 border-dashed border-gray-300 rounded-2xl p-6 flex flex-col items-center justify-center text-gray-400 hover:border-primary-400 hover:text-primary-600 cursor-pointer transition-all min-h-[200px]"
      >
        <el-icon :size="48" class="mb-2"><Plus /></el-icon>
        <span class="font-medium">创建新账户</span>
        <span class="text-xs mt-1">支持股票、期货、期权等</span>
      </div>
    </div>

    <!-- Info Alert -->
    <el-alert type="info" :closable="false" show-icon class="!rounded-xl">
      <template #title>
        <span class="font-semibold">账户使用说明</span>
      </template>
      <div class="text-sm mt-1 space-y-1">
        <p>默认账户：新用户自动创建，用于日常训练</p>
        <p>多账户隔离：不同账户之间的资金和交易记录完全独立</p>
        <p>账户切换：在K线训练场和数据中心可切换当前统计账户</p>
        <p>删除账户：删除后数据保留30天，期间可申请恢复</p>
      </div>
    </el-alert>

    <!-- Create Account Dialog -->
    <el-dialog v-model="showCreateDialog" title="创建新账户" width="480" :close-on-click-modal="false">
      <el-form :model="newAccount" label-position="top">
        <el-form-item label="账户名称" required>
          <el-input v-model="newAccount.name" placeholder="请输入账户名称" />
        </el-form-item>
        <el-form-item label="账户类型" required>
          <el-select v-model="newAccount.type" class="!w-full">
            <el-option label="股票账户" value="股票账户" />
            <el-option label="期货账户" value="期货账户" />
            <el-option label="期权账户" value="期权账户" />
          </el-select>
        </el-form-item>
        <el-form-item label="初始资金">
          <el-input v-model.number="newAccount.initialBalance" type="number">
            <template #prepend>¥</template>
          </el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="showCreateDialog = false">创建</el-button>
      </template>
    </el-dialog>
  </div>
</template>
