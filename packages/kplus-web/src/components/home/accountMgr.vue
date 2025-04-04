<script setup>
import { ref, onMounted, computed } from 'vue'
import * as echarts from 'echarts'
import { Plus, Edit, Delete, Check, View, Close } from '@element-plus/icons-vue'

// 模拟数据 - 实际项目中应从API获取
const accounts = ref([
  {
    id: '1',
    name: '默认账户',
    balance: 100000,
    initialBalance: 100000,
    profit: 0,
    profitRate: 0,
    isDefault: true,
    status: 'active',
    createTime: '2024-01-01',
    type: 'stock'
  },
  {
    id: '2',
    name: '策略测试账户',
    balance: 50000,
    initialBalance: 45000,
    profit: 5000,
    profitRate: 11.1,
    isDefault: false,
    status: 'active',
    createTime: '2024-02-15',
    type: 'stock'
  },
  {
    id: '3',
    name: '期货交易账户',
    balance: 30000,
    initialBalance: 40000,
    profit: -10000,
    profitRate: -25,
    isDefault: false,
    status: 'inactive',
    createTime: '2024-03-10',
    type: 'futures'
  }
])

const accountTypes = [
  { label: '股票账户', value: 'stock' },
  { label: '期货账户', value: 'futures' }
]

// 搜索和筛选
const searchQuery = ref('')
const statusFilter = ref('all')
const typeFilter = ref('all')

// 过滤后的账户列表
const filteredAccounts = computed(() => {
  return accounts.value.filter(account => {
    const matchesSearch = account.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesStatus = statusFilter.value === 'all' || account.status === statusFilter.value
    const matchesType = typeFilter.value === 'all' || account.type === typeFilter.value
    return matchesSearch && matchesStatus && matchesType
  })
})

// 对话框控制
const dialogVisible = ref(false)
const dialogType = ref('create') // create or edit
const selectedAccount = ref(null)

// 表单数据
const form = ref({
  name: '',
  initialBalance: 10000,
  type: 'stock',
  remark: ''
})

// 表单规则
const rules = {
  name: [
    { required: true, message: '请输入账户名称', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  initialBalance: [
    { required: true, message: '请输入初始资金', trigger: 'blur' },
    { type: 'number', min: 1000, message: '初始资金不能小于1000', trigger: 'blur' }
  ],
  type: [
    { required: true, message: '请选择账户类型', trigger: 'change' }
  ]
}

const formRef = ref(null)

// 打开创建账户对话框
const openCreateDialog = () => {
  dialogType.value = 'create'
  form.value = {
    name: '',
    initialBalance: 10000,
    type: 'stock',
    remark: ''
  }
  dialogVisible.value = true
}

// 打开编辑账户对话框
const openEditDialog = (account) => {
  dialogType.value = 'edit'
  selectedAccount.value = account
  form.value = {
    name: account.name,
    initialBalance: account.initialBalance,
    type: account.type,
    remark: ''
  }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === 'create') {
        // 创建新账户
        const newAccount = {
          id: String(accounts.value.length + 1),
          name: form.value.name,
          balance: form.value.initialBalance,
          initialBalance: form.value.initialBalance,
          profit: 0,
          profitRate: 0,
          isDefault: accounts.value.length === 0, // 如果是第一个账户，则设为默认
          status: 'active',
          createTime: new Date().toISOString().split('T')[0],
          type: form.value.type
        }
        accounts.value.push(newAccount)
        ElMessage.success('账户创建成功')
      } else {
        // 更新账户
        const index = accounts.value.findIndex(acc => acc.id === selectedAccount.value.id)
        if (index !== -1) {
          accounts.value[index] = {
            ...accounts.value[index],
            name: form.value.name,
            type: form.value.type
          }
          ElMessage.success('账户更新成功')
        }
      }
      dialogVisible.value = false
    }
  })
}

