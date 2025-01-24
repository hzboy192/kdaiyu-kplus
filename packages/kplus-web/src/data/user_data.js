import http from '@/utils/requests.js'
import { encrypt } from '@/utils/tools'

export function userLogin(loginData) {
  let submitData = Object.assign({}, toRaw(loginData))
  submitData.password = encrypt(submitData.password)
  return http.post('/login', submitData)
}

export function getCurrentUser() {
  return http.get('/current')
}

export function logout() {
  return http.get('/logout')
}
