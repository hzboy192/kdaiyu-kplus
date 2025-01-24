let styles = {
  candle: {
    type: 'area',
    priceMark: {
      last: { show: false }
    }
  },

  yAxis: { show: false }
}

let customApi = {}

let options = {
  locale: 'zh-CN',
  timezone: '',
  styles,
  customApi,
  thousandsSeparator: ''
}

export { styles, customApi }
export default options
