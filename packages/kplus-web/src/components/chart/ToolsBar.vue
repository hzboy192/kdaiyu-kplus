<script setup>
import emit from '@/utils/mitt'

let idxDialog = ref(false)
let settingDialog = ref(false)
let isFullScreen = ref(false)

let props = defineProps({
  isTrainRunning: { default: false }
})
// const $emit = defineEmits(['command'])

let toggleFullScreen = () => {
  isFullScreen.value = !isFullScreen.value
  emit.emit('fullscreen')
}
</script>

<template>
  <ul class="tools-bar">
    <li disabled="props.isTrainRunning" @click="idxDialog = !idxDialog">
      <i class="iconfont icon-zhibiaozhongxin-fx">指标</i>
    </li>
    <li @click="settingDialog = !settingDialog">
      <i class="iconfont icon-shezhi1">设置</i>
    </li>
    <li @click="toggleFullScreen">
      <i :class="['iconfont', !isFullScreen ? 'icon-quanpingzuidahua' : 'icon-zuixiaohua']">全屏</i>
    </li>
    <!-- todo: 训练开始后按钮变为退出训练模式 -->
    <li @click="$emit('command', 'openTrain')"><i class="iconfont icon-xunlianying">训练</i></li>
    <li @click="$emit('command', 'finishTrain')"><span class="iconfont icon-a-zhibiaozhongxin2"></span>指标</li>
    <!--<li><span class="iconfont icon-zhibiaokuxuanzhong"></span>指标</li>-->
  </ul>
</template>

<style scoped>
.tools-bar {
  display: flex;
  font-size: 14px;
}
.tools-bar li {
  padding: 0 10px;
  cursor: pointer;
  box-sizing: border-box;
  border-right: solid 1px var(--kline-border-color);
}

.tools-bar .iconfont {
  padding-right: 2px;
  font-size: 16px;
}
.tools-bar li:hover {
  color: var(--kline-active-color);
}

.tools-bar li.active {
  color: var(--kline-active-color);
  background: var(--kline-select-bg-color);
}
</style>
