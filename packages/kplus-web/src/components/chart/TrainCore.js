import { getBarData } from '@d/kline_pro_data'
import { addDays } from '@/utils/date-utils'
import debounce from 'lodash-es/debounce'
import { ElLoading, ElNotification } from 'element-plus'
import emit from '@/utils/mitt'
import { now, sum } from 'lodash-es'
import { openTrainDtl, closeTrainDtl } from '@d/train_trade_data'

// 交易方向
const TRADE_DIRECTION = { UP: 1, DOWN: -1, CLOSE: 0 }
// 仓单状态: 0.已平仓，1.持有中
const TRADE_STATUS = { HOLDING: 1, CLOSED: 0 }
// 训练状态：0.未开始，1.进行中,-1.已结束，
const TRAIN_STATUS = { READY: 0, RUNNING: 1, FINISH: -1 }

// 操作日志：记录开仓、平仓记录
const tradeLogs = []

// 消息提示框设置
const TIP_SETTING = {
  title: '交易提醒',
  message: '',
  position: 'top-right',
  type: 'success',
  duration: 1000,
  offset: 20,
  dangerouslyUseHTMLString: true
}

/**
 * 训练数据对象
 * @property traId 训练ID
 * @property goods 商品信息
 * @property symbol 合约
 * @property period 周期信息
 * @property openNum 开仓数量
 * @property closeNum 平仓数据
 * @property transList 交易清单
 * @property range 训练设置的开始、结束时间，数组2个元素
 * @property waitDrawList 待绘制在图表的数据集合
 * @property from 分批查询数据开始时间
 * @property to 分批查询数据结束时间
 * @property status 状态：0.未开始（默认）1.进行中 0.已结束
 * @property lastK 当前图表上最后一根K
 * @property holdingNum 当前持仓数量
 * @property holdingAmount 当前持仓金额
 * @property holdingIncome 当前持仓收益
 */
let trainOption = {
  traId: null,
  goods: null,
  symbol: null,
  period: null,
  from: null,
  to: null,
  range: [],
  waitDrawList: [],
  transList: reactive([]),
  status: TRAIN_STATUS.READY,
  lastK: null,
  holdingNum: 0,
  holdingAmount: 0,
  // 当前持仓收益
  holdingIncome: 0
}
// 最后K线数据定义成响应式，触发计算属性
let refLastK = ref({ open: null, close: null })

let bindHotKey = () => {
  // 播放一根K线
  key('s', debounce(updateNewData, 80))

  // 下空单
  key('a', debounce(openTradeEmpty, 200))

  // 下多单
  key('d', debounce(openTradeMany, 200))

  // 平仓
  key('w', debounce(closeTrade, 200))

  // 打印调试日志
  key('p', () => {
    console.debug('DEBUG:', trainOption.transList)
  })
}

let initTrainBtn = () => {
  console.log('init train button.')
}

let trainInit = (option) => {
  Object.assign(trainOption, toRaw(option), { status: TRAIN_STATUS.RUNNING })
  trainOption.from = trainOption.range[0].getTime()
  trainOption.to = getToDate(trainOption.range[0])
  const loadingInstance = ElLoading.service({ fullscreen: false })
  return getBarData(trainOption.symbol, trainOption.period.key, trainOption.from, trainOption.to).then((list) => {
    let drawData = list.splice(0, list.length / 2)
    trainOption.waitDrawList = list
    trainOption.lastK = drawData[drawData.length - 1]
    refLastK.value = trainOption.lastK
    chart.applyNewData(drawData)
    bindHotKey()
    initTrainBtn()
    loadingInstance.close()
  })
}

let getToDate = (from) => {
  let temp = addDays(from, trainOption.period.pageSize, true)
  return temp < trainOption.range[1] ? temp.getTime() : trainOption.range[1].getTime()
}

let updateNewData = () => {
  if (!trainOption.waitDrawList && trainOption.waitDrawList.length === 0) return
  trainOption.lastK = trainOption.waitDrawList.splice(0, 1)[0]
  // 最后一根K线时加载下一批
  if (trainOption.waitDrawList.length === 0) {
    key.unbind('s, w, a, d')
    trainOption.from = trainOption.lastK.timestamp
    trainOption.to = getToDate(new Date(trainOption.lastK.timestamp))
    if (trainOption.to === trainOption.range[1].getTime()) {
      trainOption.status = TRAIN_STATUS.FINISH
      emit.emit('trainFinish', trainOption)
    } else {
      const loadingInstance = ElLoading.service({ fullscreen: false })
      // console.log('from:', new Date(trainOption.from), ' to:', new Date(trainOption.to))
      getBarData(trainOption.symbol, trainOption.period.key, trainOption.from, trainOption.to).then((list) => {
        loadingInstance.close()
        if (list.length > 0) {
          bindHotKey()
          trainOption.waitDrawList.push(...list)
        }
      })
    }
  }
  chart.updateData(trainOption.lastK)
  refLastK.value = trainOption.lastK
}