// 设为默认账户
const setAsDefault = (account) => {
  accounts.value.forEach(acc => {
    acc.isDefault = acc.id === account.id
  })
  ElMessage.success(`已将 ${account.name} 设为默认账户`)
}

// 切换账户状态
const toggleAccountStatus = (account) => {
  account.status = account.status === 'active' ? 'inactive' : 'active'
  const statusText = account.status === 'active' ? '启用' : '禁用'
  ElMessage.success(`账户 ${account.name} 已${statusText}`)
}

// 删除账户
const deleteAccount = (account) => {
  ElMessageBox.confirm(
    `确定要删除账户 ${account.name} 吗？此操作不可逆。`,
    '删除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      const index = accounts.value.findIndex(acc => acc.id === account.id)
      if (index !== -1) {
        accounts.value.splice(index, 1)
        ElMessage.success('账户已删除')
      }
    })
    .catch(() => {
      // 取消删除
    })
}

// 选中的账户用于详情查看
const currentAccount = ref(null)
const detailsVisible = ref(false)

// 查看账户详情
const viewAccountDetails = (account) => {
  currentAccount.value = account
  detailsVisible.value = true
  // 需要在DOM更新后初始化图表
  setTimeout(() => {
    initBalanceChart()
  }, 100)
}

// 初始化资金曲线图表
const initBalanceChart = () => {
  const chartDom = document.getElementById('balanceChart')
  if (!chartDom) return
  
  const myChart = echarts.init(chartDom)
  const option = {
    title: {
      text: '资金曲线',
      left: 'center',
      textStyle: {
        fontSize: 14
      }
    },
    tooltip: {
      trigger: 'axis',
      formatter: '{b}: {c}元'
    },
    xAxis: {
      type: 'category',
      data: getDates(30),
      axisLine: {
        lineStyle: {
          color: '#E5E7EB'
        }
      }
    },
    yAxis: {
      type: 'value',
      name: '资金(元)',
      splitLine: {
        lineStyle: {
          color: '#E5E7EB'
        }
      }
    },
    series: [{
      name: '账户资金',
      type: 'line',
      data: generateBalanceData(currentAccount.value.initialBalance, currentAccount.value.balance, 30),
      smooth: true,
      lineStyle: {
        width: 2,
        color: '#409EFF'
      },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [{
            offset: 0,
            color: 'rgba(64, 158, 255, 0.5)'
          }, {
            offset: 1,
            color: 'rgba(64, 158, 255, 0.1)'
          }]
        }
      }
    }]
  }
  myChart.setOption(option)
}

// 生成过去n天的日期
const getDates = (days) => {
  const dates = []
  const today = new Date()
  for (let i = days - 1; i >= 0; i--) {
    const date = new Date(today)
    date.setDate(date.getDate() - i)
    dates.push(date.toLocaleDateString('zh-CN', { month: 'numeric', day: 'numeric' }))
  }
  return dates
}

// 生成模拟的资金曲线数据
const generateBalanceData = (initialBalance, currentBalance, days) => {
  const data = []
  const diff = currentBalance - initialBalance
  
  for (let i = 0; i < days; i++) {
    const progress = i / (days - 1)
    let value
    
    if (diff >= 0) {
      // 上升曲线，加一点波动
      value = initialBalance + diff * (progress ** 1.2) + (Math.random() - 0.5) * diff * 0.2
    } else {
      // 下降曲线，加一点波动
      value = initialBalance + diff * (progress ** 0.8) + (Math.random() - 0.5) * Math.abs(diff) * 0.2
    }
    
    data.push(Math.floor(value))
  }
  
  // 确保最后一个值正好是当前余额
  data[days - 1] = currentBalance
  
  return data
}

