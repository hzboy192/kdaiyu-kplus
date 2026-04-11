import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    // 默认路由 - 指向新UI
    {
      path: '/',
      name: '/',
      redirect: '/main/dashboard'
    },
    {
      path: '/register',
      name: 'Register',
      component: () => import('../views/auth/RegisterView.vue')
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/auth/LoginView.vue')
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
    },
    // 新增路由 - UI设计平台生成的页面
    {
      path: '/auth/login',
      name: 'AuthLogin',
      component: () => import('../views/auth/LoginView.vue'),
      meta: { title: '登录' }
    },
    {
      path: '/auth/register',
      name: 'AuthRegister',
      component: () => import('../views/auth/RegisterView.vue'),
      meta: { title: '注册' }
    },
    {
      path: '/main',
      name: 'Main',
      component: () => import('../layouts/MainLayout.vue'),
      children: [
        {
          path: '',
          redirect: '/main/training'
        },
        // 核心训练
        {
          path: 'training',
          name: 'Training',
          component: () => import('../views/training/TrainingView.vue'),
          meta: { title: 'K线训练场', icon: 'TrendCharts' }
        },
        {
          path: 'backtest',
          name: 'Backtest',
          component: () => import('../views/training/BacktestView.vue'),
          meta: { title: '历史回测', icon: 'Timer' }
        },
        {
          path: 'strategy',
          name: 'Strategy',
          component: () => import('../views/training/StrategyView.vue'),
          meta: { title: '策略编辑器', icon: 'EditPen' }
        },
        // 账户中心
        {
          path: 'accounts',
          name: 'Accounts',
          component: () => import('../views/account/AccountsView.vue'),
          meta: { title: '账户管理', icon: 'Wallet' }
        },
        {
          path: 'transfer',
          name: 'Transfer',
          component: () => import('../views/account/TransferView.vue'),
          meta: { title: '资金调拨', icon: 'Sort' }
        },
        // 数据中心
        {
          path: 'dashboard',
          name: 'Dashboard',
          component: () => import('../views/analytics/DashboardView.vue'),
          meta: { title: '数据总览', icon: 'PieChart' }
        },
        {
          path: 'statistics',
          name: 'Statistics',
          component: () => import('../views/analytics/StatisticsView.vue'),
          meta: { title: '交易统计', icon: 'Grid' }
        },
        {
          path: 'analysis',
          name: 'Analysis',
          component: () => import('../views/analytics/AnalysisView.vue'),
          meta: { title: '收益分析', icon: 'DataAnalysis' }
        },
        // 社交激励
        {
          path: 'leaderboard',
          name: 'Leaderboard',
          component: () => import('../views/social/LeaderboardView.vue'),
          meta: { title: '排行榜', icon: 'Trophy' }
        },
        {
          path: 'community',
          name: 'Community',
          component: () => import('../views/social/CommunityView.vue'),
          meta: { title: '交流社区', icon: 'ChatDotRound' }
        },
        {
          path: 'copytrading',
          name: 'CopyTrading',
          component: () => import('../views/social/CopyTradingView.vue'),
          meta: { title: '跟单大厅', icon: 'UserFilled' }
        },
        // 个人体系
        {
          path: 'packages',
          name: 'Packages',
          component: () => import('../views/user/PackagesView.vue'),
          meta: { title: '会员套餐', icon: 'Medal' }
        },
        {
          path: 'profile',
          name: 'Profile',
          component: () => import('../views/user/ProfileView.vue'),
          meta: { title: '个人中心', icon: 'User' }
        },
        {
          path: 'settings',
          name: 'Settings',
          component: () => import('../views/user/SettingsView.vue'),
          meta: { title: '系统设置', icon: 'Setting' }
        }
      ]
    }
  ]
})

export default router
