<script setup>
import { ref, computed } from 'vue'
import { ElCard, ElSelect, ElOption, ElInputNumber, ElButton, ElTable, ElTableColumn, ElTag, ElIcon, ElAlert } from 'element-plus'
import { Right, Wallet, Clock, Check } from '@element-plus/icons-vue'

const fromAccount = ref('default')
const toAccount = ref('')
const amount = ref(0)

const accounts = ref([
  { id: 'default', name: '默认账户', balance: 100000 },
  { id: 'strategy', name: '策略测试账户', balance: 55000 },
  { id: 'futures', name: '期货交易账户', balance: 30000, disabled: true }
])

const transferHistory = ref([
  { id: 1, date: '2024-01-15 14:30', from: '默认账户', to: '策略测试账户', amount: 10000, status: 'success' },
  { id: 2, date: '2024-01-10 09:15', from: '策略测试账户', to: '默认账户', amount: 5000, status: 'success' },
  { id: 3, date: '2024-01-05 16:45', from: '默认账户', to: '期货交易账户', amount: 20000, status: 'success' }
])

const fromAccountData = computed(() => accounts.value.find(a => a.id === fromAccount.value))
const toAccountData = computed(() => accounts.value.find(a => a.id === toAccount.value))
const availableToAccounts = computed(() => accounts.value.filter(a => a.id !== fromAccount.value && !a.disabled))

const handleTransfer = () => {
  // Transfer logic here
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div>
      <h2 class="text-xl font-bold text-gray-800">资金调拨</h2>
      <p class="text-gray-500 text-sm mt-1">在不同账户之间转移资金</p>
    </div>

    <!-- Transfer Form -->
    <div class="bg-white rounded-2xl border border-gray-100 p-6">
      <h3 class="text-lg font-semibold text-gray-800 mb-6">发起调拨</h3>
      
      <div class="flex flex-col md:flex-row items-center gap-4">
        <!-- From Account -->
        <div class="flex-1 w-full">
          <label class="block text-sm font-medium text-gray-700 mb-2">转出账户</label>
          <el-select v-model="fromAccount" class="!w-full" size="large">
            <el-option 
              v-for="account in accounts.filter(a => !a.disabled)" 
              :key="account.id"
              :label="`${account.name} (¥${account.balance.toLocaleString()})`"
              :value="account.id"
            />
          </el-select>
          <p v-if="fromAccountData" class="text-sm text-gray-500 mt-2">
            可用余额: <span class="font-semibold text-gray-800">¥{{ fromAccountData.balance.toLocaleString() }}</span>
          </p>
        </div>

        <!-- Arrow -->
        <div class="flex-shrink-0 w-12 h-12 bg-primary-100 rounded-full flex items-center justify-center text-primary-600">
          <el-icon :size="24"><Right /></el-icon>
        </div>

        <!-- To Account -->
        <div class="flex-1 w-full">
          <label class="block text-sm font-medium text-gray-700 mb-2">转入账户</label>
          <el-select v-model="toAccount" class="!w-full" size="large" placeholder="选择转入账户">
            <el-option 
              v-for="account in availableToAccounts" 
              :key="account.id"
              :label="`${account.name} (¥${account.balance.toLocaleString()})`"
              :value="account.id"
            />
          </el-select>
          <p v-if="toAccountData" class="text-sm text-gray-500 mt-2">
            当前余额: <span class="font-semibold text-gray-800">¥{{ toAccountData.balance.toLocaleString() }}</span>
          </p>
        </div>
      </div>

      <!-- Amount -->
      <div class="mt-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">调拨金额</label>
        <div class="flex gap-4">
          <el-input-number 
            v-model="amount" 
            :min="0" 
            :max="fromAccountData?.balance || 0"
            :step="1000"
            size="large"
            class="!w-64"
          />
          <div class="flex gap-2">
            <el-button @click="amount = (fromAccountData?.balance || 0) * 0.25">25%</el-button>
            <el-button @click="amount = (fromAccountData?.balance || 0) * 0.5">50%</el-button>
            <el-button @click="amount = (fromAccountData?.balance || 0) * 0.75">75%</el-button>
            <el-button @click="amount = fromAccountData?.balance || 0">全部</el-button>
          </div>
        </div>
      </div>

      <!-- Submit -->
      <div class="mt-6 pt-6 border-t border-gray-100 flex justify-end">
        <el-button 
          type="primary" 
          size="large"
          :disabled="!toAccount || amount <= 0"
          @click="handleTransfer"
          class="!px-8 !rounded-xl"
        >
          确认调拨
        </el-button>
      </div>
    </div>

    <!-- Transfer History -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-100 flex items-center gap-3">
        <el-icon class="text-primary-600" :size="20"><Clock /></el-icon>
        <h3 class="font-semibold text-gray-800">调拨记录</h3>
      </div>
      <el-table :data="transferHistory" style="width: 100%">
        <el-table-column prop="date" label="时间" width="180" />
        <el-table-column prop="from" label="转出账户" width="150" />
        <el-table-column prop="to" label="转入账户" width="150" />
        <el-table-column label="金额">
          <template #default="{ row }">
            <span class="font-semibold text-gray-800">¥{{ row.amount.toLocaleString() }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag type="success" size="small">
              <el-icon class="mr-1"><Check /></el-icon>
              成功
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- Info -->
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="!rounded-xl"
    >
      <template #title>调拨说明</template>
      <div class="text-sm mt-1">
        账户间资金调拨实时到账，不收取手续费。调拨记录将保留在系统中供您查阅。
      </div>
    </el-alert>
  </div>
</template>
