import request from '@/utils/request'
import { encrypt } from '@/utils/tools'

// 登录方法
export function login(data) {
  let submitData = Object.assign({}, data)
  // 将密码加密后传输到后的
  submitData.password = encrypt(submitData.password)
  return request({
    url: '/login',
    headers: {
      isToken: false,
      repeatSubmit: false
    },
    method: 'post',
    data: submitData
  })
}

// 注册方法
export function register(data) {
  return request({
    url: '/register',
    headers: {
      isToken: false
    },
    method: 'post',
    data: data
  })
}

// 获取用户详细信息
export function getInfo() {
  return request({
    url: '/current',
    method: 'get'
  })
}

// 退出方法
export function logout() {
  return request({
    url: '/logout',
    method: 'post'
  })
}

// 获取验证码
export function getCodeImg() {
  return request({
    url: '/captcha',
    headers: {
      isToken: false
    },
    method: 'get',
    timeout: 20000
  })
}