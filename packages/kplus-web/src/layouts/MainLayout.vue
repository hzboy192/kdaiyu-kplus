<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import SidebarNav from '@c/layout/SidebarNav.vue'
import HeaderBar from '@c/layout/HeaderBar.vue'

const route = useRoute()
const router = useRouter()
const isCollapsed = ref(false)

const pageTitle = computed(() => {
  return route.meta?.title || '口袋鱼'
})

const toggleSidebar = () => {
  isCollapsed.value = !isCollapsed.value
}
</script>

<template>
  <div class="min-h-screen flex bg-app">
    <!-- Sidebar -->
    <SidebarNav :collapsed="isCollapsed" @toggle="toggleSidebar" />

    <!-- Main Content -->
    <div class="flex-1 flex flex-col transition-all duration-200" :class="isCollapsed ? 'ml-[72px]' : 'ml-60'">
      <!-- Header -->
      <HeaderBar :title="pageTitle" @toggle-sidebar="toggleSidebar" />

      <!-- Page Content -->
      <main class="flex-1 p-6 lg:p-8 overflow-auto">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
