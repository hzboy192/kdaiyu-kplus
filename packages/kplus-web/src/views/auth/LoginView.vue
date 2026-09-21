<template>
  <div class="auth-container">
    <!-- 背景装饰 -->
    <div class="auth-bg">
      <div class="bg-gradient"></div>
      <div class="bg-pattern"></div>
    </div>

    <div class="auth-content">
      <!-- 左侧品牌区域 -->
      <div class="auth-brand">
        <div class="brand-content">
          <div class="logo-wrapper">
            <div class="logo-icon">
              <svg viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="40" height="40" rx="8" fill="url(#logo-gradient)" />
                <path d="M12 28V12h4l6 10 6-10h4v16h-4V18l-6 10-6-10v10h-4z" fill="white" />
                <defs>
                  <linearGradient id="logo-gradient" x1="0" y1="0" x2="40" y2="40">
                    <stop stop-color="#f97316" />
                    <stop offset="1" stop-color="#ef4444" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            <span class="logo-text">口袋鱼</span>
          </div>

          <h1 class="brand-title">专业的K线模拟训练平台</h1>
          <p class="brand-desc">
            通过真实的市场数据，提升您的交易技能。<br />
            支持多品种训练、策略回测、社区交流。
          </p>

          <div class="features-list">
            <div class="feature-item">
              <el-icon class="feature-icon">
                <TrendCharts />
              </el-icon>
              <span>真实K线数据，还原市场走势</span>
            </div>
            <div class="feature-item">
              <el-icon class="feature-icon">
                <DataAnalysis />
              </el-icon>
              <span>智能数据分析，洞察交易习惯</span>
            </div>
            <div class="feature-item">
              <el-icon class="feature-icon">
                <Trophy />
              </el-icon>
              <span>排行榜竞技，与高手同台PK</span>
            </div>
            <div class="feature-item">
              <el-icon class="feature-icon">
                <ChatDotRound />
              </el-icon>
              <span>交流社区，分享策略心得</span>
            </div>
          </div>
        </div>

        <div class="brand-footer">
          <p>已有 <span class="highlight">50,000+</span> 交易者在使用</p>
        </div>
      </div>

      <!-- 右侧登录表单 -->
      <div class="auth-form-wrapper">
        <div class="auth-form-card">
          <div class="form-header">
            <h2 class="form-title">欢迎回来</h2>
            <p class="form-subtitle">请登录您的账户继续训练</p>
          </div>

          <el-form ref="loginFormRef" :model="loginForm" :rules="loginRules" class="auth-form"
            @submit.prevent="handleLogin">
            <!-- 错误提示 -->
            <el-form-item v-if="errorTips">
              <el-alert :title="errorTips" type="error" show-icon :closable="false" />
            </el-form-item>

            <!-- 登录表单（非验证码模式） -->
            <div v-show="!showCaptcha">
              <el-form-item prop="account">
                <el-input v-model="loginForm.account" placeholder="手机号 / 邮箱" size="large" :prefix-icon="User" />
              </el-form-item>

              <el-form-item prop="password">
                <el-input v-model="loginForm.password" type="password" placeholder="密码" size="large" show-password
                  :prefix-icon="Lock" />
              </el-form-item>

              <div class="form-options">
                <el-checkbox v-model="loginForm.remember">7天内自动登录</el-checkbox>
                <el-link type="primary" :underline="false" @click="showForgotPassword">忘记密码？</el-link>
              </div>

              <el-form-item>
                <el-button type="primary" size="large" class="submit-btn" :loading="loading" :disabled="limitRequest"
                  @click="handleLogin">
                  登录
                </el-button>
              </el-form-item>
            </div>

            <!-- 验证码组件（多次登录失败后显示） -->
            <div v-show="showCaptcha">
              <el-form-item>
                <verify ref="verifyRef" v-model="loginForm.code" mode="banner" captcha-type="clickWord"
                  :img-size="{ width: '375px', height: '200px' }" @success="checkSuccess" @ready="initReady" />
              </el-form-item>
            </div>
          </el-form>

          <el-divider>
            <span class="divider-text">或使用以下方式登录</span>
          </el-divider>

          <div class="social-login">
            <el-button class="social-btn wechat" @click="handleSocialLogin('wechat')">
              <svg class="social-icon" viewBox="0 0 24 24" fill="currentColor">
                <path
                  d="M8.691 2.188C3.891 2.188 0 5.476 0 9.53c0 2.212 1.17 4.203 3.002 5.55a.59.59 0 0 1 .213.665l-.39 1.48c-.019.07-.048.141-.048.213 0 .163.13.295.29.295a.326.326 0 0 0 .167-.054l1.903-1.114a.864.864 0 0 1 .717-.098 10.16 10.16 0 0 0 2.837.403c.276 0 .543-.027.811-.05-.857-2.578.157-4.972 1.932-6.446 1.703-1.415 3.882-1.98 5.853-1.838-.576-3.583-4.196-6.348-8.596-6.348zM5.785 5.991c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178A1.17 1.17 0 0 1 4.623 7.17c0-.651.52-1.18 1.162-1.18zm5.813 0c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178 1.17 1.17 0 0 1-1.162-1.178c0-.651.52-1.18 1.162-1.18zm5.34 2.867c-1.797-.052-3.746.512-5.28 1.786-1.72 1.428-2.687 3.72-1.78 6.22.942 2.453 3.666 4.229 6.884 4.229.826 0 1.622-.12 2.361-.336a.722.722 0 0 1 .598.082l1.584.926a.272.272 0 0 0 .14.047c.134 0 .24-.111.24-.247 0-.06-.023-.12-.038-.177l-.327-1.233a.582.582 0 0 1-.023-.156.49.49 0 0 1 .201-.398C23.024 18.48 24 16.82 24 14.98c0-3.21-2.931-5.837-6.656-6.088V8.89c-.135-.01-.269-.03-.407-.03zm-2.53 3.274c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.97-.982zm4.844 0c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.969-.982z" />
              </svg>
              微信登录
            </el-button>
            <el-button class="social-btn" @click="handleSocialLogin('phone')">
              <el-icon>
                <Iphone />
              </el-icon>
              短信登录
            </el-button>
          </div>

          <div class="form-footer">
            <span>还没有账户？</span>
            <router-link to="/register" class="register-link">立即注册</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  User,
  Lock,
  TrendCharts,
  DataAnalysis,
  Trophy,
  ChatDotRound,
  Iphone
} from '@element-plus/icons-vue'
import useUserStore from '@s/user'
import verify from '@c/captcha/Verify.vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const loginFormRef = ref(null)
const verifyRef = ref(null)
const loading = ref(false)
const showCaptcha = ref(false)
const errorTips = ref('')
const retryCount = ref(0)
const limitRequest = ref(false)

