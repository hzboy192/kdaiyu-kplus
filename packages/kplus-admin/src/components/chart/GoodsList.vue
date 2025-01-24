<script setup>
import { getGoodsList } from '@d/kline_pro_data'
import emit from '@/utils/mitt'
import { Search } from '@element-plus/icons-vue'
import { debouncedWatch } from '@vueuse/core'

const props = defineProps({
  checkGoods: {
    type: Object,
    default() {
      return {}
    }
  }
})

let dialogVisible = ref(false)
let dialogDataList = ref([])
let searchText = ref('')

let showGoodsDialog = () => {
  getGoodsList(searchText.value).then((dataList) => {
    dialogVisible.value = true
    dialogDataList.value = dataList
  })
}

debouncedWatch(searchText, showGoodsDialog, { debounce: 500, maxWait: 1000 })

let changeGoods = (goods) => {
  // this.checkGoods = goods
  emit.emit('goods_change', goods)
  dialogVisible.value = false
}
</script>

<template>
  <div class="goods-info" :data-code="props.checkGoods.mainNum" @click="showGoodsDialog">
    <span class="iconfont icon-more">&nbsp;{{ props.checkGoods.mainName }}</span>
  </div>

  <el-dialog v-model="dialogVisible" title="选择商品" width="500" :close-on-click-modal="false" draggable>
    <div>
      <el-input v-model="searchText" :suffix-icon="Search" style="width: 100%" placeholder="商品代码或名称" />
    </div>
    <el-scrollbar max-height="58vh" style="margin-top: 10px">
      <ul v-if="dialogDataList.length > 0" class="goods-list">
        <li v-for="item in dialogDataList" :key="item.id" @click="changeGoods(item)">{{ item.mainName }}({{ item.mainNum }})</li>
      </ul>
      <el-empty v-else description="暂无数据！" />
    </el-scrollbar>
  </el-dialog>
</template>

<style scoped>
.goods-info {
  font-size: 14px;
  height: 100%;
  padding: 0 12px;
  font-weight: 700;
  min-width: 70px;
  box-sizing: border-box;
  border-right: solid 1px var(--kline-border-color);
  cursor: pointer;
}
.goods-list {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 300px;
  margin-top: 5px;
}

.goods-list li {
  width: 100%;
  padding: 0 10px;
  box-sizing: border-box;
  line-height: 32px;
}

.goods-list li:hover {
  background: var(--kline-select-bg-color);
  cursor: pointer;
}
</style>
