<template>
  <div class="auth-container">
    <!-- 抽象 K 线光影背景 -->
    <div class="auth-bg" aria-hidden="true">
      <svg class="kline-glow kline-glow-a" viewBox="0 0 1200 800" preserveAspectRatio="none">
        <g fill="none" stroke="var(--c-line)" stroke-width="1.5">
          <path d="M0 620 L140 560 L260 590 L420 480 L560 510 L700 420 L860 450 L1010 350 L1200 380" />
          <path d="M0 700 L160 660 L320 690 L480 610 L640 640 L800 570 L960 600 L1200 520" opacity="0.6" />
        </g>
        <g fill="var(--c-line)">
          <rect x="180" y="420" width="7" height="70" rx="1" />
          <rect x="186" y="440" width="7" height="50" rx="1" />
          <rect x="420" y="360" width="7" height="64" rx="1" />
          <rect x="426" y="380" width="7" height="44" rx="1" />
          <rect x="660" y="310" width="7" height="58" rx="1" />
          <rect x="666" y="328" width="7" height="40" rx="1" />
          <rect x="920" y="250" width="7" height="52" rx="1" />
          <rect x="926" y="266" width="7" height="36" rx="1" />
        </g>
      </svg>
      <svg class="kline-glow kline-glow-b" viewBox="0 0 1200 800" preserveAspectRatio="none">
        <path
          d="M0 300 L120 340 L260 300 L400 380 L540 340 L680 420 L840 370 L1000 450 L1200 400"
          fill="none"
          stroke="rgba(41,98,255,0.12)"
          stroke-width="1.5"
        />
      </svg>
      <div class="bg-vignette"></div>
    </div>

    <div class="auth-content">
      <!-- 品牌 -->
      <div class="brand">
        <div class="logo-mark">
          <svg viewBox="0 0 24 24" fill="currentColor">
            <path
              d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"
            />
          </svg>
        </div>
        <span class="brand-name">口袋鱼</span>
        <span class="brand-divider"></span>
        <span class="brand-sub">K线训练终端</span>
      </div>

      <h1 class="auth-title">Log in to your terminal</h1>
      <p class="auth-subtitle">使用真实市场数据，训练你的交易直觉</p>

      <div class="auth-card">
        <el-form ref="loginFormRef" :model="loginForm" :rules="loginRules" class="auth-form" @submit.prevent="handleLogin">
          <!-- 错误提示 -->
          <el-form-item v-if="errorTips">
            <el-alert :title="errorTips" type="error" show-icon :closable="false" />
          </el-form-item>

          <!-- 登录表单（非验证码模式） -->
          <div v-show="!showCaptcha">
            <el-form-item prop="account">
              <el-input v-model="loginForm.account" placeholder="手机号 / 邮箱" size="large" class="term-input">
                <template #prefix>
                  <el-icon><User /></el-icon>
                </template>
              </el-input>
            </el-form-item>

            <el-form-item prop="password">
              <el-input v-model="loginForm.password" type="password" placeholder="密码" size="large" show-password class="term-input">
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </el-form-item>

            <div class="form-options">
              <el-checkbox v-model="loginForm.remember">7天内自动登录</el-checkbox>
              <el-link type="primary" :underline="false" @click="showForgotPassword">忘记密码？</el-link>
            </div>

            <el-form-item>
              <el-button size="large" class="term-btn" :loading="loading" :disabled="limitRequest" @click="handleLogin"> 登录 </el-button>
            </el-form-item>
          </div>

          <!-- 验证码组件（多次登录失败后显示） -->
          <div v-show="showCaptcha">
            <el-form-item>
              <verify
                ref="verifyRef"
                v-model="loginForm.code"
                mode="banner"
                captcha-type="clickWord"
                :img-size="{ width: '375px', height: '200px' }"
                @success="checkSuccess"
                @ready="initReady"
              />
            </el-form-item>
          </div>
        </el-form>

        <div class="auth-divider">
          <span class="divider-line"></span>
          <span class="divider-text">或</span>
          <span class="divider-line"></span>
        </div>

        <div class="social-login">
          <button class="social-btn" type="button" @click="handleSocialLogin('wechat')">
            <svg class="social-icon" viewBox="0 0 24 24" fill="currentColor">
              <path
                d="M8.691 2.188C3.891 2.188 0 5.476 0 9.53c0 2.212 1.17 4.203 3.002 5.55a.59.59 0 0 1 .213.665l-.39 1.48c-.019.07-.048.141-.048.213 0 .163.13.295.29.295a.326.326 0 0 0 .167-.054l1.903-1.114a.864.864 0 0 1 .717-.098 10.16 10.16 0 0 0 2.837.403c.276 0 .543-.027.811-.05-.857-2.578.157-4.972 1.932-6.446 1.703-1.415 3.882-1.98 5.853-1.838-.576-3.583-4.196-6.348-8.596-6.348zM5.785 5.991c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178A1.17 1.17 0 0 1 4.623 7.17c0-.651.52-1.18 1.162-1.18zm5.813 0c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178 1.17 1.17 0 0 1-1.162-1.178c0-.651.52-1.18 1.162-1.18zm5.34 2.867c-1.797-.052-3.746.512-5.28 1.786-1.72 1.428-2.687 3.72-1.78 6.22.942 2.453 3.666 4.229 6.884 4.229.826 0 1.622-.12 2.361-.336a.722.722 0 0 1 .598.082l1.584.926a.272.272 0 0 0 .14.047c.134 0 .24-.111.24-.247 0-.06-.023-.12-.038-.177l-.327-1.233a.582.582 0 0 1-.023-.156.49.49 0 0 1 .201-.398C23.024 18.48 24 16.82 24 14.98c0-3.21-2.931-5.837-6.656-6.088V8.89c-.135-.01-.269-.03-.407-.03zm-2.53 3.274c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.97-.982zm4.844 0c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.969-.982z"
              />
            </svg>
            微信登录
          </button>
          <button class="social-btn" type="button" @click="handleSocialLogin('phone')">
            <el-icon class="social-icon"><Iphone /></el-icon>
            短信登录
          </button>
        </div>

        <div class="form-footer">
          <span>还没有账户？</span>
          <router-link to="/register" class="register-link">立即注册</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Iphone } from '@element-plus/icons-vue'
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

  userStore
    .login({
      username: loginForm.account,
      password: loginForm.password,
      rememberMe: loginForm.remember,
      code: loginForm.code,
      uuid: loginForm.uuid
    })
    .then(({ status, data, message }) => {
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
    })
    .catch(() => {
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
  background: var(--app-bg);
}

.auth-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

.kline-glow {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  animation: drift 26s ease-in-out infinite alternate;
}

.kline-glow-b {
  animation-duration: 34s;
  animation-direction: alternate-reverse;
}

@keyframes drift {
  from {
    transform: translateX(-24px);
  }
  to {
    transform: translateX(24px);
  }
}

.bg-vignette {
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse 60% 40% at 50% 0%, rgba(41, 98, 255, 0.07) 0%, transparent 70%),
    linear-gradient(180deg, var(--app-bg) 0%, transparent 30%, transparent 70%, var(--app-bg) 100%);
}

