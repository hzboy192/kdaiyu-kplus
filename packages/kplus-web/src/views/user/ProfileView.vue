<script setup>
import { ref } from 'vue'
import { ElForm, ElFormItem, ElInput, ElButton, ElAvatar, ElTag, ElUpload, ElIcon, ElMessage } from 'element-plus'
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
  { label: '账户数量', value: '3个', icon: Wallet },
  { label: '交易天数', value: '128天', icon: Calendar },
  { label: '最高排名', value: '第56名', icon: Trophy }
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
  <div class="space-y-6">
    <!-- Header -->
    <div>
      <h2 class="text-xl font-bold text-gray-800">个人中心</h2>
      <p class="text-gray-500 text-sm mt-1">资料维护、账户绑定、隐私设置</p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Profile Card -->
      <div class="bg-white rounded-2xl border border-gray-100 p-6">
        <div class="text-center">
          <div class="relative inline-block mb-4">
            <el-avatar 
              :size="96" 
              src="https://api.dicebear.com/7.x/avataaars/svg?seed=Felix"
              class="border-4 border-primary-100"
            />
            <el-upload
              action="#"
              :show-file-list="false"
              accept="image/*"
              class="absolute bottom-0 right-0"
            >
              <button class="w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center hover:bg-primary-700 transition-colors shadow-lg">
                <el-icon :size="14"><Camera /></el-icon>
              </button>
            </el-upload>
          </div>
          <h3 class="text-xl font-bold text-gray-800">{{ userProfile.nickname }}</h3>
          <p class="text-sm text-gray-500 mt-1">ID: {{ userProfile.userId }}</p>
          <div class="flex justify-center gap-2 mt-3">
            <el-tag type="warning" effect="light" size="small">VIP会员</el-tag>
            <el-tag type="info" effect="light" size="small">3个账户</el-tag>
          </div>
        </div>

        <div class="mt-6 pt-6 border-t border-gray-100 space-y-4">
          <div 
            v-for="stat in userStats" 
            :key="stat.label"
            class="flex items-center gap-3 p-3 bg-gray-50 rounded-xl"
          >
            <div class="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center text-primary-600">
              <el-icon :size="20"><component :is="stat.icon" /></el-icon>
            </div>
            <div>
              <p class="text-xs text-gray-500">{{ stat.label }}</p>
              <p class="font-semibold text-gray-800">{{ stat.value }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Edit Form -->
      <div class="lg:col-span-2 bg-white rounded-2xl border border-gray-100 p-6">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg font-semibold text-gray-800">基本信息</h3>
          <el-button 
            v-if="!isEditing"
            type="primary" 
            link
            @click="isEditing = true"
          >
            <el-icon class="mr-1"><Edit /></el-icon>
            编辑
          </el-button>
        </div>

        <el-form 
          :model="formData" 
          label-position="top"
          :disabled="!isEditing"
        >
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <el-form-item label="昵称">
              <el-input v-model="formData.nickname" placeholder="请输入昵称" />
            </el-form-item>
            <el-form-item label="手机号">
              <el-input 
                v-model="formData.phone" 
                disabled 
                placeholder="手机号"
              >
                <template #append>
                  <el-button :disabled="false">更换</el-button>
                </template>
              </el-input>
            </el-form-item>
            <el-form-item label="邮箱" class="md:col-span-2">
              <el-input v-model="formData.email" placeholder="请输入邮箱" />
            </el-form-item>
            <el-form-item label="个人简介" class="md:col-span-2">
              <el-input 
                v-model="formData.bio" 
                type="textarea" 
                :rows="3"
                placeholder="介绍一下你自己..."
                maxlength="200"
                show-word-limit
              />
            </el-form-item>
          </div>

          <div v-if="isEditing" class="flex justify-end gap-3 mt-6 pt-6 border-t border-gray-100">
            <el-button @click="handleCancel">取消</el-button>
            <el-button type="primary" @click="handleSave">保存修改</el-button>
          </div>
        </el-form>

        <!-- Security Section -->
        <div class="mt-8 pt-6 border-t border-gray-100">
          <h3 class="text-lg font-semibold text-gray-800 mb-4">安全设置</h3>
          <div class="space-y-4">
            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
              <div>
                <p class="font-medium text-gray-800">登录密码</p>
                <p class="text-sm text-gray-500">定期更换密码可以保护账户安全</p>
              </div>
              <el-button type="primary" link>修改</el-button>
            </div>
            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
              <div>
                <p class="font-medium text-gray-800">两步验证</p>
                <p class="text-sm text-gray-500">开启后登录需要手机验证码</p>
              </div>
              <el-button type="primary" link>开启</el-button>
            </div>
            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
              <div>
                <p class="font-medium text-gray-800">设备管理</p>
                <p class="text-sm text-gray-500">管理已登录的设备</p>
              </div>
              <el-button type="primary" link>查看</el-button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
