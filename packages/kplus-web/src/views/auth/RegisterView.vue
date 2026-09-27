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

      <h1 class="auth-title">Create your account</h1>
      <p class="auth-subtitle">两步完成注册，开启交易训练</p>

      <div class="auth-card">
        <!-- 步骤指示器 -->
        <div class="step-indicator">
          <div class="step" :class="{ active: step === 1, done: step > 1 }">
            <span class="step-number">{{ step > 1 ? '✓' : '1' }}</span>
            <span class="step-label">基本信息</span>
          </div>
          <div class="step-line" :class="{ active: step > 1 }"></div>
          <div class="step" :class="{ active: step === 2 }">
            <span class="step-number">2</span>
            <span class="step-label">验证手机</span>
          </div>
        </div>

        <!-- 步骤1: 基本信息 -->
        <el-form v-show="step === 1" ref="step1FormRef" :model="registerForm" :rules="step1Rules" class="auth-form">
          <el-form-item prop="nickname">
            <el-input v-model="registerForm.nickname" placeholder="昵称" size="large" class="term-input">
              <template #prefix>
                <el-icon><User /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="phone">
            <el-input v-model="registerForm.phone" placeholder="手机号" size="large" class="term-input">
              <template #prefix>
                <el-icon><Iphone /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="password">
            <el-input
              v-model="registerForm.password"
              type="password"
              placeholder="设置密码 (至少6位)"
              size="large"
              show-password
              class="term-input"
            >
              <template #prefix>
                <el-icon><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="confirmPassword">
            <el-input
              v-model="registerForm.confirmPassword"
              type="password"
              placeholder="确认密码"
              size="large"
              show-password
              class="term-input"
            >
              <template #prefix>
                <el-icon><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="agreement" class="agreement-item">
            <el-checkbox v-model="registerForm.agreement">
              我已阅读并同意
              <el-link type="primary" :underline="false">《用户协议》</el-link>
              和
              <el-link type="primary" :underline="false">《隐私政策》</el-link>
            </el-checkbox>
          </el-form-item>

          <el-form-item>
            <el-button size="large" class="term-btn" @click="nextStep"> 下一步 </el-button>
          </el-form-item>
        </el-form>

        <!-- 步骤2: 手机验证 -->
        <el-form v-show="step === 2" ref="step2FormRef" :model="registerForm" :rules="step2Rules" class="auth-form">
          <div class="verify-phone-info">
            <p>验证码已发送至</p>
            <p class="phone-number">{{ maskedPhone }}</p>
          </div>

          <el-form-item prop="verifyCode">
            <div class="verify-code-input">
              <el-input v-model="registerForm.verifyCode" placeholder="请输入验证码" size="large" maxlength="6" class="term-input" />
              <el-button :disabled="countdown > 0" class="send-code-btn" @click="sendCode">
                {{ countdown > 0 ? `${countdown}s后重发` : '发送验证码' }}
              </el-button>
            </div>
          </el-form-item>

          <div class="form-actions">
            <el-button size="large" class="back-btn" @click="prevStep">
              <el-icon>
                <ArrowLeft />
              </el-icon>
              返回
            </el-button>
            <el-button size="large" class="term-btn submit-btn" :loading="loading" @click="handleRegister"> 完成注册 </el-button>
          </div>
        </el-form>

        <div class="form-footer">
          <span>已有账户？</span>
          <router-link to="/login" class="login-link">立即登录</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Iphone, ArrowLeft } from '@element-plus/icons-vue'

const router = useRouter()
const step1FormRef = ref(null)
const step2FormRef = ref(null)
const loading = ref(false)
const step = ref(1)
const countdown = ref(0)

const registerForm = reactive({
  nickname: '',
  phone: '',
  password: '',
  confirmPassword: '',
  verifyCode: '',
  agreement: false
})

const maskedPhone = computed(() => {
  if (registerForm.phone.length >= 11) {
    return registerForm.phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2')
  }
  return registerForm.phone
})

