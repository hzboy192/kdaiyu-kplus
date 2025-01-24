<script setup>
import dateformat from 'dateformat'
import GoodsList from '@c/chart/GoodsList.vue'
import PeriodList from '@c/chart/PeriodList.vue'
import ToolsBar from '@c/chart/ToolsBar.vue'
import UserInfo from '@c/chart/UserInfo.vue'
import TrainSettingDialog from '@c/chart/TrainSettingDialog.vue'
import { initChart, disposeChart, curPeriod, curGoods, supportPeriods } from '@c/chart/ChartPlusCore'
import { closeAfterHandle, TIP_SETTING, trainInit, trainStop } from '@c/chart/TrainCore'
import { closeTrainDtl, openTrainDtl, saveTrainData } from '@d/train_trade_data'
import emit from '@/utils/mitt'
import { ElNotification } from 'element-plus'
import { getFundDftAccount } from '@d/fund_account'
import FundSettingDialog from '@c/train/fundSettingDialog.vue'
import trainScoreDialog from '@c/train/TrainScoreDialog.vue'

const trainSettingDialogRef = ref(null)
const fundSettingDialogRef = ref(null)
const trainScoreDialogRef = ref(null)

let isTraining = ref(false)
// 用户训练设置
let trainSetting = null
// todo 用户设置，图标主题、指标等设置
let userSetting = reactive({})

// 账户信息，权益
let accountInfo = reactive({
  totalMoney: computed(() => {
    return accountInfo.fundAccount?.amount + accountInfo.holdingIncome
  }),
  holdingNum: 0,
  // 持仓金额
  holdingAmount: 0,
  // 持仓收益
  holdingIncome: 0,
  // 收益率
  incomePercent: 0,
  // 资金账户信息
  fundAccount: null
})

onMounted(() => {
  document.documentElement.setAttribute('class', 'dark')

  initChart()

  loadUserInfo()
})

onUnmounted(() => {
  disposeChart()
  document.documentElement.setAttribute('class', 'light')
})

// todo 查询用户信息、图表设置、账号信息数据。
let loadUserInfo = () => {
  //  查询默认资金账户，初始化firstInitMoney，若资金账户不存在，则创建一个,支持用户自定义金额。
  getFundDftAccount().then(({ data }) => {
    if (data) {
      accountInfo.fundAccount = data
    } else {
      fundSettingDialogRef.value.showDialog()
    }
  })
}

let toolbarAction = (command) => {
  if (isTraining.value) {
    ElNotification(Object.assign({}, TIP_SETTING, { type: 'warning', message: '训练过程中不支持其他操作！' }))
    return
  }
  if (command === 'openTrain') {
    trainSettingDialogRef.value.showDialog()
  } else if (command === 'finishTrain') {
    trainStop()
    trainScoreDialogRef.value.showDialog('55420297526000146')
  }
}
// 开始训练
let trainStart = (_trainSetting) => {
  isTraining.value = true
  let params = {
    traId: '',
    fundId: accountInfo.fundAccount.id,
    goodCode: _trainSetting.goods?.code,
    symbol: _trainSetting.goods?.mainNum,
    period: _trainSetting.period?.key,
    status: 1,
    startTime: dateformat(_trainSetting.from, 'yyyy-mm-dd HH:MM:ss'),
    finishTime: dateformat(_trainSetting.to, 'yyyy-mm-dd HH:MM:ss'),
    serCharge: _trainSetting.symbolInfo?.serCharge,
    unitPrice: _trainSetting.symbolInfo?.unitPrice
  }
  saveTrainData(params).then(({ data }) => {
    trainSetting = Object.assign({ traId: data.traId, symbol: params.symbol, status: params.status }, _trainSetting)
    trainInit(trainSetting).then(() => {
      //修改主图当前周期和商品
      Object.assign(curGoods, _trainSetting.goods)
      Object.assign(curPeriod, _trainSetting.period)
    })
  })
}

emit.on('onTrainSummary', (summary) => {
  Object.assign(accountInfo, { ...summary })
  console.log('onTrainSummary', summary, accountInfo)
})
// 平仓后提交的交易数据
emit.on('doCloseTrade', (tradeList) => {
  let lastTrade = tradeList[tradeList.length - 1]
  closeTrainDtl(tradeList).then((res) => {
    if (res.data) {
      // 平仓后需要将结算单和已平仓的开仓但从tradeList移除
      closeAfterHandle()
      // 更新页面账户金额
      accountInfo.fundAccount = res.data

      ElNotification(Object.assign({}, TIP_SETTING, { type: 'success', message: `已平仓 ${lastTrade.trdNum} 手 。` }))
    } else {
      ElNotification(Object.assign({}, TIP_SETTING, { type: 'warning', message: '操作失败！' }))
    }
  })
})

emit.on('doOpenTrade', (tradeList) => {
  let lastTrade = tradeList[tradeList.length - 1]
  openTrainDtl(lastTrade).then((res) => {
    lastTrade.trdId = res.data.trdId
    let dirHtml = '<span style="font-size:16px;color:orangered;font-weight:600">多</span>。'
    if (lastTrade.direction === -1) {
      dirHtml = '<span style="font-size:16px;color:forestgreen;font-weight:600">空</span>。'
    }
    let message = `开仓 ${lastTrade.trdNum} 手，方向: ` + dirHtml
    ElNotification(Object.assign({}, TIP_SETTING, { message }))
  })
})
</script>

<template>
  <el-header class="chart-header">
    <!--  工具栏-->
    <goods-list :check-goods="curGoods" />
    <period-list :check-period="curPeriod" :disabled="true" />
    <tools-bar @command="toolbarAction" />
    <user-info :account-info="accountInfo" />
  </el-header>
  <el-container>
    <!--  图表区域 -->
    <div id="chart" class="chart-container" />
    <!-- 训练设置弹框-->
    <train-setting-dialog ref="trainSettingDialogRef" :support-periods="supportPeriods" @start="trainStart" />

    <!-- 资金账号设置弹框 -->
    <fund-setting-dialog ref="fundSettingDialogRef" @success="loadUserInfo" />

    <!-- 训练成绩弹框 -->
    <train-score-dialog ref="trainScoreDialogRef" />
  </el-container>
</template>

<style scoped>
.chart-header {
  display: flex;
  --el-header-height: 40px;
  line-height: var(--el-header-height);
  border-bottom: solid 1px;
  border-bottom-color: var(--kline-border-color);
  background: var(--el-bg-color);
  caret-color: transparent;
}

.el-container {
  width: 100%;
  background: var(--el-bg-color);
}

.chart-container {
  width: 100%;
}
</style>