// 生成模拟的交易记录
const generateTradeRecords = () => {
  const records = []
  const types = ['买入', '卖出']
  const symbols = ['上证指数', '深证成指', '创业板指', '科创50']
  
  for (let i = 0; i < 5; i++) {
    const date = new Date()
    date.setDate(date.getDate() - i * 3)
    
    records.push({
      id: `TR${i+1}`,
      date: date.toLocaleDateString('zh-CN'),
      type: types[Math.floor(Math.random() * types.length)],
      symbol: symbols[Math.floor(Math.random() * symbols.length)],
      price: Math.floor(3000 + Math.random() * 1000) / 100,
      amount: Math.floor(1000 + Math.random() * 9000),
      profit: Math.floor(Math.random() * 2000 - 1000)
    })
  }
  
  return records
}

const tradeRecords = ref(generateTradeRecords())
</script>

<template>
  <div class="account-manager">
    <div class="page-header">
      <div class="page-title">账户管理</div>
      <div class="page-actions">
        <el-button type="primary" :icon="Plus" @click="openCreateDialog">创建账户</el-button>
      </div>
    </div>
    
    <el-card class="filter-card" shadow="hover">
      <div class="filter-container">
        <el-input
          v-model="searchQuery"
          placeholder="搜索账户名称"
          class="search-input"
          clearable
        />
        <el-select v-model="statusFilter" placeholder="账户状态" class="filter-select">
          <el-option label="全部状态" value="all" />
          <el-option label="启用" value="active" />
          <el-option label="禁用" value="inactive" />
        </el-select>
        <el-select v-model="typeFilter" placeholder="账户类型" class="filter-select">
          <el-option label="全部类型" value="all" />
          <el-option v-for="type in accountTypes" :key="type.value" :label="type.label" :value="type.value" />
        </el-select>
      </div>
    </el-card>
    
    <div class="account-list">
      <el-card v-for="account in filteredAccounts" 
               :key="account.id" 
               class="account-card"
               :class="{ 'account-card-inactive': account.status === 'inactive' }"
               shadow="hover">
        <div class="account-header">
          <div class="account-name">
            {{ account.name }}
            <el-tag v-if="account.isDefault" effect="plain" type="primary" size="small" class="default-tag">默认</el-tag>
            <el-tag v-if="account.status === 'inactive'" effect="plain" type="info" size="small">已禁用</el-tag>
          </div>
          <div class="account-type">{{ accountTypes.find(t => t.value === account.type)?.label }}</div>
        </div>
        
        <div class="account-content">
          <div class="account-balance">
            <div class="balance-label">账户余额</div>
            <div class="balance-value">{{ account.balance.toLocaleString() }}元</div>
          </div>
          <div class="account-profit" :class="{ 'profit-positive': account.profit > 0, 'profit-negative': account.profit < 0 }">
            <div class="profit-label">账户盈亏</div>
            <div class="profit-value">{{ account.profit > 0 ? '+' : '' }}{{ account.profit.toLocaleString() }}元</div>
            <div class="profit-rate">{{ account.profitRate > 0 ? '+' : '' }}{{ account.profitRate.toFixed(2) }}%</div>
          </div>
        </div>
        
        <div class="account-footer">
          <div class="account-create-time">创建时间: {{ account.createTime }}</div>
          <div class="account-actions">
            <el-tooltip content="查看详情" placement="top" :hide-after="500">
              <el-button :icon="View" circle size="small" @click="viewAccountDetails(account)" />
            </el-tooltip>
            <el-tooltip content="编辑账户" placement="top" :hide-after="500">
              <el-button :icon="Edit" circle size="small" @click="openEditDialog(account)" />
            </el-tooltip>
            <el-tooltip :content="account.isDefault ? '默认账户' : '设为默认'" placement="top" :hide-after="500">
              <el-button :icon="Check" circle size="small" :type="account.isDefault ? 'success' : ''" 
                        :disabled="account.isDefault" @click="setAsDefault(account)" />
            </el-tooltip>
            <el-tooltip :content="account.status === 'active' ? '禁用账户' : '启用账户'" placement="top" :hide-after="500">
              <el-button :icon="account.status === 'active' ? Close : Check" circle size="small" 
                        :type="account.status === 'active' ? 'danger' : 'success'" @click="toggleAccountStatus(account)" />
            </el-tooltip>
            <el-tooltip content="删除账户" placement="top" :hide-after="500">
              <el-button :icon="Delete" circle size="small" type="danger" @click="deleteAccount(account)" />
            </el-tooltip>
          </div>
        </div>
      </el-card>
    </div>
    
    <!-- 创建/编辑账户对话框 -->
    <el-dialog
      :title="dialogType === 'create' ? '创建新账户' : '编辑账户'"
      v-model="dialogVisible"
      width="500px"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="账户名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入账户名称" />
        </el-form-item>
        <el-form-item label="账户类型" prop="type">
          <el-select v-model="form.type" placeholder="请选择账户类型" style="width: 100%">
            <el-option v-for="type in accountTypes" :key="type.value" :label="type.label" :value="type.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="初始资金" prop="initialBalance" :disabled="dialogType === 'edit'">
          <el-input-number v-model="form.initialBalance" :min="1000" :precision="2" :step="1000" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注信息（可选）" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确认</el-button>
      </template>
    </el-dialog>
    
    <!-- 账户详情抽屉 -->
    <el-drawer
      v-model="detailsVisible"
      title="账户详情"
      direction="rtl"
      size="60%"
    >
      <template v-if="currentAccount">
        <div class="account-details">
          <div class="details-header">
            <div class="details-title">
              {{ currentAccount.name }}
              <el-tag v-if="currentAccount.isDefault" effect="plain" type="primary" size="small">默认账户</el-tag>
              <el-tag v-if="currentAccount.status === 'inactive'" effect="plain" type="info" size="small">已禁用</el-tag>
            </div>
            <div class="details-type">{{ accountTypes.find(t => t.value === currentAccount.type)?.label }}</div>
          </div>
          
          <div class="details-cards">
            <el-card shadow="hover" class="detail-card">
              <div class="detail-card-content">
                <div class="detail-label">账户余额</div>
                <div class="detail-value">{{ currentAccount.balance.toLocaleString() }}元</div>
              </div>
            </el-card>
            <el-card shadow="hover" class="detail-card">
              <div class="detail-card-content">
                <div class="detail-label">初始资金</div>
                <div class="detail-value">{{ currentAccount.initialBalance.toLocaleString() }}元</div>
              </div>
            </el-card>
            <el-card shadow="hover" class="detail-card" 
                    :class="{ 'profit-positive-card': currentAccount.profit > 0, 'profit-negative-card': currentAccount.profit < 0 }">
              <div class="detail-card-content">
                <div class="detail-label">账户盈亏</div>
                <div class="detail-value">{{ currentAccount.profit > 0 ? '+' : '' }}{{ currentAccount.profit.toLocaleString() }}元</div>
                <div class="detail-rate">{{ currentAccount.profitRate > 0 ? '+' : '' }}{{ currentAccount.profitRate.toFixed(2) }}%</div>
              </div>
            </el-card>
          </div>
          
          <el-card shadow="hover" class="chart-card">
            <div id="balanceChart" style="width: 100%; height: 300px;"></div>
          </el-card>
          
          <el-card shadow="hover" class="records-card">
            <template #header>
              <div class="records-header">
                <div>最近交易记录</div>
                <el-button type="primary" link>查看全部</el-button>
              </div>
            </template>
            <el-table :data="tradeRecords" style="width: 100%" stripe>
              <el-table-column prop="date" label="交易日期" width="100" />
              <el-table-column prop="type" label="交易类型" width="80" />
              <el-table-column prop="symbol" label="交易品种" width="100" />
              <el-table-column prop="price" label="价格" width="80" />
              <el-table-column prop="amount" label="金额" width="100" />
              <el-table-column prop="profit" label="盈亏">
                <template #default="scope">
                  <span :class="{ 'profit-positive-text': scope.row.profit > 0, 'profit-negative-text': scope.row.profit < 0 }">
                    {{ scope.row.profit > 0 ? '+' : '' }}{{ scope.row.profit }}
                  </span>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </div>
      </template>
    </el-drawer>
  </div>
