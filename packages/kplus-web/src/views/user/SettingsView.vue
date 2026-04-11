<script setup>
import { ref } from 'vue'
import { ElSwitch, ElSelect, ElOption, ElButton, ElMessage, ElIcon } from 'element-plus'
import { Bell, Monitor, Lock, InfoFilled } from '@element-plus/icons-vue'

const settings = ref({
  tradeNotify: true,
  accountNotify: true,
  communityNotify: false,
  emailNotify: true,
  darkMode: false,
  language: 'zh-CN',
  timezone: 'Asia/Shanghai',
  chartStyle: 'candle'
})

const handleSave = () => {
  ElMessage.success('设置已保存')
}

const settingGroups = [
  {
    title: '通知设置',
    icon: Bell,
    items: [
      { key: 'tradeNotify', label: '交易提醒', desc: '训练结束、达到止盈止损线时推送通知' },
      { key: 'accountNotify', label: '账户变动提醒', desc: '账户创建、资金调拨、账户删除时发送通知' },
      { key: 'communityNotify', label: '社区消息', desc: '关注的用户发帖、帖子被回复时通知' },
      { key: 'emailNotify', label: '邮件通知', desc: '重要消息通过邮件发送' }
    ]
  },
  {
    title: '显示设置',
    icon: Monitor,
    items: [
      { key: 'darkMode', label: '深色模式', desc: '使用深色主题减少眼睛疲劳' }
    ]
  }
]

const selectSettings = [
  { key: 'language', label: '界面语言', options: [
    { value: 'zh-CN', label: '简体中文' },
    { value: 'zh-TW', label: '繁体中文' },
    { value: 'en-US', label: 'English' }
  ]},
  { key: 'timezone', label: '时区', options: [
    { value: 'Asia/Shanghai', label: '中国标准时间 (UTC+8)' },
    { value: 'Asia/Tokyo', label: '日本标准时间 (UTC+9)' },
    { value: 'America/New_York', label: '美国东部时间 (UTC-5)' }
  ]},
  { key: 'chartStyle', label: 'K线样式', options: [
    { value: 'candle', label: '蜡烛图' },
    { value: 'bar', label: '美式线' },
    { value: 'line', label: '折线图' }
  ]}
]
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div>
      <h2 class="text-xl font-bold text-gray-800">系统设置</h2>
      <p class="text-gray-500 text-sm mt-1">通知偏好、显示设置、安全中心</p>
    </div>

    <!-- Switch Settings -->
    <div 
      v-for="group in settingGroups" 
      :key="group.title"
      class="bg-white rounded-2xl border border-gray-100 overflow-hidden"
    >
      <div class="px-6 py-4 border-b border-gray-100 flex items-center gap-3">
        <div class="w-10 h-10 bg-primary-100 rounded-xl flex items-center justify-center text-primary-600">
          <el-icon :size="20"><component :is="group.icon" /></el-icon>
        </div>
        <h3 class="text-lg font-semibold text-gray-800">{{ group.title }}</h3>
      </div>
      <div class="divide-y divide-gray-100">
        <div 
          v-for="item in group.items" 
          :key="item.key"
          class="flex items-center justify-between px-6 py-4 hover:bg-gray-50 transition-colors"
        >
          <div>
            <p class="font-medium text-gray-800">{{ item.label }}</p>
            <p class="text-sm text-gray-500">{{ item.desc }}</p>
          </div>
          <el-switch 
            v-model="settings[item.key as keyof typeof settings]" 
            :active-value="true"
            :inactive-value="false"
          />
        </div>
      </div>
    </div>

    <!-- Select Settings -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-100 flex items-center gap-3">
        <div class="w-10 h-10 bg-primary-100 rounded-xl flex items-center justify-center text-primary-600">
          <el-icon :size="20"><Monitor /></el-icon>
        </div>
        <h3 class="text-lg font-semibold text-gray-800">偏好设置</h3>
      </div>
      <div class="divide-y divide-gray-100">
        <div 
          v-for="item in selectSettings" 
          :key="item.key"
          class="flex items-center justify-between px-6 py-4"
        >
          <p class="font-medium text-gray-800">{{ item.label }}</p>
          <el-select 
            v-model="settings[item.key as keyof typeof settings]" 
            class="!w-52"
          >
            <el-option 
              v-for="opt in item.options" 
              :key="opt.value" 
              :label="opt.label" 
              :value="opt.value" 
            />
          </el-select>
        </div>
      </div>
    </div>

    <!-- Security Settings -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-100 flex items-center gap-3">
        <div class="w-10 h-10 bg-primary-100 rounded-xl flex items-center justify-center text-primary-600">
          <el-icon :size="20"><Lock /></el-icon>
        </div>
        <h3 class="text-lg font-semibold text-gray-800">安全中心</h3>
      </div>
      <div class="divide-y divide-gray-100">
        <div class="flex items-center justify-between px-6 py-4 hover:bg-gray-50 transition-colors cursor-pointer">
          <div>
            <p class="font-medium text-gray-800">修改密码</p>
            <p class="text-sm text-gray-500">上次修改: 30天前</p>
          </div>
          <el-button type="primary" link>修改</el-button>
        </div>
        <div class="flex items-center justify-between px-6 py-4 hover:bg-gray-50 transition-colors cursor-pointer">
          <div>
            <p class="font-medium text-gray-800">两步验证</p>
            <p class="text-sm text-gray-500">增强账户安全性</p>
          </div>
          <el-button type="primary" link>设置</el-button>
        </div>
        <div class="flex items-center justify-between px-6 py-4 hover:bg-gray-50 transition-colors cursor-pointer">
          <div>
            <p class="font-medium text-gray-800">登录设备管理</p>
            <p class="text-sm text-gray-500">当前有3个设备登录</p>
          </div>
          <el-button type="primary" link>管理</el-button>
        </div>
        <div class="flex items-center justify-between px-6 py-4 hover:bg-gray-50 transition-colors cursor-pointer">
          <div>
            <p class="font-medium text-gray-800">账户注销</p>
            <p class="text-sm text-gray-500 text-red-500">注销后所有数据将被删除</p>
          </div>
          <el-button type="danger" link>注销</el-button>
        </div>
      </div>
    </div>

    <!-- Save Button -->
    <div class="flex justify-end">
      <el-button type="primary" size="large" @click="handleSave" class="!px-8 !rounded-xl">
        保存设置
      </el-button>
    </div>

    <!-- Info -->
    <div class="bg-blue-50 rounded-xl p-4 flex items-start gap-3 border border-blue-100">
      <el-icon class="text-blue-500 mt-0.5" :size="18"><InfoFilled /></el-icon>
      <div class="text-sm text-blue-700">
        <p class="font-medium">设置说明</p>
        <p class="opacity-80 mt-1">部分设置可能需要重新登录后生效，如遇问题请联系客服。</p>
      </div>
    </div>
  </div>
</template>
