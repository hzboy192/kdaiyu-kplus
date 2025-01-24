/**
 * 此处可直接引用自己项目封装好的 axios 配合后端联调
 */
import request from '@/utils/requests' //组件内部封装的axios

//获取验证图片  以及token
export function reqGet(params) {
  return request({
    url: '/captcha',
    method: 'get',
    params
  })
}

//滑动或者点选验证
export function reqCheck(data) {
  return request({
    url: '/captcha/check',
    method: 'post',
    data
  })
}
