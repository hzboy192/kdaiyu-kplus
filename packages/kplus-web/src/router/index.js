import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: '/',
      redirect: '/userCenter'
    },
    {
      path: '/register',
      name: 'Register',
      component: () => import('../views/registerView.vue')
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/loginView.vue')
    },
    {
      path: '/about',
      name: 'about',
      component: () => import('../views/AboutView.vue')
    },
    {
      path: '/kline',
      name: 'kline',
      component: () => import('../views/KlineView.vue')
    },
    {
      path: '/mqtt',
      name: 'mqtt',
      component: () => import('../views/webMqtt.vue')
    },
    {
      path: '/kline-pro',
      name: 'kline-pro',
      component: () => import('../views/klinepro.vue')
    },
    {
      path: '/kline-plus',
      name: 'kline-plus',
      component: () => import('../views/klinePlus.vue')
    },
    {
      path: '/userCenter',
      name: 'userCenter',
      component: () => import('../views/UserCenter.vue'),
      children: [
        {
          path: '',
          name: 'dashboard',
          component: () => import('../components/home/dashboard.vue')
        },
        {
          path: 'analyses',
          name: 'home',
          component: () => import('../components/home/analyses.vue')
        },
        {
          path: 'accountMgr',
          name: 'accountMgr',
          component: () => import('../components/home/accountMgr.vue')
        },
        {
          path: 'profile',
          name: 'profile',
          component: () => import('../components/user/profile.vue')
        }
      ]
    }
  ]
})

export default router
