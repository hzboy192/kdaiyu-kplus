/**
 * 期货数据
 */
import request from '@/utils/requests.js'

// 获取合约数据，type='M' 获取主力合约
function getGoods(type = '') {
  let url = '/sina/goods'
  if (type === 'M') url = '/sina/mGoods'
  return request.get(url).then((res) => {
    if (res.status === 200 && res.data) {
      return Promise.resolve(res.data)
    } else {
      return Promise.reject('合约数据获取异常！')
    }
  })
}

// 获取k线数据
function getKlineHistory(fu_code, cycle = 'D') {
  if (!fu_code) console.error('fu_code must be given!')
  let url = `/sina/kline/${fu_code}?cycle=${cycle}`
  return request.get(url).then((res) => {
    let klineData = []
    if (res.status === 200 && res.data) {
      res.data.forEach((d) => {
        klineData.push({
          timestamp: Date.parse(d.d),
          open: parseInt(d.o),
          close: parseInt(d.c),
          high: parseInt(d.h),
          low: parseInt(d.l),
          volume: parseInt(d.p)
        })
      })
      return Promise.resolve(klineData)
    } else {
      return Promise.reject('kline分钟数据异常！')
    }
  })
}

export { getKlineHistory, getGoods }
