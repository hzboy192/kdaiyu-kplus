<script setup>
import { KLineChartPro } from '@klinecharts/pro'
import CustomDatafeed from '@/components/chart/customDatafeed'
import defaultStyles from '@c/chart/default_style'

import '@klinecharts/pro/dist/klinecharts-pro.css'
import { setThemeClass, restoreTheme } from '@/utils/theme'

onMounted(() => {
  setThemeClass('dark')

  initKlineChart()

  bindHotKey()
})

onUnmounted(() => {
  restoreTheme()
})

const initKlineChart = () => {
  const chart = new KLineChartPro({
    theme: 'dark', //ligh|dark
    locale: 'zh-CN',
    container: document.getElementById('container'),
    // 初始化标的信息
    symbol: {
      exchange: '',
      market: 'future',
      name: '螺纹指数',
      shortName: '螺纹',
      ticker: 'RBL9',
      priceCurrency: 'CNY',
      type: ''
    },
    // 初始化周期
    period: { multiplier: 1, timespan: 'day', text: 'D' },
    periods: [
      { multiplier: 5, timespan: 'minute', text: '5M' },
      { multiplier: 15, timespan: 'minute', text: '15M' },
      { multiplier: 1, timespan: 'hour', text: '1H' },
      { multiplier: 2, timespan: 'hour', text: '2H' },
      { multiplier: 1, timespan: 'day', text: 'D' },
      { multiplier: 1, timespan: 'week', text: 'W' }
    ],
    datafeed: new CustomDatafeed(),
    watermark: '',
    styles: defaultStyles,
    subIndicators: ['MACD']
  })
  // 方便浏览器中查看图标对象
  window.chart = chart
}

// 热键绑定
const bindHotKey = () => {
  key('ctrl+a', function () {
    console.log('you pressed ctrl+a!')
  })
  key('down', function () {
    console.log('you pressed down!')
  })
  key('up', function () {
    console.log('you pressed up!')
  })
  // key('right', function(){ console.log('you pressed right!') })
  key('left', function () {
    console.log('you pressed left!')
  })
}
</script>
<template>
  <div class="kl-container">
    <div id="container" />
  </div>
</template>
<style>
.kl-container,
#container {
  width: 100%;
  height: 100vh;
}
</style>
