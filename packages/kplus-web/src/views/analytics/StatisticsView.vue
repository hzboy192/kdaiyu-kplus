<script setup lang="ts">
import { ref } from 'vue'
import { ElTable, ElTableColumn, ElTag, ElButton, ElSelect, ElOption, ElDatePicker, ElPagination, ElIcon } from 'element-plus'
import { View, Download, Filter } from '@element-plus/icons-vue'

const currentAccount = ref('all')
const dateRange = ref<[Date, Date] | null>(null)
const currentPage = ref(1)
const pageSize = ref(10)

interface TradeRecord {
  id
  date
  account
  accountColor
  symbol
  direction: 'buy' | 'sell'
  openPrice
  closePrice
  profit
  profitRate
}

const tradeRecords = ref<TradeRecord[]>([
  {
    id: '1',
    date: '2024-01-15',
    account: '默认账户',
    accountColor: 'primary',
    symbol: '上证指数',
    direction: 'buy',
    openPrice: 3045.2,
    closePrice: 3102.5,
    profit: 1200,
    profitRate: 1.88
  },
  {
    id: '2',
    date: '2024-01-14',
    account: '策略测试',
    accountColor: 'purple',
    symbol: '创业板指',
    direction: 'sell',
    openPrice: 1892.4,
    closePrice: 1875.2,
    profit: 860,
    profitRate: 0.91
  },
  {
    id: '3',
    date: '2024-01-13',
    account: '默认账户',
    accountColor: 'primary',
    symbol: '科创50',
    direction: 'buy',
    openPrice: 892.5,
    closePrice: 885.3,
    profit: -720,
    profitRate: -0.81
  },
  {
    id: '4',
    date: '2024-01-12',
    account: '默认账户',
    accountColor: 'primary',
    symbol: '深证成指',
    direction: 'sell',
    openPrice: 10234.5,
    closePrice: 10189.2,
    profit: 450,
    profitRate: 0.44
  },
  {
    id: '5',
    date: '2024-01-11',
    account: '策略测试',
    accountColor: 'purple',
    symbol: '上证指数',
    direction: 'buy',
    openPrice: 3012.8,
    closePrice: 3045.2,
    profit: 1680,
    profitRate: 1.08
  },
  {
    id: '6',
    date: '2024-01-10',
    account: '默认账户',
    accountColor: 'primary',
    symbol: '创业板指',
    direction: 'buy',
    openPrice: 1905.6,
    closePrice: 1892.4,
    profit: -660,
    profitRate: -0.69
  }
])

const summaryStats = [
  { label: '总交易次数', value: '128次' },
  { label: '盈利次数', value: '84次' },
  { label: '亏损次数', value: '44次' },
  { label: '总盈亏', value: '+¥25,800' }
]
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-gray-800">交易统计</h2>
        <p class="text-gray-500 text-sm mt-1">详细的交易记录和胜率分析</p>
      </div>
      <div class="flex gap-2">
        <el-button class="!rounded-xl">
          <el-icon class="mr-1"><Download /></el-icon>
          导出报表
        </el-button>
        <el-button type="primary" class="!rounded-xl">
          <el-icon class="mr-1"><Filter /></el-icon>
          筛选
        </el-button>
      </div>
    </div>

    <!-- Summary Stats -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div v-for="stat in summaryStats" :key="stat.label" class="bg-white rounded-xl p-4 border border-gray-100">
        <p class="text-sm text-gray-500">{{ stat.label }}</p>
        <p class="text-xl font-bold text-gray-800 mt-1">{{ stat.value }}</p>
      </div>
    </div>

    <!-- Filters -->
    <div class="flex flex-wrap gap-4 bg-white p-4 rounded-xl border border-gray-100">
      <el-select v-model="currentAccount" placeholder="选择账户" class="!w-40">
        <el-option label="全部账户" value="all" />
        <el-option label="默认账户" value="default" />
        <el-option label="策略测试账户" value="strategy" />
      </el-select>
      <el-date-picker
        v-model="dateRange"
        type="daterange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        class="!w-64"
      />
      <el-select placeholder="交易方向" class="!w-32">
        <el-option label="全部" value="" />
        <el-option label="买入" value="buy" />
        <el-option label="卖出" value="sell" />
      </el-select>
      <el-select placeholder="盈亏状态" class="!w-32">
        <el-option label="全部" value="" />
        <el-option label="盈利" value="profit" />
        <el-option label="亏损" value="loss" />
      </el-select>
    </div>

    <!-- Table -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <el-table
        :data="tradeRecords"
        style="width: 100%"
        :header-cell-style="{ backgroundColor: '#f8fafc', color: '#64748b', fontWeight: '500' }"
      >
        <el-table-column prop="date" label="日期" width="120" />
        <el-table-column label="账户" width="120">
          <template #default="{ row }">
            <el-tag :type="row.accountColor === 'primary' ? 'primary' : 'warning'" size="small" effect="light">
              {{ row.account }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="symbol" label="品种" width="120" />
        <el-table-column label="方向" width="100">
          <template #default="{ row }">
            <el-tag :type="row.direction === 'buy' ? 'danger' : 'success'" size="small">
              {{ row.direction === 'buy' ? '买入' : '卖出' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="openPrice" label="开仓价" width="120">
          <template #default="{ row }">
            {{ row.openPrice.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="closePrice" label="平仓价" width="120">
          <template #default="{ row }">
            {{ row.closePrice.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column label="盈亏" width="120">
          <template #default="{ row }">
            <span class="font-semibold" :class="row.profit >= 0 ? 'text-red-500' : 'text-green-500'">
              {{ row.profit >= 0 ? '+' : '' }}¥{{ row.profit }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="收益率" width="100">
          <template #default="{ row }">
            <span :class="row.profitRate >= 0 ? 'text-red-500' : 'text-green-500'">
              {{ row.profitRate >= 0 ? '+' : '' }}{{ row.profitRate }}%
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="80" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">
              <el-icon><View /></el-icon>
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- Pagination -->
      <div class="flex justify-between items-center p-4 border-t border-gray-100">
        <span class="text-sm text-gray-500">共 128 条记录</span>
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="sizes, prev, pager, next"
          :total="128"
        />
      </div>
    </div>
  </div>
</template>
