<script setup lang="ts">
import { ref, computed } from 'vue'
import {
  ElButton,
  ElInput,
  ElSelect,
  ElOption,
  ElDialog,
  ElForm,
  ElFormItem,
  ElAlert,
  ElPopconfirm,
  ElTable,
  ElTableColumn,
  ElIcon
} from 'element-plus'
import { Plus, Search, Edit, Delete, Sort } from '@element-plus/icons-vue'

interface Account {
  id: string
  name: string
  type: string
  balance: number
  profit: number
  profitRate: number
  status: 'active' | 'disabled' | 'default'
  createdAt: string
}

const searchQuery = ref('')
const statusFilter = ref('')
const typeFilter = ref('')
const showCreateDialog = ref(false)
const editingId = ref<string | null>(null)

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

const filteredAccounts = computed(() => {
  return accounts.value.filter((a) => {
    if (searchQuery.value && !a.name.includes(searchQuery.value)) return false
    if (statusFilter.value === 'active' && a.status === 'disabled') return false
    if (statusFilter.value === 'disabled' && a.status !== 'disabled') return false
    if (typeFilter.value && a.type !== typeFilter.value) return false
    return true
  })
})

const dialogTitle = computed(() => (editingId.value ? '编辑账户' : '新建账户'))

const formatMoney = (value) => {
  return value.toLocaleString('zh-CN')
}

const openCreate = () => {
  editingId.value = null
  newAccount.value = { name: '', type: '股票账户', initialBalance: 100000 }
  showCreateDialog.value = true
}

const openEdit = (account: Account) => {
  editingId.value = account.id
  newAccount.value = { name: account.name, type: account.type, initialBalance: account.balance }
  showCreateDialog.value = true
}

const saveAccount = () => {
  if (!newAccount.value.name) return
  if (editingId.value) {
    const target = accounts.value.find((a) => a.id === editingId.value)
    if (target) {
      target.name = newAccount.value.name
      target.type = newAccount.value.type
      target.balance = newAccount.value.initialBalance
    }
  } else {
    accounts.value.push({
      id: String(Date.now()),
      name: newAccount.value.name,
      type: newAccount.value.type,
      balance: newAccount.value.initialBalance,
      profit: 0,
      profitRate: 0,
      status: 'active',
      createdAt: new Date().toISOString().slice(0, 10)
    })
  }
  showCreateDialog.value = false
}

const setDefault = (account: Account) => {
  accounts.value.forEach((a) => {
    a.status = a.id === account.id ? 'default' : a.status === 'default' ? 'active' : a.status
  })
}

