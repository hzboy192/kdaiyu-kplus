<script setup>
import emit from '@u/mitt'
import { supportPeriods } from '@c/chart/ChartPlusCore'

let props = defineProps({
  checkPeriod: {
    type: Object,
    default: () => ({})
  }
})

let periodChangeHandle = (period) => {
  emit.emit('period_change', period)
}
</script>

<template>
  <ul class="period-list">
    <li v-for="it in supportPeriods" :key="it.key" :class="{ active: it.key === props.checkPeriod.key }" @click="periodChangeHandle(it)">
      {{ it.name }}
    </li>
  </ul>
</template>

<style scoped>
.period-list {
  list-style: none;
  display: flex;
  height: 100%;
  font-size: 14px;
  padding: 0 12px;
  box-sizing: border-box;
  border-right: solid 1px var(--kline-border-color);
}

.period-list li {
  padding: 0 8px;
  cursor: pointer;
}

.period-list li:hover {
  background: var(--kline-select-bg-color);
}

.period-list li.active {
  color: var(--kline-active-color);
  background: var(--kline-select-bg-color);
}
</style>