const loginForm = reactive({
  account: '',
  password: '',
  remember: false,
  code: '',
  uuid: ''
})

const loginRules = {
  account: [
    { required: true, message: '请输入手机号或邮箱', trigger: 'blur' },
    { min: 2, max: 30, message: '账号长度必须为2~30字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 30, message: '密码长度必须为6~30字符', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return

  loginFormRef.value.validateField('code', (isPass) => {
    if (isPass) {
      submitForm()
    } else {
      showCaptcha.value = true
    }
  })
}

const submitForm = async () => {
  errorTips.value = ''
  loading.value = true

  userStore.login({
    username: loginForm.account,
    password: loginForm.password,
    rememberMe: loginForm.remember,
    code: loginForm.code,
    uuid: loginForm.uuid
  }).then(({ status, data, message }) => {
    loading.value = false
    loginForm.code = ''

    if (status === 200) {
      showCaptcha.value = false
      ElMessage.success('登录成功')
      userStore.getInfo().then(() => {
        if (route.query['redirect_to']) {
          window.location.href = decodeURIComponent(route.query['redirect_to'])
        } else {
          router.replace({ path: '/main/dashboard' })
        }
      })
    } else {
      retryCount.value = data
      errorTips.value = message
      limitRequest.value = status === 400108 || status === 400109
      if (retryCount.value > 2 && status === 400104) {
        showCaptcha.value = true
      } else {
        showCaptcha.value = false
      }
    }
  }).catch(() => {
    loading.value = false
    ElMessage.error('登录请求失败')
  })
}

const checkSuccess = (captchaVerification) => {
  loginForm.code = captchaVerification
  showCaptcha.value = false
  if (verifyRef.value) {
    verifyRef.value.refresh()
  }
  handleLogin()
}

const initReady = (ins) => {
  loginForm.uuid = ins.backToken
}

const handleSocialLogin = (type) => {
  ElMessage.info(`${type === 'wechat' ? '微信' : '短信'}登录功能开发中...`)
}

const showForgotPassword = () => {
  ElMessage.info('找回密码功能开发中...')
}
</script>

<style scoped>
.auth-container {
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.auth-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
}

.bg-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
}

.bg-pattern {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 20% 80%, rgba(79, 70, 229, 0.15) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(124, 58, 237, 0.1) 0%, transparent 50%);
}