</template>

<style scoped>
.account-manager {
  min-height: 100%;
  height: auto;
  background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 100%);
  padding: 16px;
  display: flex;
  flex-direction: column;
  overflow: visible;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-shrink: 0;
}

.page-title {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
}

.filter-card {
  margin-bottom: 16px;
  border-radius: 8px;
  background: #FFFFFF;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.03);
  flex-shrink: 0;
}

.filter-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.filter-container {
  display: flex;
  gap: 16px;
}

.search-input {
  width: 240px;
}

.filter-select {
  width: 160px;
}

.account-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
  flex: none;
  overflow: visible;
}

.account-card {
  background: #FFFFFF;
  border-radius: 8px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.03);
  position: relative;
  overflow: hidden;
}

.account-card-inactive {
  opacity: 0.7;
}

.account-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  background: linear-gradient(to bottom right, #FFFFFF, #F8FAFC);
}

.account-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 1px solid #EBEEF5;
}

.account-name {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.account-type {
  font-size: 13px;
  color: #909399;
}

.default-tag {
  margin-left: 8px;
}

.account-content {
  display: flex;
  margin-bottom: 16px;
}

.account-balance, .account-profit {
  flex: 1;
  padding: 0 8px;
}

.account-balance {
  border-right: 1px solid #EBEEF5;
}

.balance-label, .profit-label {
  font-size: 13px;
  color: #909399;
  margin-bottom: 4px;
}

.balance-value, .profit-value {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
}

.profit-rate {
  font-size: 14px;
  color: #909399;
}

.profit-positive .profit-value, .profit-positive .profit-rate {
  color: #F56C6C;
}

.profit-negative .profit-value, .profit-negative .profit-rate {
  color: #67C23A;
}

.account-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 10px;
  border-top: 1px solid #EBEEF5;
}

