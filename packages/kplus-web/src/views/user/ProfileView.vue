<script setup>
import { ref } from 'vue'
import { ElForm, ElFormItem, ElInput, ElButton, ElAvatar, ElUpload, ElIcon, ElMessage } from 'element-plus'
import { Camera, Edit, Wallet, Calendar, Trophy } from '@element-plus/icons-vue'

const userProfile = ref({
  nickname: '泊远万里',
  userId: '885234',
  phone: '138****8888',
  email: 'user@example.com',
  bio: '专注于量化交易和技术分析，追求稳定收益。'
})

const isEditing = ref(false)
const formData = ref({ ...userProfile.value })

const userStats = [
  { label: '账户数量', value: '3', unit: '个', icon: Wallet },
  { label: '交易天数', value: '128', unit: '天', icon: Calendar },
  { label: '最高排名', value: '56', unit: '名', icon: Trophy }
]

const securityItems = [
  { title: '登录密码', desc: '定期更换密码可以保护账户安全', action: '修改' },
  { title: '两步验证', desc: '开启后登录需要手机验证码', action: '开启' },
  { title: '设备管理', desc: '管理已登录的设备', action: '查看' }
]

const handleSave = () => {
  userProfile.value = { ...formData.value }
  isEditing.value = false
  ElMessage.success('保存成功')
}

const handleCancel = () => {
  formData.value = { ...userProfile.value }
  isEditing.value = false
}
</script>

<template>
  <div class="profile-light bg-white rounded-lg border border-gray-200 overflow-hidden">
    <!-- 个人信息头部 -->
    <div class="p-6 lg:p-8 flex flex-col lg:flex-row lg:items-center gap-6 border-b border-gray-100">
      <div class="flex items-center gap-5 flex-1 min-w-0">
        <div class="relative shrink-0">
          <el-avatar :size="72" src="https://api.dicebear.com/7.x/avataaars/svg?seed=Felix" />
          <el-upload action="#" :show-file-list="false" accept="image/*" class="absolute -bottom-1 -right-1">
            <button
              class="w-6 h-6 bg-primary-500 text-white rounded-full flex items-center justify-center hover:bg-primary-600 transition-colors"
            >
              <el-icon :size="12"><Camera /></el-icon>
            </button>
          </el-upload>
        </div>
        <div class="min-w-0">
          <div class="flex items-center gap-2.5">
            <h2 class="text-xl font-semibold text-gray-900 truncate">{{ userProfile.nickname }}</h2>
            <span class="shrink-0 text-xs text-primary-600 bg-primary-50 border border-primary-100 rounded px-1.5 py-0.5"> VIP 会员 </span>
          </div>
          <p class="text-sm text-gray-400 mt-1 font-mono tabular-nums">ID {{ userProfile.userId }}</p>
          <p class="text-sm text-gray-500 mt-1.5">{{ userProfile.bio }}</p>
        </div>
      </div>

      <div class="flex items-center gap-8 shrink-0">
        <template v-for="(stat, i) in userStats" :key="stat.label">
          <div v-if="i > 0" class="w-px h-10 bg-gray-200"></div>
          <div class="text-center min-w-[72px]">
            <p class="text-xs text-gray-400">{{ stat.label }}</p>
            <p class="mt-1.5 text-xl font-semibold text-gray-900 font-mono tabular-nums">
              {{ stat.value }}<span class="text-xs font-normal text-gray-400 ml-0.5">{{ stat.unit }}</span>
            </p>
          </div>
        </template>
      </div>
    </div>

    <!-- 基本信息 -->
    <div class="p-6 lg:p-8 border-b border-gray-100">
      <div class="flex items-center justify-between mb-6">
        <h3 class="text-base font-semibold text-gray-900">基本信息</h3>
        <el-button v-if="!isEditing" link @click="isEditing = true">
          <el-icon class="mr-1"><Edit /></el-icon>
          编辑
        </el-button>
      </div>

      <el-form :model="formData" label-position="top" :disabled="!isEditing">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-1">
          <el-form-item label="昵称">
            <el-input v-model="formData.nickname" placeholder="请输入昵称" />
          </el-form-item>
          <el-form-item label="手机号">
            <el-input v-model="formData.phone" disabled placeholder="手机号">
              <template #append>
                <el-button :disabled="false">更换</el-button>
              </template>
            </el-input>
          </el-form-item>
          <el-form-item label="邮箱" class="md:col-span-2">
            <el-input v-model="formData.email" placeholder="请输入邮箱" />
          </el-form-item>
          <el-form-item label="个人简介" class="md:col-span-2">
            <el-input v-model="formData.bio" type="textarea" :rows="3" placeholder="介绍一下你自己..." maxlength="200" show-word-limit />
          </el-form-item>
        </div>

        <div v-if="isEditing" class="flex justify-end gap-3 mt-4 pt-5 border-t border-gray-100">
          <el-button @click="handleCancel">取消</el-button>
          <el-button type="primary" @click="handleSave">保存修改</el-button>
        </div>
      </el-form>
    </div>

    <!-- 安全设置 -->
    <div class="p-6 lg:p-8">
      <h3 class="text-base font-semibold text-gray-900 mb-2">安全设置</h3>
      <div class="divide-y divide-gray-100">
        <div v-for="item in securityItems" :key="item.title" class="flex items-center justify-between py-4 first:pt-2 last:pb-0">
          <div>
            <p class="text-sm font-medium text-gray-800">{{ item.title }}</p>
            <p class="text-xs text-gray-400 mt-0.5">{{ item.desc }}</p>
          </div>
          <el-button link>{{ item.action }}</el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 浅色页内局部覆盖全局暗色 EP 变量 */
.profile-light {
  --el-bg-color: #ffffff;
  --el-bg-color-overlay: #ffffff;
  --el-text-color-primary: #111827;
  --el-text-color-regular: #374151;
  --el-text-color-secondary: #6b7280;
  --el-text-color-placeholder: #9ca3af;
  --el-text-color-disabled: #9ca3af;
  --el-border-color: #d1d5db;
  --el-border-color-light: #e5e7eb;
  --el-border-color-lighter: #e5e7eb;
  --el-border-color-extra-light: #f3f4f6;
  --el-fill-color-blank: #ffffff;
  --el-fill-color-light: #f3f4f6;
  --el-fill-color: #f3f4f6;
  --el-fill-color-lighter: #f9fafb;
  --el-disabled-bg-color: #f3f4f6;
  --el-input-bg-color: #ffffff;
  --el-color-primary: #2962ff;
  --el-color-primary-light-3: #5c8fff;
  --el-color-primary-light-5: #8fb4ff;
  --el-color-primary-light-7: #b9d1ff;
  --el-color-primary-light-8: #dce8ff;
  --el-color-primary-light-9: #eef4ff;
  --el-color-primary-dark-2: #1f4fd6;
}

.profile-light :deep(.el-button--primary) {
  --el-button-bg-color: #2962ff;
  --el-button-border-color: #2962ff;
  --el-button-text-color: #ffffff;
  --el-button-hover-bg-color: #1f4fd6;
  --el-button-hover-border-color: #1f4fd6;
  --el-button-active-bg-color: #1a41ae;
  --el-button-active-border-color: #1a41ae;
}

.profile-light :deep(.el-button.is-link) {
  --el-button-text-color: #1f4fd6;
  --el-button-hover-text-color: #2962ff;
}
</style>
