<script setup>
import { ref, onMounted } from 'vue'
import * as echarts from 'echarts'
import { TrendCharts, Money, Timer, DataLine, Wallet, Warning } from '@element-plus/icons-vue'

const activeTab = ref('profit')
const selectedTrade = ref('latest')

const tradeOptions = [
  { label: '最近一次训练', value: 'latest' },
  { label: '2024-03-15 上证指数训练', value: 'trade1' },
  { label: '2024-03-14 深证成指训练', value: 'trade2' },
  { label: '2024-03-13 创业板指训练', value: 'trade3' }
]

const tradeData = {
  profitRate: 32.5,
  maxDrawdown: 15.2,
  sharpeRatio: 1.85,
  maxProfit: 3200,
  maxLoss: -1500,
  avgHoldTime: '2.5天',
  continuousWin: 5,
  continuousLoss: 2
}

const initProfitDistChart = () => {
  const chartDom = document.getElementById('profitDistChart')
  const myChart = echarts.init(chartDom)
  const option = {
    title: {
      text: '盈亏分布',
      textStyle: {
        fontSize: 14,
        fontWeight: 'normal'
      }
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      top: '15%',
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: ['<-10%', '-10%~-5%', '-5%~0', '0~5%', '5%~10%', '>10%'],
      axisLine: {
        lineStyle: {
          color: '#E5E7EB'
        }
      }
    },
    yAxis: {
      type: 'value',
      name: '次数',
      splitLine: {
        lineStyle: {
          color: '#E5E7EB'
        }
      }
    },
    series: [{
      name: '交易次数',
      type: 'bar',
      data: [5, 15, 30, 35, 25, 10],
      itemStyle: {
        color: function(params) {
          return params.dataIndex < 3 ? '#F56C6C' : '#67C23A'
        }
      },
      barWidth: '60%'
    }]
  }
  myChart.setOption(option)
}

const initTimeDistChart = () => {
  const chartDom = document.getElementById('timeDistChart')
  const myChart = echarts.init(chartDom)
  const option = {
    title: {
      text: '交易时间分布',
      textStyle: {
        fontSize: 14,
        fontWeight: 'normal'
      }
    },
    tooltip: {
      position: 'top'
    },
    calendar: {
      top: 60,
      left: 40,
      right: 40,
      cellSize: ['auto', 20],
      range: '2024',
      itemStyle: {
        borderWidth: 0.5,
        borderColor: '#E5E7EB'
      },
      yearLabel: { show: false },
      dayLabel: {
        nameMap: ['日', '一', '二', '三', '四', '五', '六']
      },
      monthLabel: {
        nameMap: 'cn'
      }
    },
    visualMap: {
      min: 0,
      max: 10,
      calculable: true,
      orient: 'horizontal',
      left: 'center',
      top: 0,
      inRange: {
        color: ['#ECF5FF', '#409EFF']
      }
    },
    series: [{
      type: 'heatmap',
      coordinateSystem: 'calendar',
      calendarIndex: 0,
      data: Array.from({length: 365}, (_, i) => {
        return [
          echarts.format.formatTime('yyyy-MM-dd', new Date('2024-01-01').getTime() + 3600 * 24 * 1000 * i),
          Math.floor(Math.random() * 10)
        ]
      })
    }]
  }
  myChart.setOption(option)
}

onMounted(() => {
  initProfitDistChart()
  initTimeDistChart()
})
</script>

