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
                    <stop stop-color="#10B981" />
                    <stop offset="1" stop-color="#059669" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            <span class="logo-text">MockTrader</span>
          </div>

          <h1 class="brand-title">开启您的交易训练之旅</h1>
          <p class="brand-desc">
            注册成为会员，享受专业的交易训练体验。<br />
            免费账户即可体验核心功能。
          </p>

          <div class="benefits-list">
            <div class="benefit-item">
              <div class="benefit-icon">
                <el-icon>
                  <Check />
                </el-icon>
              </div>
              <div class="benefit-text">
                <h4>免费账户福利</h4>
                <p>每日3次训练机会，基础数据统计</p>
              </div>
            </div>
            <div class="benefit-item">
              <div class="benefit-icon pro">
                <el-icon>
                  <Star />
                </el-icon>
              </div>
              <div class="benefit-text">
                <h4>专业版特权</h4>
                <p>无限训练、历史回测、高级分析</p>
              </div>
            </div>
            <div class="benefit-item">
              <div class="benefit-icon master">
                <el-icon>
                  <Trophy />
                </el-icon>
              </div>
              <div class="benefit-text">
                <h4>大师版专属</h4>
                <p>策略编辑、API接入、1对1指导</p>
              </div>
            </div>
          </div>
        </div>

        <div class="brand-footer">
          <div class="trust-badges">
            <div class="trust-item">
              <span class="trust-value">50K+</span>
              <span class="trust-label">注册用户</span>
            </div>
            <div class="trust-divider"></div>
            <div class="trust-item">
              <span class="trust-value">1M+</span>
              <span class="trust-label">训练次数</span>
            </div>
            <div class="trust-divider"></div>
            <div class="trust-item">
              <span class="trust-value">99.9%</span>
              <span class="trust-label">数据准确率</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧注册表单 -->
      <div class="auth-form-wrapper">
        <div class="auth-form-card">
          <div class="form-header">
            <h2 class="form-title">创建账户</h2>
            <p class="form-subtitle">填写以下信息完成注册</p>
          </div>

          <!-- 步骤指示器 -->
          <div class="step-indicator">
            <div class="step" :class="{ active: step >= 1, done: step > 1 }">
              <span class="step-number">{{ step > 1 ? '✓' : '1' }}</span>
              <span class="step-label">基本信息</span>
            </div>
            <div class="step-line" :class="{ active: step > 1 }"></div>
            <div class="step" :class="{ active: step >= 2 }">
              <span class="step-number">2</span>
              <span class="step-label">验证手机</span>
            </div>
          </div>

          <!-- 步骤1: 基本信息 -->
          <el-form v-show="step === 1" ref="step1FormRef" :model="registerForm" :rules="step1Rules" class="auth-form">
            <el-form-item prop="nickname">
              <el-input v-model="registerForm.nickname" placeholder="昵称" size="large" :prefix-icon="User" />
            </el-form-item>

            <el-form-item prop="phone">
              <el-input v-model="registerForm.phone" placeholder="手机号" size="large" :prefix-icon="Iphone" />
            </el-form-item>

            <el-form-item prop="password">
              <el-input v-model="registerForm.password" type="password" placeholder="设置密码 (至少6位)" size="large"
                show-password :prefix-icon="Lock" />
            </el-form-item>

            <el-form-item prop="confirmPassword">
              <el-input v-model="registerForm.confirmPassword" type="password" placeholder="确认密码" size="large"
                show-password :prefix-icon="Lock" />
            </el-form-item>

            <el-form-item prop="agreement">
              <el-checkbox v-model="registerForm.agreement">
                我已阅读并同意
                <el-link type="primary" :underline="false">《用户协议》</el-link>
                和
                <el-link type="primary" :underline="false">《隐私政策》</el-link>
              </el-checkbox>
            </el-form-item>

            <el-form-item>
              <el-button type="primary" size="large" class="submit-btn" @click="nextStep">
                下一步
              </el-button>
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
                <el-input v-model="registerForm.verifyCode" placeholder="请输入验证码" size="large" maxlength="6" />
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
                返回上一步
              </el-button>
              <el-button type="primary" size="large" class="submit-btn" :loading="loading" @click="handleRegister">
                完成注册
              </el-button>
            </div>
          </el-form>

          <el-divider v-if="step === 1">
            <span class="divider-text">或使用以下方式注册</span>
          </el-divider>

          <div v-if="step === 1" class="social-login">
            <el-button class="social-btn wechat" @click="handleSocialRegister('wechat')">
              <svg class="social-icon" viewBox="0 0 24 24" fill="currentColor">
                <path
                  d="M8.691 2.188C3.891 2.188 0 5.476 0 9.53c0 2.212 1.17 4.203 3.002 5.55a.59.59 0 0 1 .213.665l-.39 1.48c-.019.07-.048.141-.048.213 0 .163.13.295.29.295a.326.326 0 0 0 .167-.054l1.903-1.114a.864.864 0 0 1 .717-.098 10.16 10.16 0 0 0 2.837.403c.276 0 .543-.027.811-.05-.857-2.578.157-4.972 1.932-6.446 1.703-1.415 3.882-1.98 5.853-1.838-.576-3.583-4.196-6.348-8.596-6.348zM5.785 5.991c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178A1.17 1.17 0 0 1 4.623 7.17c0-.651.52-1.18 1.162-1.18zm5.813 0c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178 1.17 1.17 0 0 1-1.162-1.178c0-.651.52-1.18 1.162-1.18zm5.34 2.867c-1.797-.052-3.746.512-5.28 1.786-1.72 1.428-2.687 3.72-1.78 6.22.942 2.453 3.666 4.229 6.884 4.229.826 0 1.622-.12 2.361-.336a.722.722 0 0 1 .598.082l1.584.926a.272.272 0 0 0 .14.047c.134 0 .24-.111.24-.247 0-.06-.023-.12-.038-.177l-.327-1.233a.582.582 0 0 1-.023-.156.49.49 0 0 1 .201-.398C23.024 18.48 24 16.82 24 14.98c0-3.21-2.931-5.837-6.656-6.088V8.89c-.135-.01-.269-.03-.407-.03zm-2.53 3.274c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.97-.982zm4.844 0c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.969-.982z" />
              </svg>
              微信注册
            </el-button>
          </div>

          <div class="form-footer">
            <span>已有账户？</span>
            <router-link to="/login" class="login-link">立即登录</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  User,
  Lock,
  Iphone,
  Check,
  Star,
  Trophy,
  ArrowLeft
} from '@element-plus/icons-vue'
// Element Plus types removed for JS

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
  agreement: [
    { validator: validateAgreement, trigger: 'change' }
  ]
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
    radial-gradient(circle at 20% 80%, rgba(16, 185, 129, 0.15) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(59, 130, 246, 0.1) 0%, transparent 50%);
}