let openTradeMany = () => openTrade(TRADE_DIRECTION.UP)

let openTradeEmpty = () => openTrade(TRADE_DIRECTION.DOWN)

/**
 * 开仓 规则如下：
 * 在同一时间多次开仓，仅保存一次记录，汇总开仓数量。
 * 不支持双向开仓，在持有多单时不能开空单，账号始终保持一种开仓单。
 *
 * 开仓时生成交易记录，记录开仓点位，手数提供给平仓时生成结算单。
 *
 * @param flag 开仓方向：1.多, -1.空
 */
let openTrade = (flag) => {
  //todo 判断账户余额是否充足
  let lastTrade = trainOption.transList.length > 0 ? trainOption.transList[trainOption.transList.length - 1] : null
  let isHolding = lastTrade && lastTrade.status === TRADE_STATUS.HOLDING
  //拒绝反向开仓
  if (isHolding && lastTrade.direction !== flag) {
    ElNotification(Object.assign({}, TIP_SETTING, { type: 'warning', message: '不支持反向开仓，清空仓单后再反向开仓！' }))
    return
  }

  // 同一时间点上多次开仓，数量累加
  if (isHolding && lastTrade.direction === flag && trainOption.lastK.timestamp === lastTrade.trdAt) {
    let totalNum = lastTrade.trdNum + trainOption.openNum
    // 同一位置交易多次，开仓点位一般不一样，无需均值。
    // lastTrade.open = Math.ceil((lastTrade.trdNum * lastTrade.open + trainOption.lastK.close * trainOption.openNum) / totalNum)
    lastTrade.trdNum = totalNum
  } else {
    /**
     * 仓单信息
     * @property trdId 后端生成ID
     * @property trdAt 开仓K时间坐标
     * @property type 结算单标识，1.为平仓结算单
     * @property open 开仓点位
     * @property direction 开仓方向
     * @property trdNum 开仓数量
     * @property closeNum 已平仓数据量
     * @property status 状态：1.持有中, 0.已平仓
     * @property close 平仓点位
     * @property createTime 操作时间
     */
    let tradeInfo = {
      trdId: null,
      traId: trainOption.traId,
      trdAt: trainOption.lastK.timestamp,
      type: 0,
      open: trainOption.lastK.close,
      direction: flag,
      trdNum: trainOption.openNum,
      closeNum: 0,
      status: TRADE_STATUS.HOLDING,
      close: null,
      // 手续费金额
      serAmount: trainOption.openNum * getSerAmount(trainOption.symbolInfo, trainOption.lastK),
      createTime: now()
    }
    trainOption.transList.push(tradeInfo)
  }
  //发布开仓交易事件
  emit.emit('doOpenTrade', trainOption.transList)

  //openTrainDtl(lastTrade).then((res) => {
  //  lastTrade.trdId = res.data.trdId
  //  let dirHtml = '<span style="font-size:16px;color:orangered;font-weight:600">多</span>。'
  //  if (flag === -1) {
  //    dirHtml = '<span style="font-size:16px;color:forestgreen;font-weight:600">空</span>。'
  //  }
  //  let message = `开仓 ${trainOption.openNum} 手，方向: ` + dirHtml
  //  ElNotification(Object.assign({}, TIP_SETTING, { message }))
  //  //发布开仓交易事件
  //  emit.emit('doOpenTrade', trainOption.transList)
  //})
}

/**
 * 平仓:
 * 平仓时生成结算单，平仓时考虑分配开仓的情况需要对找到平仓单所有的开仓点位，然后求平均后生成账单。
 * 在同一时间多次平仓生成多个账单，不能合并。开仓点位不一定一样，分配开仓已求平均无法再做均值技术。
 */