.auth-content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 380px;
  margin: 40px 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 40px;
}

.logo-mark {
  width: 34px;
  height: 34px;
  border-radius: 4px;
  background: rgba(41, 98, 255, 0.14);
  border: 1px solid rgba(41, 98, 255, 0.35);
  color: var(--c-link);
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-mark svg {
  width: 20px;
  height: 20px;
}

.brand-name {
  font-size: 17px;
  font-weight: 600;
  color: var(--c-ink);
  letter-spacing: 1px;
}

.brand-divider {
  width: 1px;
  height: 14px;
  background: var(--c-line-strong);
}

.brand-sub {
  font-size: 12px;
  color: var(--c-ink-faint);
  letter-spacing: 2px;
}

.auth-title {
  font-size: 22px;
  font-weight: 600;
  color: var(--c-ink);
  letter-spacing: 0.5px;
  margin-bottom: 10px;
}

.auth-subtitle {
  font-size: 13px;
  color: var(--c-ink-faint);
  margin-bottom: 32px;
}

.auth-card {
  width: 100%;
  background: var(--c-panel);
  border: 1px solid var(--c-line);
  border-radius: 6px;
  padding: 32px 28px 24px;
  backdrop-filter: blur(8px);
}

.auth-form :deep(.el-form-item) {
  margin-bottom: 22px;
}

/* 下划线式输入框 */
.auth-form :deep(.term-input .el-input__wrapper) {
  background: transparent;
  box-shadow: none;
  border-radius: 0;
  border-bottom: 1px solid var(--c-line-strong);
  padding: 1px 4px;
  transition: border-color 0.2s;
}

.auth-form :deep(.term-input .el-input__wrapper:hover) {
  border-bottom-color: var(--c-line-hover);
}

.auth-form :deep(.term-input .el-input__wrapper.is-focus) {
  box-shadow: none;
  border-bottom-color: #2962ff;
}

.auth-form :deep(.term-input .el-input__inner) {
  height: 42px;
  color: var(--c-ink);
  font-size: 14px;
}

.auth-form :deep(.term-input .el-input__inner::placeholder) {
  color: var(--c-ink-faint);
}

.auth-form :deep(.term-input .el-input__prefix) {
  color: var(--c-ink-faint);
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 22px;
}

.form-options :deep(.el-checkbox__label) {
  color: var(--c-ink-secondary);
  font-size: 13px;
}

.form-options :deep(.el-link) {
  font-size: 13px;
}

/* 幽灵按钮：描边，悬浮填充 */
.auth-form .term-btn {
  --el-button-bg-color: transparent;
  --el-button-border-color: #2962ff;
  --el-button-text-color: var(--c-link);
  --el-button-hover-bg-color: #2962ff;
  --el-button-hover-border-color: #2962ff;
  --el-button-hover-text-color: #ffffff;
  --el-button-active-bg-color: #1f4fd6;
  --el-button-active-border-color: #1f4fd6;
  width: 100%;
  height: 44px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 6px;
  text-indent: 6px;
}

.auth-divider {
  display: flex;
  align-items: center;
  gap: 12px;
  margin: 20px 0;
}

.divider-line {
  flex: 1;
  height: 1px;
  background: var(--c-line);
}

.divider-text {
  font-size: 12px;
  color: var(--c-ink-faint);
}

.social-login {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.social-btn {
  flex: 1;
  height: 38px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  border-radius: 4px;
  font-size: 13px;
  color: var(--c-ink-secondary);
  background: transparent;
  border: 1px solid var(--c-line-strong);
  cursor: pointer;
  transition: all 0.2s;
}

.social-btn:hover {
  border-color: #2962ff;
  color: var(--c-link-hover);
}

.social-icon {
  width: 16px;
  height: 16px;
  font-size: 16px;
}

.form-footer {
  text-align: center;
  color: var(--c-ink-faint);
  font-size: 13px;
}

.register-link {
  color: var(--c-link);
  font-weight: 500;
  text-decoration: none;
  margin-left: 4px;
}

.register-link:hover {
  color: var(--c-link-hover);
}
</style>
