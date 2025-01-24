import router from '@r/index'
import useUserStore from '@s/user'

let createPermission = () => {
  const whiteList = ['/login', '/register']

  const beforeSetting = (to, from, next) => {
    const userStore = useUserStore()
    const existWhite = whiteList.some((item) => item.toLowerCase() === to.path.toLowerCase())
    const token = userStore.token
    // 没有token且不在白名单就放行
    if (!token && !existWhite) {
      return next({ path: '/login', query: { redirect_to: encodeURIComponent(window.location.href) }, replace: true })
    } else {
      // 已登录成功的访问login直接到默认首页
      if (to.path === '/login' && token) {
        return next({ path: '/', replace: true })
      }
      return next()
    }
  }

  const afterSetting = (to, from, failure) => {}

  return {
    install: function (app) {
      router.beforeEach((to, from, next) => beforeSetting(to, from, next))
      router.afterEach((to, from, failure) => afterSetting(to, from, failure))
    }
  }
}

export default createPermission
