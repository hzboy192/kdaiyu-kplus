<script setup>
const props = defineProps({ class: { type: String, default: '' } })
</script>

<template>
  <span :class="['iconfont', props.class]"><slot /></span>
</template>

<style scoped></style>
