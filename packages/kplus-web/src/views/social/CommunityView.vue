<script setup>
import { ref } from 'vue'
import { ElButton, ElAvatar, ElTag, ElTabs, ElTabPane, ElIcon, ElInput, ElDialog } from 'element-plus'
import { Plus, ChatLineRound, View, Star, Clock, User } from '@element-plus/icons-vue'

const activeTab = ref('hot')
const showPostDialog = ref(false)
const newPost = ref({
  title: '',
  content: '',
  category: 'strategy'
})

const posts = ref([
  {
    id: 1,
    title: '分享一个最近胜率很高的突破策略，回测数据附上',
    content: '最近研究了量价突破的组合策略，在震荡行情中表现不错，月胜率达到了72%...',
    author: '交易小王子',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=2',
    time: '2小时前',
    views: 1256,
    comments: 45,
    likes: 128,
    tags: ['策略分享', '突破'],
    isHot: true
  },
  {
    id: 2,
    title: '新手求助：如何判断假突破和真突破？',
    content: '刚开始学习交易，经常遇到假突破被套，有没有大佬分享一下经验...',
    author: '学习中',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=10',
    time: '5小时前',
    views: 856,
    comments: 32,
    likes: 56,
    tags: ['新手问答', '技术分析'],
    isHot: false
  },
  {
    id: 3,
    title: '今日复盘：创业板放量上涨的思考',
    content: '今天创业板放量上涨2.5%，从技术面和资金面两个角度来分析...',
    author: '价值投资者',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=5',
    time: '8小时前',
    views: 2341,
    comments: 89,
    likes: 234,
    tags: ['每日复盘', '创业板'],
    isHot: true
  },
  {
    id: 4,
    title: '量化策略分享：基于均线的自动交易系统',
    content: '花了三个月时间开发的量化系统，使用双均线交叉策略，配合成交量过滤...',
    author: '量化操盘手',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=3',
    time: '1天前',
    views: 3456,
    comments: 156,
    likes: 423,
    tags: ['量化', '策略编辑器'],
    isHot: true
  }
])

const categories = [
  { label: '热门', value: 'hot', icon: Star },
  { label: '策略分享', value: 'strategy', icon: ChatLineRound },
  { label: '新手问答', value: 'qa', icon: User },
  { label: '每日复盘', value: 'review', icon: Clock }
]
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-bold text-gray-800">交流社区</h2>
        <p class="text-gray-500 text-sm mt-1">策略分享、心得交流、问答互动</p>
      </div>
      <el-button type="primary" @click="showPostDialog = true" class="!rounded-xl">
        <el-icon class="mr-1"><Plus /></el-icon>
        发布帖子
      </el-button>
    </div>

    <!-- Categories -->
    <div class="flex gap-2 overflow-x-auto pb-2">
      <button
        v-for="cat in categories"
        :key="cat.value"
        @click="activeTab = cat.value"
        class="flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-medium whitespace-nowrap transition-all"
        :class="activeTab === cat.value 
          ? 'bg-primary-600 text-white shadow-md shadow-primary-500/30' 
          : 'bg-white text-gray-600 border border-gray-200 hover:border-primary-300 hover:text-primary-600'"
      >
        <el-icon :size="16"><component :is="cat.icon" /></el-icon>
        {{ cat.label }}
      </button>
    </div>

    <!-- Posts List -->
    <div class="space-y-4">
      <div
        v-for="post in posts"
        :key="post.id"
        class="bg-white rounded-2xl p-5 border border-gray-100 hover:shadow-md hover:border-gray-200 transition-all cursor-pointer"
      >
        <div class="flex gap-4">
          <el-avatar :src="post.avatar" :size="48" class="flex-shrink-0" />
          <div class="flex-1 min-w-0">
            <div class="flex items-start gap-2 mb-2">
              <h3 class="font-semibold text-gray-800 hover:text-primary-600 transition-colors line-clamp-1">
                {{ post.title }}
              </h3>
              <el-tag v-if="post.isHot" type="danger" size="small" effect="light" class="flex-shrink-0">
                热门
              </el-tag>
            </div>
            <p class="text-sm text-gray-500 line-clamp-2 mb-3">{{ post.content }}</p>
            <div class="flex flex-wrap gap-2 mb-3">
              <el-tag 
                v-for="tag in post.tags" 
                :key="tag"
                size="small"
                type="info"
                effect="plain"
              >
                {{ tag }}
              </el-tag>
            </div>
            <div class="flex items-center gap-4 text-xs text-gray-400">
              <span class="flex items-center gap-1">
                <el-icon><User /></el-icon>
                {{ post.author }}
              </span>
              <span class="flex items-center gap-1">
                <el-icon><Clock /></el-icon>
                {{ post.time }}
              </span>
              <span class="flex items-center gap-1">
                <el-icon><View /></el-icon>
                {{ post.views }}
              </span>
              <span class="flex items-center gap-1">
                <el-icon><ChatLineRound /></el-icon>
                {{ post.comments }}
              </span>
              <span class="flex items-center gap-1">
                <el-icon><Star /></el-icon>
                {{ post.likes }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Load More -->
    <div class="text-center">
      <el-button type="primary" link>加载更多</el-button>
    </div>

    <!-- Create Post Dialog -->
    <el-dialog
      v-model="showPostDialog"
      title="发布帖子"
      width="600"
      :close-on-click-modal="false"
    >
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">帖子分类</label>
          <div class="flex gap-2">
            <button
              v-for="cat in categories.slice(1)"
              :key="cat.value"
              @click="newPost.category = cat.value"
              class="px-3 py-1.5 rounded-lg text-sm border transition-all"
              :class="newPost.category === cat.value 
                ? 'bg-primary-50 border-primary-500 text-primary-600' 
                : 'border-gray-200 text-gray-600 hover:border-gray-300'"
            >
              {{ cat.label }}
            </button>
          </div>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">标题</label>
          <el-input v-model="newPost.title" placeholder="请输入标题" maxlength="50" show-word-limit />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">内容</label>
          <el-input
            v-model="newPost.content"
            type="textarea"
            :rows="6"
            placeholder="分享你的策略、心得或问题..."
            maxlength="2000"
            show-word-limit
          />
        </div>
      </div>
      <template #footer>
        <el-button @click="showPostDialog = false">取消</el-button>
        <el-button type="primary" @click="showPostDialog = false">发布</el-button>
      </template>
    </el-dialog>
  </div>
</template>
