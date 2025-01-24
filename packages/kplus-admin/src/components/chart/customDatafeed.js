import { getGoodsList, getBarData } from '@/data/kline_pro_data'
import { useDateFormat } from '@vueuse/core'

class CustomDatafeed {
  /**
   * 模糊搜索标的
   * 在搜索框输入的时候触发
   * 返回标的信息数组
   */
  searchSymbols(search) {
    // 根据模糊字段远程拉取标的数据
    return getGoodsList(search)
  }

  /**
   * 获取历史k线数据
   * 当标的和周期发生变化的时候触发
   *
   * 返回标的k线数据数组
   */
  getHistoryKLineData(symbol, period, from, to) {
    let start = useDateFormat(new Date(from), 'YYYY-MM-DD HH:mm:ss')
    let end = useDateFormat(new Date(to), 'YYYY-MM-DD HH:mm:ss')
    console.log('==> req:', symbol.ticker, period.text, start.value, end.value)
    // 完成数据请求
    return getBarData(symbol.ticker, period.text, from, to)
  }

  /**
   * 订阅标的在某个周期的实时数据
   * 当标的和周期发生变化的时候触发
   *
   * 通过callback告知图表接收数据
   */
  subscribe(symbol, period, callback) {
    let closePriv = [3962, 3966, 3961, 3972, 3977, 3979, 3975, 4008, 4021, 4051, 4099]
    // 完成ws订阅或者http轮询
    // setInterval(() => {
    //   callback({close:closePriv[parseInt(Math.random()*10)],high:4100,low:3922,open:3962,period:'D',symbol:'RBL9',timestamp:1706572800000,turnover:null,volume:1028741})
    // }, 500)
    // setTimeout(() => {
    //   callback({close:4040,high:4100,low:4000,open:4004, period:'D',symbol:'RBL9',timestamp:1706659200000,turnover:null,volume:1028741})
    // }, 5000)
    key.unbind('right')
    key('right', function () {
      callback({
        close: closePriv[parseInt(Math.random() * 10)],
        high: 4100,
        low: 3922,
        open: 3962,
        period: 'D',
        symbol: 'RBL9',
        timestamp: 1706572800000,
        turnover: null,
        volume: 1028741
      })
      console.log('you pressed right!')
    })
    console.log('subscribe', symbol, period, callback)
  }

  /**
   * 取消订阅标的在某个周期的实时数据
   * 当标的和周期发生变化的时候触发
   *
   */
  unsubscribe(symbol, period) {
    // 完成ws订阅取消或者http轮询取消
    console.log('unsubscribe', symbol, period)
  }
}

export default CustomDatafeed
