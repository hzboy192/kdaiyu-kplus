<template>
  <ul class="user-info">
    <li>
      <el-button-group>
        <el-button style="color: #f92855" @click="tradeBtnHandle(1)">多</el-button>
        <el-button style="color: #2dc08e" @click="tradeBtnHandle(-1)">空</el-button>
        <el-button @click="tradeBtnHandle(0)">平</el-button>
      </el-button-group>
      <el-input-number ref="tradeNumRef" v-model="tradeNum" :min="1" :max="999" style="width: 120px" @change="tradeNumChange" />&nbsp;
    </li>
    <li class="summary">
      <el-text type="info">权益：{{ Math.floor(accountInfo.totalMoney) || '-' }}&nbsp; </el-text>
      <el-text type="info">持仓：{{ accountInfo.holdingNum }} &nbsp;</el-text>
      <el-text type="info"> 收益：{{ accountInfo.holdingNum > 0 ? Math.floor(accountInfo.holdingIncome) : '-' }}&nbsp; </el-text>
      <el-text type="info"> 收益率：{{ accountInfo.holdingNum > 0 ? accountInfo.incomePercent + '%' : '-' }}&nbsp; </el-text>
    </li>
    <li>
      <user-head-avatar />
    </li>
  </ul>

  <!-- 训练结束弹框， 对本次仿真训练进行统计分析，弹框显示报告。-->
  <train-score-dialog ref="trainScoreRef" />
</template>
<script setup>
import emit from '@/utils/mitt'
import TrainScoreDialog from '@c/train/TrainScoreDialog.vue'
import UserHeadAvatar from '@c/user/UserHeadAvatar.vue'

const trainScoreRef = ref(null)
const tradeNumRef = ref(null)

onMounted(() => {
  document.documentElement.setAttribute('class', 'dark')
})

const props = defineProps({
  accountInfo: {
    type: Object,
    default: () => {
      return { totalMoney: 0, holdingNum: 0, holdingAmount: 0, holdingIncome: 0 }
    }
  }
})

let tradeNum = ref(0)

let tradeNumChange = (currentValue) => {
  tradeNumRef.value.blur()
  emit.emit('changeTradeNum', currentValue)
}

let tradeBtnHandle = (flag) => {
  console.log(flag)
}

emit.on('trainStop', (trainOption) => {
  console.log('onTrainFinish', trainOption)
  trainScoreRef.value.showDialog()
})
</script>

<style scoped>
.user-info {
  font-size: 12px;
  display: flex;
  margin-left: auto;
  caret-color: transparent;
}
.user-info li {
  display: flex;
  justify-content: center;
  align-items: center;
  text-wrap: nowrap;
  overflow: hidden;
}

.user-info li:last-child {
  cursor: pointer;
  margin-left: 10px;
}

.summary {
  --el-font-size-base: 12px;
  font-weight: 500;
}
</style>
