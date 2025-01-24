<template>
  <div class="demo">
    hello world!
  </div>
</template>

<script setup>
import { ref } from 'vue'

onMounted(() => {
  console.log('demo mounted')
})
</script>

<style lang="scss" scoped></style>