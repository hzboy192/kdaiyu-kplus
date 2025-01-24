<script setup>
import { dispose, init } from 'klinecharts'
import { getGoods, getKlineHistory } from '@d/sina_future_data'
import klineOptions from '@/utils/kline-options'
import { useIntervalFn } from '@vueuse/core'

let selectFuCode = ref('RB0')
let selectCycle = ref('5')
let fuList = reactive([])
// 初始化图表
let chart = reactive({})

let cycleList = reactive([
  { key: '5', name: '5M' },
  { key: '30', name: '30M' },
  { key: '120', name: '2H' },
  { key: 'd', name: 'D' }
])

const { pause, resume, isActive } = useIntervalFn(() => initChart(), 30 * 1000)

onMounted(() => {
  chart = init('chart-container', klineOptions)
  chart.createIndicator({ name: 'MA', calcParams: [20, 60] }, true, { id: 'candle_pane' })
  // chart.createIndicator('MACD')

  initGoods().then(() => {
    initChart()
  })
})

onUnmounted(() => {
  // 销毁图表
  dispose('chart-container')
})

watch(selectFuCode, () => initChart())
watch(selectCycle, () => initChart())

let initGoods = function () {
  return getGoods().then((goods) => {
    fuList.push(...goods)
  })
}
let initChart = function () {
  return getKlineHistory(selectFuCode.value, selectCycle.value).then((res) => {
    // 为图表添加数据
    chart.applyNewData(res)
  })
}
</script>

<template>
  <div>
    <div class="flex justify-space-between mb-4 flex-wrap gap-4">
      <el-button-group id="fuGroups" class="ml-4">
        <el-button
          v-for="fu in fuList"
          :key="fu"
          :class="[fu.goodsCode === selectFuCode ? 'active' : '', 'fu_item']"
          type="text"
          :title="fu.goodsName"
          @click="selectFuCode = fu.goodsCode"
        >
          {{ fu.goodsCode }}
        </el-button>
      </el-button-group>
    </div>
    <div>
      <el-button-group id="cycleGroups" class="ml-4">
        <el-button
          v-for="cycle in cycleList"
          :key="cycle.key"
          :class="['cyc', { active: cycle.key === selectCycle }]"
          type="text"
          @click="selectCycle = cycle.key"
        >
          {{ cycle.name }}
        </el-button>
      </el-button-group>
    </div>
    <div id="chart-container" style="min-width: 380px; height: 480px" />
  </div>
</template>

<style scoped>
.fu_item {
  padding: 2px 5px;
  color: #1a1a1a;
}
.cyc {
  padding: 2px 5px;
  color: #1a1a1a;
}

.active {
  color: #0000ff;
  background: #e0e3e9;
}
</style>