.auth-content {
  position: relative;
  z-index: 1;
  display: flex;
  width: 100%;
  max-width: 1200px;
  min-height: 750px;
  margin: 24px;
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}

.auth-brand {
  flex: 1;
  padding: 48px;
  background: linear-gradient(135deg, #059669 0%, #10b981 50%, #34d399 100%);
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
  font-size: 32px;
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

.benefits-list {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.benefit-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
}

.benefit-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  flex-shrink: 0;
}

.benefit-icon.pro {
  background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
}

.benefit-icon.master {
  background: linear-gradient(135deg, #8b5cf6 0%, #a78bfa 100%);
}

.benefit-text h4 {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
}

.benefit-text p {
  font-size: 14px;
  opacity: 0.8;
}

.brand-footer {
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}

.trust-badges {
  display: flex;
  align-items: center;
  gap: 24px;
}

.trust-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.trust-value {
  font-size: 24px;
  font-weight: 700;
}

.trust-label {
  font-size: 13px;
  opacity: 0.8;
}

.trust-divider {
  width: 1px;
  height: 40px;
  background: rgba(255, 255, 255, 0.2);
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
  margin-bottom: 24px;
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

.step-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 32px;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.step-number {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #e2e8f0;
  color: #64748b;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s;
}

.step.active .step-number {
  background: #10b981;
  color: white;
}

.step.done .step-number {
  background: #10b981;
  color: white;
}

.step-label {
  font-size: 13px;
  color: #94a3b8;
}

.step.active .step-label {
  color: #10b981;
  font-weight: 500;
}

.step-line {
  width: 80px;
  height: 2px;
  background: #e2e8f0;
  margin: 0 16px;
  margin-bottom: 24px;
  transition: all 0.3s;
}

.step-line.active {
  background: #10b981;
}

.auth-form :deep(.el-input__wrapper) {
  padding: 4px 16px;
  border-radius: 12px;
  box-shadow: 0 0 0 1px #e2e8f0;
  transition: all 0.2s;
}

.auth-form :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #10b981;
}

.auth-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2), 0 0 0 1px #10b981;
}

.auth-form :deep(.el-input__inner) {
  height: 44px;
}

.verify-phone-info {
  text-align: center;
  margin-bottom: 24px;
  color: #64748b;
}

.verify-phone-info .phone-number {
  font-size: 20px;
  font-weight: 600;
  color: #1e293b;
  margin-top: 8px;
}

.verify-code-input {
  display: flex;
  gap: 12px;
}

.verify-code-input .el-input {
  flex: 1;
}

.send-code-btn {
  width: 120px;
  height: 52px;
  border-radius: 12px;
  font-size: 14px;
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

.back-btn {
  flex: 1;
  height: 48px;
  border-radius: 12px;
  font-size: 14px;
}

.submit-btn {
  flex: 2;
  height: 48px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 12px;
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  border: none;
  transition: all 0.3s;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3);
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
  border-color: #10b981;
  color: #10b981;
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

.login-link {
  color: #10b981;
  font-weight: 600;
  text-decoration: none;
  margin-left: 4px;
}

.login-link:hover {
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

  .benefits-list {
    display: none;
  }

  .trust-badges {
    justify-content: center;
  }

  .auth-form-wrapper {
    padding: 32px;
  }
}
</style>
