<template>
  <div class="login-body">
    <el-row class="login-container">
      <el-col :span="4" />
      <el-col :span="8" />
      <el-col :span="8" class="form-container">
        <el-form ref="loginFormRef" class="login-form" :model="loginData" :rules="loginRules" size="large" :label-width="0">
          <el-form-item>
            <div class="login-title"><span>登录</span><span>没有帐号？ 点此注册</span></div>
          </el-form-item>
          <div v-show="!showCaptcha">
            <el-form-item v-if="errorTips">
              <el-alert :title="errorTips" type="error" show-icon :closable="false" />
            </el-form-item>
            <el-form-item prop="username">
              <el-input v-model="loginData.username" placeholder="账号/手机号/邮箱" />
            </el-form-item>
            <el-form-item prop="password">
              <el-input v-model="loginData.password" type="password" placeholder="请输入密码" />
            </el-form-item>
            <el-form-item prop="rememberMe">
              <el-checkbox v-model="loginData.rememberMe" :checked="true">记住我</el-checkbox>
            </el-form-item>
            <el-form-item>
              <el-button :disabled="limitRequest" type="warning" class="login-btn" @click="loginHandler(loginFormRef)"> 登录 </el-button>
            </el-form-item>
          </div>
          <div v-show="showCaptcha">
            <el-form-item prop="code" :validate-event="false">
              <verify
                ref="verifyRef"
                v-model="loginData.code"
                mode="banner"
                captcha-type="clickWord"
                :img-size="{ width: '375px', height: '200px' }"
                @success="checkSuccess"
                @ready="initReady"
              />
            </el-form-item>
          </div>
          <el-form-item justify="center">
            <el-text class="forget-pass">已有帐号，忘记密码？</el-text>
          </el-form-item>
          <el-form-item><el-divider>其他登录方式</el-divider></el-form-item>
          <el-form-item>建设中...</el-form-item>
        </el-form>
      </el-col>
      <el-col :span="4" />
    </el-row>
  </div>
</template>

<script setup>
import { useRouter, useRoute } from 'vue-router'
import useUserStore from '@s/user'
import verify from '@c/captcha/Verify.vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const loginFormRef = ref(null)
const verifyRef = ref(null)

const showCaptcha = ref(false)

// 程序实现验证码参考：https://gitee.com/yudaocode/captcha-plus#1maven
// 集成阿里云、腾讯云等三方验证验证码
let loginData = reactive({
  username: '',
  password: '',
  rememberMe: false,
  code: '',
  uuid: ''
})

let errorTips = ref('')
let retryCount = ref(0)
let limitRequest = ref(false)

let captchaValid = function (rule, value, callback) {
  if (value === '' && retryCount.value >= 2) {
    callback(new Error())
  } else {
    callback()
  }
}

let loginRules = reactive({
  username: [
    { required: true, message: '用户名不能为空!' },
    { min: 2, max: 30, message: '用户名长必须为6~30字符。' }
  ],
  password: [
    { required: true, message: '密码不能为空!' },
    { min: 6, max: 30, message: '密码长必须为6~30字符。' }
  ],
  code: [{ validator: captchaValid, trigger: 'change' }]
})

let loginHandler = function () {
  loginFormRef.value.validateField('code', (isPass) => {
    if (isPass) {
      submitForm()
    } else {
      showCaptcha.value = true
    }
  })
}

let submitForm = async function () {
  errorTips.value = ''
  userStore.login(loginData).then(({ status, data, message }) => {
    // 验证码用完一次即失效
    loginData.code = ''
    if (status === 200) {
      showCaptcha.value = false
      userStore.getInfo().then(() => {
        if (route.query['redirect_to']) {
          window.location.href = decodeURIComponent(route.query['redirect_to'])
        } else {
          router.replace({ path: '/' })
        }
      })
    } else {
      retryCount.value = data
      errorTips.value = message
      // loading.value = false
      limitRequest.value = status === 400108 || status === 400109
      if (captchaEnabled.value && retryCount.value > 2 && status == 400104) {
        showCaptcha.value = true
      } else {
        showCaptcha.value = false
      }
    }
  })
}
// 验证码成功
let checkSuccess = function (captchaVerification) {
  loginData.code = captchaVerification
  showCaptcha.value = false
  verifyRef.value.refresh()
  loginHandler()
}

let initReady = function (ins) {
  loginData.uuid = ins.backToken
}
</script>

<style scoped>
.login-body {
  width: 100%;
  height: 100%;
  background: url('/image/fina-login-bg.jpg') no-repeat center center;
  background-size: cover;
}
.login-container {
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

.login-form {
  width: 100%;
  padding-bottom: 10px;
  .login-title {
    width: 100%;
    display: flex;
    justify-content: space-between;

    span:nth-child(1) {
      font-weight: bold;
      font-size: 24px;
    }
  }

  .login-btn {
    width: 100%;
  }
}

.forget-pass {
  width: 100%;
  height: 38px;
  font-size: 14px;
  display: flex;
  justify-content: center;
}
</style>
