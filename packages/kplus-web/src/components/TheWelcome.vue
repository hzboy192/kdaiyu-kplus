<script setup>
import WelcomeItem from './WelcomeItem.vue'
import router from '@r'

function go() {
  router.push({ path: 'kline' })
}
</script>

<template>
  <WelcomeItem>
    <el-button @click="go">GO>></el-button>
    <router-link to="/kline" style="padding: 5px 15px">GO link</router-link>
    <router-link to="/kline-pro" style="padding: 5px 15px">Kline Pro</router-link>
    <router-link to="/mqtt" style="padding: 5px 15px">GO mqtt</router-link>
  </WelcomeItem>
</template>