const validateConfirmPassword = (_rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const validateAgreement = (_rule, value, callback) => {
  if (!value) {
    callback(new Error('请阅读并同意用户协议'))
  } else {
    callback()
  }
}

const step1Rules = {
  nickname: [
    { required: true, message: '请输入昵称', trigger: 'blur' },
    { min: 2, max: 20, message: '昵称长度为2-20个字符', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请设置密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  agreement: [{ validator: validateAgreement, trigger: 'change' }]
}

const step2Rules = {
  verifyCode: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { len: 6, message: '验证码为6位数字', trigger: 'blur' }
  ]
}

const nextStep = async () => {
  if (!step1FormRef.value) return

  await step1FormRef.value.validate((valid) => {
    if (valid) {
      step.value = 2
      sendCode()
    }
  })
}

const prevStep = () => {
  step.value = 1
}

const sendCode = () => {
  if (countdown.value > 0) return

  countdown.value = 60
  const timer = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      clearInterval(timer)
    }
  }, 1000)

  ElMessage.success('验证码已发送')
}

const handleRegister = async () => {
  if (!step2FormRef.value) return

  await step2FormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true

      // 模拟注册请求
      setTimeout(() => {
        loading.value = false
        ElMessage.success('注册成功，即将跳转到登录页')
        setTimeout(() => {
          router.push('/login')
        }, 1500)
      }, 1500)
    }
  })
}

const handleSocialRegister = (type) => {
  ElMessage.info(`${type === 'wechat' ? '微信' : ''}注册功能开发中...`)
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

/* 步骤指示器 */
.step-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 28px;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.step-number {
  width: 28px;
  height: 28px;
  border-radius: 4px;
  background: transparent;
  border: 1px solid var(--c-line-strong);
  color: var(--c-ink-faint);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  font-weight: 500;
  transition: all 0.2s;
}

.step.active .step-number,
.step.done .step-number {
  border-color: #2962ff;
  background: rgba(41, 98, 255, 0.14);
  color: var(--c-link);
}

.step-label {
  font-size: 12px;
  color: var(--c-ink-faint);
}

.step.active .step-label {
  color: var(--c-link-hover);
}

.step-line {
  width: 64px;
  height: 1px;
  background: var(--c-line);
  margin: 0 16px;
  margin-bottom: 24px;
  transition: all 0.2s;
}

.step-line.active {
  background: rgba(41, 98, 255, 0.5);
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

.auth-form .agreement-item {
  margin-bottom: 18px;
}

.auth-form .agreement-item :deep(.el-checkbox__label) {
  color: var(--c-ink-secondary);
  font-size: 12px;
}

.auth-form .agreement-item :deep(.el-link) {
  font-size: 12px;
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
  letter-spacing: 4px;
  text-indent: 4px;
}

.verify-phone-info {
  text-align: center;
  margin-bottom: 24px;
  color: var(--c-ink-faint);
  font-size: 13px;
}

.verify-phone-info .phone-number {
  font-size: 22px;
  font-weight: 600;
  color: var(--c-ink);
  font-family: 'Roboto Mono', 'JetBrains Mono', 'SF Mono', Consolas, monospace;
  font-variant-numeric: tabular-nums;
  margin-top: 8px;
  letter-spacing: 2px;
}

.verify-code-input {
  display: flex;
  gap: 12px;
  width: 100%;
}

.verify-code-input .el-input {
  flex: 1;
}

.send-code-btn {
  height: 42px;
  border-radius: 4px;
  font-size: 12px;
  background: transparent;
  border: 1px solid var(--c-line-strong);
  color: var(--c-ink-secondary);
  white-space: nowrap;
}

.send-code-btn:hover:not(:disabled) {
  border-color: #2962ff;
  color: var(--c-link-hover);
  background: transparent;
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

.back-btn {
  height: 44px;
  border-radius: 4px;
  font-size: 13px;
  background: transparent;
  border: 1px solid var(--c-line-strong);
  color: var(--c-ink-secondary);
}

.back-btn:hover {
  border-color: var(--c-line-hover);
  color: var(--c-ink);
  background: transparent;
}

.form-actions .submit-btn {
  flex: 2;
  width: auto;
}

.form-footer {
  text-align: center;
  color: var(--c-ink-faint);
  font-size: 13px;
  margin-top: 4px;
}

.login-link {
  color: var(--c-link);
  font-weight: 500;
  text-decoration: none;
  margin-left: 4px;
}

.login-link:hover {
  color: var(--c-link-hover);
}
</style>