<template>
  <div class="analyses">
    <el-tabs v-model="activeTab" class="analysis-tabs">
      <template #prefix>
        <div class="tab-prefix">
          <el-select v-model="selectedTrade" class="trade-select" placeholder="选择训练记录">
            <el-option
              v-for="item in tradeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </div>
      </template>
      <el-tab-pane label="收益分析" name="profit">
        <div class="content-wrapper">
          <div class="stat-cards">
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#409EFF">
                    <Money />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">收益率</div>
                  <div class="card-value positive">{{ tradeData.profitRate }}%</div>
                </div>
              </div>
            </el-card>
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#F56C6C">
                    <Warning />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">最大回撤</div>
                  <div class="card-value negative">{{ tradeData.maxDrawdown }}%</div>
                </div>
              </div>
            </el-card>
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#E6A23C">
                    <DataLine />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">夏普比率</div>
                  <div class="card-value">{{ tradeData.sharpeRatio }}</div>
                </div>
              </div>
            </el-card>
          </div>

          <div class="stat-cards">
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#67C23A">
                    <Wallet />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">最大单笔盈利</div>
                  <div class="card-value positive">{{ tradeData.maxProfit }}</div>
                </div>
              </div>
            </el-card>
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#F56C6C">
                    <Wallet />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">最大单笔亏损</div>
                  <div class="card-value negative">{{ tradeData.maxLoss }}</div>
                </div>
              </div>
            </el-card>
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#909399">
                    <Timer />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">平均持仓时间</div>
                  <div class="card-value">{{ tradeData.avgHoldTime }}</div>
                </div>
              </div>
            </el-card>
          </div>

          <div class="stat-cards">
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#67C23A">
                    <TrendCharts />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">最大连续盈利</div>
                  <div class="card-value positive">{{ tradeData.continuousWin }}次</div>
                </div>
              </div>
            </el-card>
            <el-card class="stat-card" shadow="never">
              <div class="card-content">
                <div class="card-icon">
                  <el-icon :size="24" color="#F56C6C">
                    <TrendCharts />
                  </el-icon>
                </div>
                <div class="card-info">
                  <div class="card-title">最大连续亏损</div>
                  <div class="card-value negative">{{ tradeData.continuousLoss }}次</div>
                </div>
              </div>
            </el-card>
          </div>

          <div class="charts">
            <el-card class="chart-card" shadow="never">
              <div class="chart-header">
                <h3 class="chart-title">盈亏分布</h3>
              </div>
              <div id="profitDistChart" style="width: 100%; height: 330px;"></div>
            </el-card>
            <el-card class="chart-card" shadow="never">
              <div class="chart-header">
                <h3 class="chart-title">交易时间分布</h3>
              </div>
              <div id="timeDistChart" style="width: 100%; height: 330px;"></div>
            </el-card>
          </div>
        </div>
      </el-tab-pane>

      <el-tab-pane label="训练记录" name="records">
        <div class="content-wrapper">
          <el-card shadow="never" class="table-card">
            <div class="table-header">
              <h3 class="table-title">训练详情记录</h3>
            </div>
            <el-table :data="[]" style="width: 100%" stripe border>
              <el-table-column prop="date" label="训练日期" width="180" />
              <el-table-column prop="symbol" label="训练品种" width="180" />
              <el-table-column prop="type" label="操作类型" />
              <el-table-column prop="price" label="操作价格" />
              <el-table-column prop="volume" label="操作数量" />
              <el-table-column prop="profit" label="盈亏金额" />
            </el-table>
          </el-card>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<style scoped>