.auth-content {
  position: relative;
  z-index: 1;
  display: flex;
  width: 100%;
  max-width: 1200px;
  min-height: 700px;
  margin: 24px;
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}

.auth-brand {
  flex: 1;
  padding: 48px;
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 50%, #a855f7 100%);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  color: white;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 48px;
}

.logo-icon svg {
  width: 40px;
  height: 40px;
}

.logo-text {
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.5px;
}

.brand-title {
  font-size: 36px;
  font-weight: 700;
  line-height: 1.2;
  margin-bottom: 16px;
}

.brand-desc {
  font-size: 16px;
  line-height: 1.8;
  opacity: 0.9;
  margin-bottom: 40px;
}

.features-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 15px;
}

.feature-icon {
  font-size: 20px;
  padding: 8px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 8px;
}

.brand-footer {
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}

.brand-footer p {
  font-size: 14px;
  opacity: 0.9;
}

.brand-footer .highlight {
  font-weight: 700;
  font-size: 18px;
}

.auth-form-wrapper {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px;
  background: #ffffff;
}

.auth-form-card {
  width: 100%;
  max-width: 400px;
}

.form-header {
  text-align: center;
  margin-bottom: 32px;
}

.form-title {
  font-size: 28px;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 8px;
}

.form-subtitle {
  color: #64748b;
  font-size: 15px;
}

.auth-form :deep(.el-input__wrapper) {
  padding: 4px 16px;
  border-radius: 12px;
  box-shadow: 0 0 0 1px #e2e8f0;
  transition: all 0.2s;
}

.auth-form :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #4f46e5;
}

.auth-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.2), 0 0 0 1px #4f46e5;
}

.auth-form :deep(.el-input__inner) {
  height: 44px;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.form-options :deep(.el-checkbox__label) {
  color: #64748b;
  font-size: 14px;
}

.submit-btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 12px;
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
  border: none;
  transition: all 0.3s;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(79, 70, 229, 0.3);
}

:deep(.el-divider__text) {
  background: white;
  padding: 0 16px;
}

.divider-text {
  color: #94a3b8;
  font-size: 13px;
}

.social-login {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
}

.social-btn {
  flex: 1;
  height: 44px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 500;
  border: 1px solid #e2e8f0;
  background: white;
  color: #475569;
  transition: all 0.2s;
}

.social-btn:hover {
  border-color: #4f46e5;
  color: #4f46e5;
}

.social-btn.wechat:hover {
  border-color: #07c160;
  color: #07c160;
}

.social-icon {
  width: 18px;
  height: 18px;
  margin-right: 8px;
}

.form-footer {
  text-align: center;
  color: #64748b;
  font-size: 14px;
}

.register-link {
  color: #4f46e5;
  font-weight: 600;
  text-decoration: none;
  margin-left: 4px;
}

.register-link:hover {
  text-decoration: underline;
}

@media (max-width: 900px) {
  .auth-content {
    flex-direction: column;
    margin: 16px;
    min-height: auto;
  }

  .auth-brand {
    padding: 32px;
  }

  .brand-title {
    font-size: 24px;
  }

  .features-list {
    display: none;
  }

  .auth-form-wrapper {
    padding: 32px;
  }
}
</style>
