import axios from 'axios'
import { ElNotification, ElMessage } from 'element-plus'
import { logout } from '@d/user_data'
import useUserStore from '@s/user'

const defaultOption = {
  baseURL: '/api',
  timeout: import.meta.env.VITE_APP_AXISO_TIMEOUT,
  loading: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
}
const http = axios.create(defaultOption)

http.interceptors.request.use(
  (config) => {
    const userStore = useUserStore()
    let token = userStore.token
    token && config.headers.setAuthorization(token)
    return config
  },
  (error) => {
    console.error(error)
    return Promise.reject(error)
  }
)

http.interceptors.response.use(
  (response) => {
    return response.data
  },
  (error) => {
    const statusCode = error && error.response.status
    const message = error && error.message
    if (statusCode === 500 || statusCode === 404) {
      ElNotification({ title: '系统异常', message: `服务端出现${statusCode}异常，请于技术人员联系。`, type: 'error' })
      return Promise.reject(error)
    } else if (statusCode === 401) {
      const userStore = useUserStore()
      // ElNotification({ title: '登录异常', message: '账号登录已过期！请重新登录。', type: 'error' })
      userStore.logout().then(() => {
        window.location.href = '/login?redirect_to=' + decodeURIComponent(window.location.href)
      })
      return Promise.reject(error)
    } else if (message.indexOf('timeout') !== -1 || message.indexOf('Network Error') !== -1) {
      ElMessage({ type: 'error', message: '请求超时，请您稍后重试' })
      return Promise.reject(error)
    }
    return error.response.data
  }
)

export default http