.analyses {
  height: 100%;
  background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 100%);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.analysis-tabs {
  flex: 1;
  background: #FFFFFF;
  margin: 16px;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.tab-prefix {
  display: flex;
  align-items: center;
  padding: 0 20px;
  border-right: 1px solid #E4E7ED;
}

.trade-select {
  width: 220px;
}

:deep(.el-tabs__header) {
  margin: 0;
  padding: 0;
  background: linear-gradient(to bottom, #F8FAFC, #FFFFFF);
  border-bottom: 1px solid #E4E7ED;
}

:deep(.el-tabs__nav-wrap) {
  display: flex;
  height: 56px;
}

:deep(.el-tabs__nav-wrap::after) {
  display: none;
}

:deep(.el-tabs__nav) {
  height: 100%;
  border: none !important;
}

:deep(.el-tabs__item) {
  height: 56px;
  line-height: 56px;
  font-size: 15px;
  padding: 0 32px !important;
  transition: all 0.3s;
  border-right: 1px solid #E4E7ED;
}

:deep(.el-tabs__item.is-active) {
  background-color: #fff;
  color: #409EFF;
  font-weight: 500;
  position: relative;
}

:deep(.el-tabs__item.is-active::after) {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 1px;
  background-color: #fff;
  box-shadow: 0 1px 3px rgba(64, 158, 255, 0.2);
}

:deep(.el-tabs__item:hover) {
  color: #409EFF;
  background-color: rgba(64, 158, 255, 0.05);
}

:deep(.el-tabs__active-bar) {
  display: none;
}

:deep(.el-tabs__content) {
  flex: 1;
  padding: 0;
  overflow-y: auto;
}

.content-wrapper {
  padding: 20px;
}

:deep(.el-select .el-input__wrapper) {
  background-color: transparent;
  box-shadow: none;
  padding-left: 0;
}

:deep(.el-select:hover .el-input__wrapper) {
  box-shadow: none;
}

:deep(.el-select .el-input__inner) {
  font-size: 15px;
  color: #606266;
  font-weight: 500;
}

:deep(.el-select-dropdown) {
  border-radius: 6px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  border: none;
}

:deep(.el-select-dropdown__item) {
  padding: 10px 16px;
  font-size: 14px;
  transition: all 0.2s;
}

:deep(.el-select-dropdown__item:hover) {
  background-color: #F0F7FF;
}

:deep(.el-select-dropdown__item.selected) {
  color: #409EFF;
  font-weight: 500;
  background-color: #ECF5FF;
}

.stat-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 16px;
}

.stat-card {
  border-radius: 10px;
  border: none;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  background: #FFFFFF;
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
  background: linear-gradient(to bottom right, #FFFFFF, #F8FAFC);
}

.card-content {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 12px;
}

.card-icon {
  background: #EBF5FF;
  padding: 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-card:hover .card-icon {
  background: linear-gradient(135deg, #E6F0FF, #F0F7FF);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.15);
  transform: scale(1.05);
}

.card-info {
  flex: 1;
  padding-top: 2px;
}

.card-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.card-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  line-height: 1.2;
  letter-spacing: -0.5px;
}

.card-value.positive {
  color: #F56C6C;
  background: linear-gradient(90deg, #F56C6C, #E24C4C);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.card-value.negative {
  color: #67C23A;
  background: linear-gradient(90deg, #67C23A, #4E9F3D);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.charts {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.chart-card {
  border-radius: 10px;
  border: none;
  background: #FFFFFF;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chart-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
  background: linear-gradient(to bottom right, #FFFFFF, #F8FAFC);
}

.chart-header {
  padding: 12px 16px;
  border-bottom: 1px solid #F5F7FA;
}

.chart-title {
  font-size: 15px;
  font-weight: 500;
  color: #303133;
  margin: 0;
}

.table-card {
  border-radius: 10px;
  border: none;
  background: #FFFFFF;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.table-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
  background: linear-gradient(to bottom right, #FFFFFF, #F8FAFC);
}

.table-header {
  padding: 12px 16px;
  border-bottom: 1px solid #F5F7FA;
}

.table-title {
  font-size: 15px;
  font-weight: 500;
  color: #303133;
  margin: 0;
}

:deep(.el-card__body) {
  padding: 0;
  background: transparent;
}

:deep(.el-table) {
  --el-table-header-bg-color: #F8FAFC;
  --el-table-border-color: #EBEEF5;
}

:deep(.el-table th) {
  font-weight: 500;
  color: #606266;
}

:deep(.el-table--border th:first-child) {
  border-left: none;
}

:deep(.el-table--border th:last-child) {
  border-right: none;
}

:deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background: #F8FAFC;
}

:deep(.el-table__row:hover > td) {
  background-color: #F0F7FF !important;
}
</style>
