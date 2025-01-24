import { ElLoading } from 'element-plus'
import defaultStyles from '@c/chart/default_style'
import { ActionType, dispose, init } from 'klinecharts'
import { getBarData } from '@d/kline_pro_data'
import emit from '@u/mitt'
import debounce from 'lodash-es/debounce'
import { tomorrowZero, addDays, dateZero } from '@/utils/date-utils'
import dateformat from 'dateformat'
import { useFullscreen, useWindowSize } from '@vueuse/core'

const { toggle } = useFullscreen()
const { height } = useWindowSize()

// pageSize为一次最多加载的天数
let supportPeriods = reactive([
  { key: '5m', name: '5分', pageSize: 5 },
  { key: '15m', name: '15分', pageSize: 15 },
  { key: '20m', name: '20分', pageSize: 20 },
  { key: '30m', name: '30分', pageSize: 30 },
  { key: '1H', name: '1时', pageSize: 60 },
  { key: '2H', name: '2时', pageSize: 120 },
  { key: 'D', name: '日', pageSize: 600 },
  { key: 'W', name: '周', pageSize: 3000 }
])

let curPeriod = reactive({ key: 'D', name: '日', pageSize: 600 })
let curGoods = reactive({ code: 'RB', name: 'name', mainNum: 'RBL9', mainName: '螺纹指数' })
let curRange = reactive({
  startTime: addDays(new Date(tomorrowZero().getTime()), -curPeriod.pageSize, true).getTime(),
  endTime: tomorrowZero().getTime()
})
const moveSpeed = 20
const zoomSpeed = 0.1
let chartCandleHeight = null

let maIndicatorOpt = {
  name: 'MA',
  shouldOhlc: true,
  calcParams: [5, 10, 30, 60]
}

let option = {
  locale: 'zh-CN',
  timezone: 'Asia/Shanghai',
  styles: defaultStyles
}
let initChart = () => {
  const chart = init('chart', option)
  chart.createIndicator('MACD')
  chart.setMaxOffsetLeftDistance(150)
  chart.setMaxOffsetRightDistance(150)
  loadChartData().then(() => {
    chart.createIndicator(maIndicatorOpt, true, { id: 'candle_pane' })
    if (window.screen.availHeight > document.documentElement.clientHeight) {
      chartCandleHeight = chart.getSize('candle_pane').height
    }
  })

  // chart.subscribeAction(ActionType.OnVisibleRangeChange, debounce(visibleChangeHandler, 1000))
  chart.setLoadDataCallback(debounce(loadMoreData, 200))
  window.chart = chart
}
// 初始化数据，切换周期和品种时调用
let loadChartData = (options) => {
  let params = Object.assign({ symbol: curGoods.mainNum, period: curPeriod.key, from: curRange.startTime, to: curRange.endTime }, options)
  const loadingInstance = ElLoading.service({ fullscreen: false })
  console.log('firstLoadData', dateformat(params.from, 'yyyy-mm-dd HH:MM:ss'), '~', dateformat(params.to, 'yyyy-mm-dd HH:MM:ss'))
  return getBarData(params.symbol, params.period, params.from, params.to).then((res) => {
    chart.applyNewData(res)
    loadingInstance.close()
    hotKeyBind()
  })
}

let disposeChart = () => {
  dispose('chart')
  hotKeyUnBind()
}

// 图标可视区域移动事件响应
// let visibleChangeHandler = (data) => {
//   // console.log('visibleChangeHandler', data)
//   if (data.from < 10 && chart.getDataList().length > 0) {
//     const loadingHistory = ElLoading.service({ fullscreen: false })
//     getBarData(curGoods.value.mainNum, curPeriod.value.key, startTime.value, endTime.value).then((data) => {
//       historyMoreData = data
//       loadingHistory.close()
//     })
//   }
// }

//加载更多数据
let loadMoreData = (option) => {
  if (
    option.type === 'forward' &&
    option.data &&
    chart.getDataList().length > 0 &&
    option.data.timestamp === chart.getDataList()[0].timestamp
  ) {
    hotKeyUnBind()
    // 修改图标数据区间，endTime保持不变
    let endTime = dateZero(new Date(option.data.timestamp)).getTime()
    curRange.startTime = addDays(new Date(endTime), -curPeriod.pageSize, true).getTime()
    let params = Object.assign({ symbol: curGoods.mainNum, period: curPeriod.key, from: curRange.startTime, to: endTime })
    // console.log('loadMoreData', dateformat(startTime.value, 'yyyy-mm-dd HH:MM:ss'), '~', dateformat(endTime.value, 'yyyy-mm-dd HH:MM:ss'))
    getBarData(params.symbol, params.period, params.from, params.to).then((data) => {
      option.callback(data, true)
      hotKeyBind()
    })
  } else {
    option.callback([], true)
  }
}

// K线周期切换事件
emit.on('period_change', (period) => {
  Object.assign(curPeriod, period)
  loadChartData().then()
})

emit.on('goods_change', (goods) => {
  Object.assign(curGoods, goods)
  loadChartData().then()
})

emit.on('fullscreen', () => {
  toggle().then()
})
//
//watch(curPeriod, () => {
//  loadChartData().then()
//})
//
//watch(curGoods, () => {
//  loadChartData().then()
//})

// 窗口高度变化监听，解决F11全屏后窗口不能自适应
watch(height, (nh, oh) => {
  let ch = chart.getSize('candle_pane').height
  chart.getDom('candle_pane').style.height = ch + nh - oh + 'px'
  chart.resize()
})

// 绑定热键
let hotKeyBind = () => {
  key('left', function () {
    chart.scrollByDistance(moveSpeed)
  })

  key('right', function () {
    chart.scrollByDistance(-moveSpeed)
    // chart.scrollToDataIndex(chart.getVisibleRange().realFrom - 1)
  })

  key('up', function () {
    chart.zoomAtDataIndex(1 + zoomSpeed, chart.getVisibleRange().realTo)
  })

  key('down', function () {
    chart.zoomAtDataIndex(1 - zoomSpeed, chart.getVisibleRange().realTo)
  })
}

let hotKeyUnBind = () => {
  key.unbind('left, right, up, down')
}

export { initChart, disposeChart, loadChartData, curPeriod, curGoods, supportPeriods }
