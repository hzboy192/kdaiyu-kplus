import http from '@/utils/requests.js'

/**
 * 获取期货商品信息
 *
 * @param search
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
function getGoodsList(search) {
  return http.get('/goodsInfo/search', { params: { searchValue: search } }).then((res) => {
    return res.data || []
  })
}

/**
 * 获取历史k线数据
 * 当标的和周期发生变化的时候触发
 *
 * 返回标的k线数据数组
 */
function getBarData(symbol, period, from, to) {
  return http.get('/bar/list', { params: { symbol, period, from, to } }).then((res) => {
    return res.data || []
  })
}

function getSerCharge(goodCode) {
  return http.get(`/serviceCharge/${goodCode}`).then((res) => {
    return res.data || []
  })
}

export { getGoodsList, getBarData, getSerCharge }
