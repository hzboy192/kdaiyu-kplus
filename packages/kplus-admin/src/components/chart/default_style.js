const upColor = '#F92855' //#c63536 #F92855
const downColor = '#2DC08E' //#2DC08E #10cc55
const yellowColor = '#fbcd01'
const whiteColor = '#d1d1d3'
const purpleColor = '#e537ac'
const blueColor = '#166be3'

export const defaultColor = () => {
  return {
    upColor,
    downColor,
    yellowColor,
    whiteColor,
    purpleColor,
    blueColor
  }
}

export default {
  yAxis: {
    show: true,
    size: 'auto',
    type: 'normal',
    position: 'right',
    inside: false,
    reverse: false,
    axisLine: {
      show: true,
      color: '#333333',
      size: 1
    },
    tickText: {
      show: true,
      color: '#929AA5',
      size: 12,
      family: 'Helvetica Neue',
      weight: 'normal',
      marginStart: 4,
      marginEnd: 4
    },
    tickLine: {
      show: true,
      size: 1,
      length: 3,
      color: '#333333'
    }
  },
  xAxis: {
    show: true,
    size: 'auto',
    axisLine: {
      show: true,
      color: '#333333',
      size: 1
    },
    tickText: {
      show: true,
      color: '#929AA5',
      size: 12,
      family: 'Helvetica Neue',
      weight: 'normal',
      marginStart: 4,
      marginEnd: 4
    },
    tickLine: {
      show: true,
      size: 1,
      length: 3,
      color: '#333333'
    }
  },
  grid: {
    show: true,
    horizontal: {
      show: true,
      size: 1,
      color: '#292929',
      style: 'dashed',
      dashedValue: [2, 2]
    },
    vertical: {
      show: true,
      size: 1,
      color: '#292929',
      style: 'dashed',
      dashedValue: [2, 2]
    }
  },
  candle: {
    bar: {
      downBorderColor: downColor,
      downColor: downColor,
      downWickColor: downColor,
      upBorderColor: upColor,
      upColor: upColor,
      upWickColor: upColor
    },
    tooltip: {
      showRule: 'always',
      showType: 'standard',
      custom: null,
      defaultValue: 'n/a',
      rect: {
        position: 'fixed',
        paddingLeft: 0,
        paddingRight: 0,
        paddingTop: 0,
        paddingBottom: 8,
        offsetLeft: 10,
        offsetTop: 8,
        offsetRight: 10,
        offsetBottom: 8,
        borderRadius: 4,
        borderSize: 1,
        borderColor: 'rgba(10, 10, 10, .6)',
        color: 'rgba(10, 10, 10, .6)'
      },
      text: {
        size: 12,
        family: 'Helvetica Neue',
        weight: 'normal',
        color: '#929AA5',
        marginLeft: 10,
        marginTop: 8,
        marginRight: 6,
        marginBottom: 0
      },
      icons: []
    },
    priceMark: { show: false }
  },
  separator: {
    size: 1,
    color: '#333333',
    fill: true,
    activeBackgroundColor: 'rgba(22, 119, 255, 0.08)'
  },
  indicator: {
    lines: [
      {
        style: 'solid',
        smooth: false,
        size: 1,
        dashedValue: [2, 2],
        color: whiteColor
      },
      {
        style: 'solid',
        smooth: false,
        size: 1,
        dashedValue: [2, 2],
        color: yellowColor
      },
      {
        style: 'solid',
        smooth: false,
        size: 1,
        dashedValue: [2, 2],
        color: purpleColor
      },
      {
        style: 'solid',
        smooth: false,
        size: 1,
        dashedValue: [2, 2],
        color: downColor
      },
      {
        style: 'solid',
        smooth: false,
        size: 1,
        dashedValue: [2, 2],
        color: blueColor
      }
    ],
    ohlc: {
      upColor: upColor,
      downColor: downColor
    },
    bars: [
      {
        style: 'fill',
        borderStyle: 'solid',
        borderSize: 1,
        borderDashedValue: [2, 2],
        upColor: upColor,
        downColor: downColor,
        noChangeColor: '#888888'
      }
    ],
    circles: [
      {
        style: 'fill',
        borderStyle: 'solid',
        borderSize: 1,
        borderDashedValue: [2, 2],
        upColor: upColor,
        downColor: downColor,
        noChangeColor: '#888888'
      }
    ]
  }
}
