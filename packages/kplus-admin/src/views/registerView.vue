<template>
  <div class="register-body">
    <el-row class="register-container">
      <el-col :span="4" />
      <el-col :span="8" />
      <el-col :span="8" class="form-container">
        <el-form ref="registerFormRef" class="register-form" :model="registerData" :rules="registerRules" size="large" :label-width="0">
          <el-form-item>
            <div class="register-title"><span>注册</span><span>已有帐号？ 点此登录</span></div>
          </el-form-item>
          <el-form-item prop="username">
            <el-input v-model="registerData.username" placeholder="账号/手机号/邮箱" />
          </el-form-item>
          <el-form-item prop="password">
            <el-input v-model="registerData.password" type="password" placeholder="请输入密码" />
          </el-form-item>
          <el-form-item prop="confirmPassword">
            <el-input v-model="registerData.confirmPassword" type="password" placeholder="请确认密码" />
          </el-form-item>
          <el-form-item>
            <el-button type="warning" class="register-btn" @click="registerHandler(registerFormRef)">注册</el-button>
          </el-form-item>
        </el-form>
      </el-col>
      <el-col :span="4" />
    </el-row>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import useUserStore from '@s/user'

const router = useRouter()
const userStore = useUserStore()

const registerFormRef = ref(null)

let registerData = reactive({
  username: '',
  password: '',
  confirmPassword: ''
})

let registerRules = reactive({
  username: [
    { required: true, message: '用户名不能为空!' },
    { min: 6, max: 30, message: '用户名长必须为6~30字符。' }
  ],
  password: [
    { required: true, message: '密码不能为空!' },
    { min: 6, max: 30, message: '密码长必须为6~30字符。' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码!' },
    { validator: (rule, value, callback) => {
      if (value !== registerData.password) {
        callback(new Error('两次输入的密码不一致!'))
      } else {
        callback()
      }
    }, trigger: 'blur' }
  ]
})

let registerHandler = function () {
  registerFormRef.value.validate((valid) => {
    if (valid) {
      userStore.register(registerData).then(({ status }) => {
        if (status === 200) {
          router.replace({ path: '/login' })
        }
      })
    }
  })
}
</script>

<style scoped>
.register-body {
  width: 100%;
  height: 100%;
  background: url('/image/fina-register-bg.jpg') no-repeat center center;
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
