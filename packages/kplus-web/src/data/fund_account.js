/**
 * 资金账户相关服务
 */
import http from '@/utils/requests.js'

/**
 * 获取默认资金账户
 */
export function getFundDftAccount() {
  return http.get('/fundAccount/default')
}

export function saveFundAccount(query) {
  return http.post('/fundAccount', query)
}

export function updateFundAccount(query) {
  return http.put('/fundAccount', query)
}
