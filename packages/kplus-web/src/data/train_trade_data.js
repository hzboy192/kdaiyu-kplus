//训练交易
import http from '@/utils/requests.js'

/**
 * 获取交易记录
 */
export function getTrainData(query) {
  return http.get('userTrain', query)
}

/**
 * 保存训练数据
 */
export function saveTrainData(data) {
  return http.post('/userTrain', data)
}

/**
 * 保存训练数据
 */
export function updateTrainData(data) {
  return http.put('/userTrain', data)
}

/**
 * 获取训练品种的信息
 *
 * @param {googCode, symbol} data 商品编码/合约编码
 * @returns 合约设置/手续费/保证金...
 */
export function getTrainSymbol(data) {
  return http.post('/userTrain/SymbolInfo', data)
}

/**
 * 查询交易记录详情
 */
export function getTrainDtl(data) {
  return http.get('/userTrainDtl/list', data)
}
/**
 * 添加 训练交易记录
 */
export function addTrainDtl(data) {
  return http.post('/userTrainDtl', data)
}

/**
 * 开仓交易记录
 */
export function openTrainDtl(data) {
  return http.post('/userTrainDtl/open', data)
}

/**
 * 平交易记录
 */
export function closeTrainDtl(data) {
  return http.post('/userTrainDtl/close', data)
}

/**
 * 更新训练交易记录
 */
export function updateTrainDtl(data) {
  return http.put('/userTrainDtl', data)
}

/**
 * 批量更新训练交易记录
 */
export function updateBatchTrainDtl(data) {
  return http.put('/userTrainDtl/batch', data)
}

/**
 * 获取训练加以汇总
 */
export function getTrainSummary(traId) {
  return http.get('/userTrainDtl/summary/' + traId)
}
