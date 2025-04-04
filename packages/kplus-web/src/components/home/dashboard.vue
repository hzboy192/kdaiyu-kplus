<script setup>
import { ref, onMounted } from 'vue'
import * as echarts from 'echarts'
import { 
  TrendCharts, 
  Money, 
  Wallet,
  DataLine,
  Timer,
  PieChart,
  TrendCharts as ArrowUp
} from '@element-plus/icons-vue'

const profitData = {
  totalProfit: 25800,
  todayProfit: 1200,
  weekProfit: 5600,
  monthProfit: 12300,
  winRate: 65.5,
  tradeCount: 128
}

const initProfitChart = () => {
  const chartDom = document.getElementById('profitChart')
  const myChart = echarts.init(chartDom)
  const option = {
    title: {
      text: '近30天收益曲线'
    },
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: Array.from({length: 30}, (_, i) => `${i + 1}日`)
    },
    yAxis: {
      type: 'value',
      name: '收益(元)'
    },
    series: [{
      data: Array.from({length: 30}, () => Math.floor(Math.random() * 2000 - 1000)),
      type: 'line',
      smooth: true,
      areaStyle: {
        opacity: 0.3
      }
    }]
  }
  myChart.setOption(option)
}

const initTradeChart = () => {
  const chartDom = document.getElementById('tradeChart')
  const myChart = echarts.init(chartDom)
  const option = {
    title: {
      text: '交易品种分布'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [{
      type: 'pie',
      radius: '50%',
      data: [
        { value: 35, name: '上证指数' },
        { value: 30, name: '深证成指' },
        { value: 20, name: '创业板指' },
        { value: 15, name: '科创50' }
      ],
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }]
  }
  myChart.setOption(option)
}

onMounted(() => {
  initProfitChart()
  initTradeChart()
})
</script>

<template>
  <div class="dashboard">
    <div class="dashboard-header">
      <h2 class="dashboard-title">数据总览</h2>
    </div>
    
    <div class="stat-cards">
      <el-card class="stat-card" shadow="never">
        <div class="card-content">
          <div class="card-icon">
            <el-icon :size="20" color="#409EFF">
              <Money />
            </el-icon>
          </div>
          <div class="card-info">
            <div class="card-title">总收益(元)</div>
            <div class="card-value profit">{{ profitData.totalProfit }}</div>
            <div class="card-trend">
              <el-icon color="#67C23A" :size="12"><ArrowUp /></el-icon>
              <span class="trend-value">+20.5%</span>
              <span class="trend-label">较上月</span>
            </div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="never">
        <div class="card-content">
          <div class="card-icon">
            <el-icon :size="20" color="#67C23A">
              <Wallet />
            </el-icon>
          </div>
          <div class="card-info">
            <div class="card-title">今日收益(元)</div>
            <div class="card-value">{{ profitData.todayProfit }}</div>
            <div class="card-trend">
              <el-icon color="#67C23A" :size="12"><ArrowUp /></el-icon>
              <span class="trend-value">+15.2%</span>
              <span class="trend-label">较昨日</span>
            </div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="never">
        <div class="card-content">
          <div class="card-icon">
            <el-icon :size="20" color="#E6A23C">
              <DataLine />
            </el-icon>
          </div>
          <div class="card-info">
            <div class="card-title">胜率</div>
            <div class="card-value">{{ profitData.winRate }}%</div>
            <div class="card-trend">
              <el-icon color="#67C23A" :size="12"><ArrowUp /></el-icon>
              <span class="trend-value">+5.3%</span>
              <span class="trend-label">较上周</span>
            </div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="never">
        <div class="card-content">
          <div class="card-icon">
            <el-icon :size="20" color="#909399">
              <Timer />
            </el-icon>
          </div>
          <div class="card-info">
            <div class="card-title">交易次数</div>
            <div class="card-value">{{ profitData.tradeCount }}</div>
            <div class="card-trend">
              <el-icon color="#67C23A" :size="12"><ArrowUp /></el-icon>
              <span class="trend-value">+12.8%</span>
              <span class="trend-label">较上月</span>
            </div>
          </div>
        </div>
      </el-card>
    </div>

    <div class="charts">
      <el-card class="chart-card" shadow="never">
        <div class="chart-header">
          <h3 class="chart-title">
            <el-icon :size="16" color="#409EFF"><DataLine /></el-icon>
            <span>近30天收益曲线</span>
          </h3>
        </div>
        <div id="profitChart" style="width: 100%; height: 350px;"></div>
      </el-card>
      <el-card class="chart-card" shadow="never">
        <div class="chart-header">
          <h3 class="chart-title">
            <el-icon :size="16" color="#409EFF"><PieChart /></el-icon>
            <span>交易品种分布</span>
          </h3>
        </div>
        <div id="tradeChart" style="width: 100%; height: 350px;"></div>
      </el-card>
    </div>
  </div>
</template>

<style scoped>
.dashboard {
  height: 100%;
  background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 100%);
  display: flex;
  flex-direction: column;
  padding: 16px;
  box-sizing: border-box;
  overflow-y: hidden;
}

.dashboard-header {
  margin-bottom: 16px;
  flex-shrink: 0;
}

.dashboard-title {
  font-size: 16px;
  font-weight: 500;
  color: #1F2937;
  margin: 0;
}

.stat-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 16px;
  flex-shrink: 0;
}

.stat-card {
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.03);
  background: #FFFFFF;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  background: linear-gradient(to bottom right, #FFFFFF, #F8FAFC);
}

.card-content {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 4px;
}

.card-icon {
  background-color: #EBF5FF;
  padding: 10px;
  border-radius: 6px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-card:hover .card-icon {
  background-color: #E6F0FF;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.15);
}

.card-info {
  flex: 1;
}

.card-title {
  font-size: 13px;
  color: #909399;
  margin-bottom: 4px;
}

.card-value {
  font-size: 20px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
  line-height: 1.2;
}

.card-value.profit {
  color: #F56C6C;
}

.card-trend {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  line-height: 1;
}

.trend-value {
  color: #67C23A;
  font-weight: 500;
}

.trend-label {
  color: #909399;
}

.charts {
  display: grid;
  grid-template-columns: 3fr 2fr;
  gap: 16px;
  flex: 1;
  overflow: hidden;
  margin-bottom: 16px;
}

.chart-card {
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.03);
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background: #FFFFFF;
}

.chart-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  background: linear-gradient(to bottom right, #FFFFFF, #F8FAFC);
}

.chart-header {
  margin-bottom: 16px;
  flex-shrink: 0;
}

.chart-title {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 0;
  font-size: 14px;
  font-weight: 500;
  color: #1F2937;
}

#profitChart, #tradeChart {
  width: 100%;
  height: 100%;
  min-height: 0;
}

@deep(.el-card__body) {
  padding: 16px;
  height: 100%;
  background: transparent;
}

@media (max-width: 1400px) {
  .stat-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .charts {
    grid-template-columns: 1fr;
  }
  
  #profitChart, #tradeChart {
    height: 300px;
  }
}
</style>
