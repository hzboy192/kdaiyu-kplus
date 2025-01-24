<template>
  <el-dialog v-model="trainDialog.show" title="模拟训练" width="500" draggable :close-on-click-modal="false" @opened="trainDialogOpened">
    <el-scrollbar max-height="58vh">
      <el-form ref="trainFormRef" :model="trainSetting" label-width="80">
        <el-row>
          <el-col :span="12">
            <el-form-item label="选择商品" prop="searchGoods">
              <el-select
                v-model="trainSetting.goods"
                value-key="mainNum"
                filterable
                placeholder="输入商品名称或编码"
                @change="handleSymbolChange"
              >
                <el-option v-for="item in trainDialog.goodsOptions" :key="item.id" :label="item.mainName" :value="item" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="周期" prop="period">
              <el-select v-model="trainSetting.period" value-key="key" placeholder="周期">
                <el-option v-for="period in supportPeriods" :key="period.key" :label="period.name" :value="period" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="时间范围" prop="range">
          <el-date-picker
            v-model="trainSetting.range"
            type="daterange"
            :shortcuts="trainDialog.shortcuts"
            range-separator="~"
            start-placeholder="start"
            end-placeholder="end"
            date-format="YYYY-MM-DD"
            format="YYYY-MM-DD"
            :disabled-date="(d) => d > now()"
          />
        </el-form-item>
        <el-form-item label="播放方式" prop="playType">
          <el-radio-group v-model="trainSetting.playType" aria-label="播放方式">
            <el-radio-button value="manual">手动</el-radio-button>
            <el-radio-button value="auto">自动</el-radio-button>
          </el-radio-group>
          <div v-if="trainSetting.playType === 'manual'" class="pay-set">
            <el-text type="warning" size="small">每按一次“S”键播放一根K线</el-text>
          </div>
          <div v-else class="pay-set"><el-text type="warning" size="small">每1秒播放一根K线</el-text></div>
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="开仓数" prop="openNum">
              <el-input-number v-model="trainSetting.openNum" controls-position="right" :min="1" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="平仓数" prop="closeNum">
              <el-input-number v-model="trainSetting.closeNum" controls-position="right" :min="1" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label-width="12">
          <el-alert title="键盘快捷键：W.平仓，A.下空单，D.多单；鼠标下单工具栏右上角" type="warning" :closable="false" show-icon />
        </el-form-item>
      </el-form>
    </el-scrollbar>
    <template #footer>
      <!--<div class="dialog-footer">-->
      <el-button @click="trainDialogReset(trainFormRef)">重置</el-button>
      <el-button type="primary" @click="trainStart"> 开始训练 </el-button>
      <!--</div>-->
    </template>
  </el-dialog>
</template>
<script setup>
import { now } from 'lodash-es'
import { getGoodsList } from '@d/kline_pro_data'
import { todayZero } from '@/utils/date-utils'
import emit from '@/utils/mitt'
import { getTrainSymbol } from '@d/train_trade_data'

let trainDialog = reactive({ show: false, goodsOptions: [] })
const trainFormRef = ref(null)
const $emit = defineEmits(['start'])
const props = defineProps({
  supportPeriods: {
    type: Array,
    default: () => []
  }
})
/**
 * @property tId 训练id，雪花算法，每次训练唯一标识，雪花算法
 *
 */
const start = todayZero()
start.setFullYear(start.getFullYear() - 2)

let trainSetting = reactive({
  playType: 'manual',
  searchGoods: null,
  goods: { code: 'RB', name: 'name', mainNum: 'RBL9', mainName: '螺纹指数' },
  period: { key: 'D', name: '日', pageSize: 600 },
  range: [start, todayZero()],
  from: null,
  to: null,
  openNum: 1,
  closeNum: 1,
  fundId: undefined, //资金账户Id
  symbolInfo: {} // 商品信息,单价/手续费...
})

//  查询商品的配置信息，单价/手续费...
getTrainSymbol({ goodCode: trainSetting.goods.code }).then(({ data }) => {
  trainSetting.symbolInfo = data
})

trainDialog.shortcuts = [
  {
    text: '近2年',
    value: () => {
      const end = todayZero()
      const start = todayZero()
      start.setFullYear(start.getFullYear() - 2)
      return [start, end]
    }
  },
  {
    text: '近5年',
    value: () => {
      const end = todayZero()
      const start = todayZero()
      start.setFullYear(start.getFullYear() - 5)
      return [start, end]
    }
  },
  {
    text: '近10年',
    value: () => {
      const end = todayZero()
      const start = todayZero()
      start.setFullYear(start.getFullYear() - 10)
      return [start, end]
    }
  }
]

let trainDialogOpened = () => {
  // 只在第一次弹框时初始化数据，实现页面过滤
  if (trainDialog.goodsOptions.length === 0) {
    getGoodsList(trainSetting.searchGoods).then((goodList) => {
      trainDialog.goodsOptions = goodList
    })
  }
}

// 监听时间修改后触发，赋值到from/to属性
watch(trainSetting.range, (value, oldValue) => {
  trainSetting.from = value[0]
  trainSetting.to = value[1]
})

let trainDialogReset = (formEl) => {
  if (!formEl) return
  formEl.resetFields()
}

let trainStart = () => {
  // todo 当时间范围太短时需要提醒。
  // todo 验证时间范围是否合法
  trainDialog.show = false
  $emit('start', trainSetting)
}

let handleSymbolChange = (item) => {
  console.log('handleSymbolChange', item)
  //  查询商品的配置信息，单价/手续费...
  getTrainSymbol({ goodCode: item.code }).then(({ data }) => {
    trainSetting.symbolInfo = data
  })
}

emit.on('gameOver', () => {
  formEl.resetFields()
  trainSetting.traId = null
})

defineExpose({
  showDialog() {
    trainDialog.show = true
  }
})
</script>

<style scoped>
.pay-set {
  margin-left: 15px;
}

.trade-num {
  .el-text {
    margin-right: 5px;
  }

  .el-text:nth-child(3) {
    margin-left: 40px;
  }
  .el-input-number {
    max-width: 100px;
  }
}
</style>
