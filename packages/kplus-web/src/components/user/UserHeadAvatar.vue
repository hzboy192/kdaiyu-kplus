<script setup>
import { ArrowDown } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import useUserStore from '@s/user'

const router = useRouter()
const userStore = useUserStore()

let handleDropdown = (command) => {
  console.log('command', command)
  if (command === 'logout') {
    userStore.logout().then(() => {
      router.push({ path: '/' })
    })
  } else {
    router.push({ name: command })
  }
}
</script>

<template>
  <el-dropdown tabindex="100000" @command="handleDropdown">
    <div style="display: flex; justify-content: center; align-items: center">
      <el-avatar size="small" src="/image/user.jpg" />
      <el-icon><arrow-down /></el-icon>
    </div>
    <template #dropdown>
      <el-dropdown-menu>
        <el-dropdown-item command="userCenter">个人中心</el-dropdown-item>
        <el-dropdown-item command="">个性化设置</el-dropdown-item>
        <el-dropdown-item command="logout">退出登录</el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>
</template>

<style scoped></style>
