<script setup>
import emit from '@/utils/mitt'
import { getTrainSummary } from '@d/train_trade_data'

let finishDialog = reactive({ show: false })
let trainSummary = reactive({
  traId: 0,
  tradeCount: 0,
  totalProfit: 0,
  totalFee: 0,
  maxProfit: 0,
  maxLoss: 0,
  profitLossRatio: 0,
  winRate: 0
})

let showDialog = (traId) => {
  console.log('showDialog', traId)
  trainSummary.traId = traId
  finishDialog.show = true
}

watch(
  () => trainSummary.traId,
  (newVal) => {
    console.log('watch', newVal)
    getTrainSummary(newVal).then(({ data }) => {
      console.log('getTrainSummary', data)
      Object.assign(trainSummary, data)
    })
  }
)

defineExpose({ showDialog })
</script>
<!--
统计本次训练的成功率，收益率，初期权益、末期权益、账户增长情况、盈亏比等。
收费功能：
账号相关统计引导个人中心查看
历史行情标记交易
-->
<template>
  <el-dialog v-model="finishDialog.show" title="交易汇总" width="500" draggable :close-on-click-modal="false">
    <el-scrollbar max-height="58vh">
      你的成绩单，关闭成绩单后可在行情图表中查看每笔交易记录。
      <el-row :gutter="20">
        <el-col :span="12">
          <div>交易次数: {{ trainSummary.tradeCount }}</div>
        </el-col>
        <el-col :span="12">
          <div>总收益: {{ trainSummary.totalProfit }}</div>
        </el-col>
        <el-col :span="12">
          <div>总手续费: {{ trainSummary.totalFee }}</div>
        </el-col>
        <el-col :span="12">
          <div>最大收益: {{ trainSummary.maxProfit }}</div>
        </el-col>
        <el-col :span="12">
          <div>最大亏损: {{ trainSummary.maxLoss }}</div>
        </el-col>
        <el-col :span="12">
          <div>盈亏比: {{ trainSummary.profitLossRatio }}</div>
        </el-col>
        <el-col :span="12">
          <div>胜率: {{ trainSummary.winRate }}</div>
        </el-col>
      </el-row>
    </el-scrollbar>
    <template #footer>
      <el-button type="primary" @click="finishDialog.show = false"> 确定 </el-button>
    </template>
  </el-dialog>
</template>

<style scoped></style>