let closeTrade = () => {
  if (trainOption.closeNum > trainOption.holdingNum) {
    ElNotification(Object.assign({}, TIP_SETTING, { type: 'warning', message: '平仓手数不能大于持仓手数。' }))
    return
  }
  // type 标识是平仓结算记录
  let tradeBilling = {
    trdId: null,
    traId: trainOption.traId,
    trdAt: trainOption.lastK.timestamp,
    type: 1,
    open: null,
    direction: 0,
    trdNum: trainOption.closeNum,
    status: TRADE_STATUS.CLOSED,
    close: trainOption.lastK.close,
    // 平仓手续费金额 = 每手单价 * 数量
    serAmount: trainOption.closeNum * getSerAmount(trainOption.symbolInfo, trainOption.lastK),
    // 总收益金额
    income: 0,
    createTime: now()
  }
  let holdingList = trainOption.transList.filter((it) => it.status === TRADE_STATUS.HOLDING)
  let closeCount = trainOption.closeNum
  // 每跳单价
  let unitPrice = trainOption.symbolInfo.unitPrice
  // 开仓手续费汇总
  let openSerAmount = 0
  let openArray = []
  if (holdingList.length > 0) {
    for (let i = 0; i < holdingList.length && closeCount > 0; i++) {
      // 部分平仓后，开仓数量和平仓数量不一样，需要计算剩余数量
      let haveCount = holdingList[i].trdNum - holdingList[i].closeNum
      // 当前仓单剩余手数大于平仓手数时，部分平仓，剩余部分后面仓单继续平,平仓账单生成。
      if (haveCount > closeCount) {
        openArray.push(holdingList[i].open * closeCount)
        holdingList[i].closeNum += closeCount
        openSerAmount += closeCount * holdingList[i].serAmount
        closeCount = 0
      } else {
        // 当前仓单剩余手数小于或等于平仓手数，全部平仓
        closeCount -= haveCount
        holdingList[i].closeNum = holdingList[i].trdNum
        holdingList[i].status = TRADE_STATUS.CLOSED
        openSerAmount += haveCount * holdingList[i].serAmount
        openArray.push(holdingList[i].open * haveCount)
      }
    }
    // 分批下单情况下，平仓时将开仓点位平均后计入账单。
    tradeBilling.open = sum(openArray) / trainOption.closeNum
    tradeBilling.direction = holdingList[0].direction
    // 总收益 = (平仓点位-开仓点位)*手数*每跳单价-平仓续费-开仓续费
    tradeBilling.income = (tradeBilling.direction === TRADE_DIRECTION.UP ? tradeBilling.close - tradeBilling.open : tradeBilling.open - tradeBilling.close) * tradeBilling.trdNum * unitPrice - tradeBilling.serAmount - openSerAmount
    trainOption.transList.push(tradeBilling)
    emit.emit('doCloseTrade', trainOption.transList)
  } else {
    ElNotification(Object.assign({}, TIP_SETTING, { type: 'warning', message: '当前持仓数量为 0 。' }))
  }
}
// 平仓后数据处理
let closeAfterHandle = () => {
  // 删除最后一条数据，即结算单
  trainOption.transList.pop()
  // 删除已平仓的记录,从后向前遍历数组,避免删除后影响便利
  for (let i = trainOption.transList.length - 1; i >= 0; i--) {
    if (trainOption.transList[i].status === TRADE_STATUS.CLOSED) {
      trainOption.transList.splice(i, 1)
    }
  }
}

let getSerAmount = (symbolInfo, Kline) => {
  return symbolInfo.serCalcType === 'P' ? symbolInfo.serCharge * Kline.close : symbolInfo.serCharge
}
// 成绩统计:持仓收益，平仓收益,
watch([trainOption.transList, refLastK], ([transList, lastK]) => {
  // 每跳单价
  let unitPrice = trainOption.symbolInfo.unitPrice
  let holdingNum = 0
  let holdingAmount = 0
  let holdingIncome = 0
  transList.forEach((it) => {
    // 计算持仓收益
    if (it.status === TRADE_STATUS.HOLDING) {
      // 当前仓单的未平仓手数
      let haveCount = it.trdNum - it.closeNum
      // 累加所有未平仓手数、利润
      holdingNum += haveCount
      // todo 持仓金额 = 开仓点位*手数*每跳单价+手续费
      holdingAmount += it.open * haveCount
      // 汇总持仓收益 = (当前K线收盘价-开仓点位)*手数*每跳单价-手续费
      holdingIncome += (it.direction === TRADE_DIRECTION.UP ? lastK.close - it.open : it.open - lastK.close) * haveCount * unitPrice
    }
  })
  Object.assign(trainOption, { holdingNum, holdingAmount, holdingIncome })
  // 汇总持仓收益率
  trainOption.incomePercent = holdingNum > 0 ? Math.round((holdingIncome / holdingAmount) * 100) : 0
  emit.emit('onTrainSummary', {
    holdingNum,
    holdingAmount,
    holdingIncome,
    incomePercent: trainOption.incomePercent
  })
})

// 结束仿真训练
let trainStop = () => {
  console.log('stopTrain')
  key.unbind('s, w, a, d')
}

// 暂停
let trainPause = () => {
  console.log('trainPause')
  key.unbind('s, w, a, d')
}

// 修改交易手数
emit.on('changeTradeNum', (num) => {
  trainOption.openNum = num
  trainOption.closeNum = num
})

export { trainInit, trainStop, trainPause, closeAfterHandle, TRADE_DIRECTION, TRAIN_STATUS, TRADE_STATUS, TIP_SETTING }
