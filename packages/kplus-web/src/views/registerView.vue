<template>
  <div class="register-body">
    <el-row class="register-container">
      <el-col :span="4" />
      <el-col :span="8" />
      <el-col :span="8" class="form-container">
        <el-form ref="registerFormRef" class="register-form" :model="regBody" :rules="registerRules" size="large"
          :label-width="0">
          <el-form-item>
            <div class="register-title"><span>注册</span><span>已有帐号？ <el-link type="primary"
                  @click="goToLogin">点此登录</el-link></span></div>
          </el-form-item>
          <el-form-item v-if="errorTips">
            <el-alert :title="errorTips" type="error" show-icon :closable="false" />
          </el-form-item>
          <el-form-item prop="username">
            <el-input v-model="regBody.username" placeholder="请输入用户名" />
          </el-form-item>
          <el-form-item prop="email">
            <el-input v-model="regBody.email" placeholder="请输入邮箱" />
          </el-form-item>
          <el-form-item prop="phone">
            <el-input v-model="regBody.phone" placeholder="请输入手机号" />
          </el-form-item>
          <el-form-item prop="password">
            <el-input v-model="regBody.password" type="password" placeholder="请输入密码" />
          </el-form-item>
          <el-form-item prop="confirmPassword">
            <el-input v-model="regBody.confirmPassword" type="password" placeholder="请确认密码" />
          </el-form-item>
          <el-form-item>
            <el-button :disabled="limitRequest" type="primary" class="register-btn"
              @click="registerHandler(registerFormRef)">
              注册
            </el-button>
          </el-form-item>
        </el-form>
      </el-col>
      <el-col :span="4" />
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()
const registerFormRef = ref(null)

const regBody = reactive({
  username: '',
  email: '',
  phone: '',
  password: '',
  confirmPassword: ''
})

const errorTips = ref('')
const limitRequest = ref(false)

const validatePassword = (rule, value, callback) => {
  if (value !== regBody.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const registerRules = reactive({
  username: [
    { required: true, message: '用户名不能为空!' },
    { min: 2, max: 30, message: '用户名长度必须为2~30字符。' }
  ],
  email: [
    { required: true, message: '邮箱不能为空!' },
    { type: 'email', message: '请输入有效的邮箱地址' }
  ],
  phone: [
    { required: true, message: '手机号不能为空!' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入有效的手机号' }
  ],
  password: [
    { required: true, message: '密码不能为空!' },
    { min: 6, max: 30, message: '密码长度必须为6~30字符。' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码!' },
    { validator: validatePassword, trigger: 'blur' }
  ]
})

const registerHandler = () => {
  registerFormRef.value.validate((valid) => {
    if (valid) {
      // 模拟注册请求
      limitRequest.value = true
      setTimeout(() => {
        limitRequest.value = false
        ElMessage.success('注册成功！')
        router.push({ name: 'login' })
      }, 1000)
    } else {
      ElMessage.error('请填写正确的注册信息')
    }
  })
}

const goToLogin = () => {
  router.push({ name: 'login' })
}
</script>

<style scoped>
/* 样式部分无需修改，保持原样 */
.register-body {
  width: 100%;
  height: 100%;
  background: url('/image/fina-login-bg.jpg') no-repeat center center;
  background-size: cover;
}

.register-container {
  margin-top: 60px;
  height: 580px;
}

.form-container {
  min-width: 500px;
  width: 500px;
  height: 580px;
  padding: 50px 70px;
  background-color: #ffffff;
  box-sizing: border-box;
  -webkit-box-shadow: 0px 20px 80px 0px rgba(0, 0, 0, 0.3);
  box-shadow: 0px 20px 80px 0px rgba(0, 0, 0, 0.3);
}

.register-form {
  width: 100%;
  padding-bottom: 10px;

  .register-title {
    width: 100%;
    display: flex;
    justify-content: space-between;

    span:nth-child(1) {
      font-weight: bold;
      font-size: 24px;
    }
  }

  .register-btn {
    width: 100%;
  }
}
</style>