const removeAccount = (account: Account) => {
  accounts.value = accounts.value.filter((a) => a.id !== account.id)
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-semibold text-ink">账户管理</h2>
        <p class="text-ink-secondary text-sm mt-1">多账户体系：支持股票、期货、期权等账户类型，独立核算盈亏</p>
      </div>
      <div class="flex items-center gap-3">
        <router-link to="/main/transfer" class="ghost-btn">
          <el-icon :size="14"><Sort /></el-icon>
          资金调拨
        </router-link>
        <el-button class="ghost-btn" @click="openCreate">
          <el-icon :size="14"><Plus /></el-icon>
          新建账户
        </el-button>
      </div>
    </div>

    <!-- Filters -->
    <div class="flex flex-wrap gap-4">
      <el-input v-model="searchQuery" placeholder="搜索账户名称" :prefix-icon="Search" clearable class="!w-64" />
      <el-select v-model="statusFilter" placeholder="全部状态" clearable class="!w-32">
        <el-option label="正常" value="active" />
        <el-option label="已禁用" value="disabled" />
      </el-select>
      <el-select v-model="typeFilter" placeholder="全部类型" clearable class="!w-32">
        <el-option label="股票账户" value="股票账户" />
        <el-option label="期货账户" value="期货账户" />
        <el-option label="期权账户" value="期权账户" />
      </el-select>
    </div>

    <!-- Account Table -->
    <div class="bg-panel border border-line rounded-md overflow-hidden">
      <el-table :data="filteredAccounts" style="width: 100%" class="account-table">
        <el-table-column label="账户名称" min-width="180">
          <template #default="{ row }">
            <p class="text-sm text-ink">{{ row.name }}</p>
            <p class="text-xs text-ink-faint mt-0.5">创建于 {{ row.createdAt }}</p>
          </template>
        </el-table-column>
        <el-table-column prop="type" label="类型" width="120">
          <template #default="{ row }">
            <span class="text-sm text-ink-secondary">{{ row.type }}</span>
          </template>
        </el-table-column>
        <el-table-column label="余额" width="150">
          <template #default="{ row }">
            <span class="text-sm text-ink font-mono tabular-nums">¥{{ formatMoney(row.balance) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="盈亏" width="160">
          <template #default="{ row }">
            <p
              class="text-sm font-medium font-mono tabular-nums"
              :class="row.profit > 0 ? 'text-up' : row.profit < 0 ? 'text-down' : 'text-ink-secondary'"
            >
              {{ row.profit > 0 ? '+' : '' }}¥{{ formatMoney(row.profit) }}
            </p>
            <p
              class="text-xs mt-0.5 font-mono tabular-nums"
              :class="row.profitRate > 0 ? 'text-up/80' : row.profitRate < 0 ? 'text-down/80' : 'text-ink-faint'"
            >
              {{ row.profitRate > 0 ? '+' : '' }}{{ row.profitRate.toFixed(2) }}%
            </p>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="110">
          <template #default="{ row }">
            <span class="inline-flex items-center gap-1.5 text-xs">
              <span
                class="w-1.5 h-1.5 rounded-full"
                :class="{
                  'bg-primary-500': row.status === 'default',
                  'bg-down': row.status === 'active',
                  'bg-ink-faint': row.status === 'disabled'
                }"
              ></span>
              <span :class="row.status === 'disabled' ? 'text-ink-faint' : 'text-ink-secondary'">
                {{ row.status === 'default' ? '默认' : row.status === 'active' ? '正常' : '已禁用' }}
              </span>
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" align="right">
          <template #default="{ row }">
            <div class="flex items-center justify-end gap-4">
              <el-button
                link
                size="small"
                class="!text-xs !text-primary-400 hover:!text-primary-300"
                :disabled="row.status === 'default'"
                @click="setDefault(row)"
              >
                设默认
              </el-button>
              <el-button link size="small" class="!text-xs !text-ink-secondary hover:!text-ink" @click="openEdit(row)"> 编辑 </el-button>
              <el-popconfirm title="确定要删除此账户吗？" confirm-button-text="确定" cancel-button-text="取消">
                <template #reference>
                  <el-button link size="small" class="!text-xs !text-up hover:!opacity-80" :disabled="row.status === 'default'">
                    删除
                  </el-button>
                </template>
              </el-popconfirm>
            </div>
          </template>
        </el-table-column>
        <template #empty>
          <span class="text-ink-faint text-sm">暂无匹配的账户</span>
        </template>
      </el-table>
    </div>

    <!-- Info Alert -->
    <el-alert type="info" :closable="false" show-icon>
      <template #title>
        <span class="font-medium">账户使用说明</span>
      </template>
      <div class="text-sm mt-1 space-y-1">
        <p>默认账户：新用户自动创建，用于日常训练</p>
        <p>多账户隔离：不同账户之间的资金和交易记录完全独立</p>
        <p>账户切换：在K线训练场和数据中心可切换当前统计账户</p>
        <p>删除账户：删除后数据保留30天，期间可申请恢复</p>
      </div>
    </el-alert>

    <!-- Create / Edit Account Dialog -->
    <el-dialog v-model="showCreateDialog" :title="dialogTitle" width="480" :close-on-click-modal="false">
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
        <el-button type="primary" @click="saveAccount">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.ghost-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 34px;
  padding: 0 14px;
  border-radius: 4px;
  border: 1px solid rgba(255, 255, 255, 0.14);
  background: transparent;
  color: #9aa0a6;
  font-size: 13px;
  transition: all 0.15s;
}

.ghost-btn:hover {
  border-color: #2962ff;
  background: #2962ff;
  color: #ffffff;
}

.account-table {
  --el-table-bg-color: transparent;
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;
}
</style>