.account-create-time {
  font-size: 13px;
  color: #909399;
}

.account-actions {
  display: flex;
  gap: 4px;
}

/* 账户详情样式 */
.account-details {
  padding: 0 16px;
  min-height: 100%;
  height: auto;
  display: flex;
  flex-direction: column;
  overflow: visible;
}

.details-header {
  flex-shrink: 0;
  margin-bottom: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid #EBEEF5;
}

.details-title {
  font-size: 20px;
  font-weight: 500;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.details-type {
  font-size: 14px;
  color: #909399;
}

.details-cards {
  flex-shrink: 0;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 16px;
}

.detail-card {
  background: #FFFFFF;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.detail-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.detail-card-content {
  text-align: center;
  padding: 16px 0;
}

.detail-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.detail-value {
  font-size: 24px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
}

.detail-rate {
  font-size: 14px;
  color: #909399;
}

.profit-positive-card .detail-value, .profit-positive-card .detail-rate {
  color: #F56C6C;
}

.profit-negative-card .detail-value, .profit-negative-card .detail-rate {
  color: #67C23A;
}

.profit-positive-text {
  color: #F56C6C;
}

.profit-negative-text {
  color: #67C23A;
}

.chart-card, .records-card {
  flex-shrink: 0;
  margin-bottom: 16px;
  background: #FFFFFF;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.chart-card:hover, .records-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.records-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
  font-weight: 500;
}

:deep(.el-drawer__body) {
  padding: 0;
  overflow: hidden;
}

:deep(.el-drawer__body) {
  height: 100%;
  overflow: hidden;
}

:deep(.el-drawer__container) {
  height: 100%;
  overflow: hidden;
}

:deep(.el-table__body-wrapper) {
  overflow: hidden !important;
}

:deep(.el-card__body) {
  padding: 16px;
  background: transparent;
  overflow: hidden !important;
}
</style>