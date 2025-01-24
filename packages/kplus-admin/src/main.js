import './assets/css/style.css'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import ElementPlus from 'element-plus'
import zh_CN from 'element-plus/es/locale/lang/zh-cn'
import 'element-plus/theme-chalk/dark/css-vars.css'
import iconFont from '@c/icons/IconFont.vue'

import App from './App.vue'
import router from '@r/index'
import createPermission from '@r/permist'

const app = createApp(App)

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

app.component('IconFont', iconFont)

app.use(ElementPlus, { locale: zh_CN })
app.use(pinia)
app.use(router)
app.use(createPermission())
app.mount('#app')
