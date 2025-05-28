<script setup>
import { ref, reactive, onMounted } from 'vue'
import { Edit, Key, Phone, Message, User, Upload as UploadIcon } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'

// 模拟用户数据 - 实际项目应从API获取
const userInfo = reactive({
  id: '10001',
  username: 'kdaiy',
  nickname: '交易达人',
  email: 'user@example.com',
  phone: '138****1234',
  avatar: 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
  registrationDate: '2024-01-15',
  isEmailVerified: true,
  isPhoneVerified: true
})

// 切换显示的标签页
const activeTab = ref('basicInfo')

// 基本信息表单
const basicForm = reactive({
  nickname: userInfo.nickname,
  email: userInfo.email,
  phone: userInfo.phone
})

// 修改密码表单
const passwordForm = reactive({
  currentPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 表单引用
const basicFormRef = ref(null)
const passwordFormRef = ref(null)

// 表单校验规则
const basicRules = {
  nickname: [
    { required: true, message: '请输入昵称', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号码', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
}

const passwordRules = {
  currentPassword: [
    { required: true, message: '请输入当前密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少为6个字符', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 8, message: '密码长度至少为8个字符', trigger: 'blur' },
    { 
      pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$/, 
      message: '密码需包含大小写字母、数字和特殊字符', 
      trigger: 'blur' 
    }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    { 
      validator: (rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      }, 
      trigger: 'blur' 
    }
  ]
}

// 更新基本信息
const updateBasicInfo = async () => {
  if (!basicFormRef.value) return
  
  await basicFormRef.value.validate((valid) => {
    if (valid) {
      // 实际项目中应调用API更新用户信息
      userInfo.nickname = basicForm.nickname
      userInfo.email = basicForm.email
      userInfo.phone = basicForm.phone
      ElMessage({
        message: '个人信息更新成功',
        type: 'success'
      })
    }
  })
}

// 更新密码
const updatePassword = async () => {
  if (!passwordFormRef.value) return
  
  await passwordFormRef.value.validate((valid) => {
    if (valid) {
      // 实际项目中应调用API更新密码
      ElMessage({
        message: '密码修改成功，请使用新密码重新登录',
        type: 'success'
      })
      passwordForm.currentPassword = ''
      passwordForm.newPassword = ''
      passwordForm.confirmPassword = ''
    }
  })
}

// 头像上传前的校验
const beforeAvatarUpload = (file) => {
  const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJPG) {
    ElMessage.error('头像只能是 JPG 或 PNG 格式!')
  }
  if (!isLt2M) {
    ElMessage.error('头像大小不能超过 2MB!')
  }
  return isJPG && isLt2M
}

// 头像上传成功的回调
const handleAvatarSuccess = (response) => {
  // 实际项目中应获取上传后的URL
  userInfo.avatar = URL.createObjectURL(response.raw)
  ElMessage({
    message: '头像上传成功',
    type: 'success'
  })
}

// 手机号验证对话框
const phoneVerifyVisible = ref(false)
const verificationCode = ref('')
const countdown = ref(0)
const verifyPhone = () => {
  phoneVerifyVisible.value = true
}

// 发送验证码
const sendVerificationCode = () => {
  countdown.value = 60
  const timer = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      clearInterval(timer)
    }
  }, 1000)
  
  // 实际项目中应调用API发送验证码
  ElMessage({
    message: '验证码已发送到您的手机',
    type: 'success'
  })
}

// 提交手机验证
const submitPhoneVerification = () => {
  if (!verificationCode.value) {
    ElMessage.error('请输入验证码')
    return
  }
  
  // 实际项目中应调用API验证验证码
  ElMessage({
    message: '手机验证成功',
    type: 'success'
  })
  phoneVerifyVisible.value = false
  verificationCode.value = ''
}

// 邮箱验证对话框
const emailVerifyVisible = ref(false)
const verifyEmail = () => {
  emailVerifyVisible.value = true
  
  // 实际项目中应调用API发送验证邮件
  ElMessage({
    message: '验证邮件已发送到您的邮箱',
    type: 'success'
  })
}

onMounted(() => {
  // 实际项目中应从API获取用户信息
  basicForm.nickname = userInfo.nickname
  basicForm.email = userInfo.email
  basicForm.phone = userInfo.phone
})
</script>

<template>
  <div class="user-profile">
    <div class="profile-header">
      <div class="profile-avatar-section">
        <el-avatar :size="80" :src="userInfo.avatar" />
        <el-upload
          class="avatar-uploader"
          action="#"
          :show-file-list="false"
          :on-success="handleAvatarSuccess"
          :before-upload="beforeAvatarUpload"
        >
          <el-button size="small" type="primary" plain>
            <el-icon><UploadIcon /></el-icon>
            更换头像
          </el-button>
        </el-upload>
      </div>
      <div class="profile-info">
        <h2 class="username">{{ userInfo.username }}</h2>
        <div class="user-meta">
          <span class="user-id">用户ID: {{ userInfo.id }}</span>
          <span class="register-date">注册时间: {{ userInfo.registrationDate }}</span>
        </div>
      </div>
    </div>
    
    <el-tabs v-model="activeTab" class="profile-tabs">
      <el-tab-pane label="基本信息" name="basicInfo">
        <el-form 
          ref="basicFormRef"
          :model="basicForm"
          :rules="basicRules"
          label-width="100px"
          class="profile-form"
        >
          <el-form-item label="用户昵称" prop="nickname">
            <el-input v-model="basicForm.nickname" placeholder="请设置您的昵称">
              <template #prefix>
                <el-icon><User /></el-icon>
              </template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="绑定邮箱" prop="email">
            <div class="form-item-with-status">
              <el-input v-model="basicForm.email" placeholder="请绑定您的邮箱">
                <template #prefix>
                  <el-icon><Message /></el-icon>
                </template>
              </el-input>
              <div class="verify-status">
                <el-tag v-if="userInfo.isEmailVerified" size="small" type="success">已验证</el-tag>
                <el-button v-else size="small" type="primary" link @click="verifyEmail">立即验证</el-button>
              </div>
            </div>
          </el-form-item>
          
          <el-form-item label="绑定手机" prop="phone">
            <div class="form-item-with-status">
              <el-input v-model="basicForm.phone" placeholder="请绑定您的手机号码">
                <template #prefix>
                  <el-icon><Phone /></el-icon>
                </template>
              </el-input>
              <div class="verify-status">
                <el-tag v-if="userInfo.isPhoneVerified" size="small" type="success">已验证</el-tag>
                <el-button v-else size="small" type="primary" link @click="verifyPhone">立即验证</el-button>
              </div>
            </div>
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" @click="updateBasicInfo">
              <el-icon><Edit /></el-icon>
              保存修改
            </el-button>
          </el-form-item>
        </el-form>
      </el-tab-pane>
      
      <el-tab-pane label="安全设置" name="security">
        <el-form 
          ref="passwordFormRef"
          :model="passwordForm"
          :rules="passwordRules"
          label-width="100px"
          class="profile-form"
        >
          <el-form-item label="当前密码" prop="currentPassword">
            <el-input v-model="passwordForm.currentPassword" type="password" placeholder="请输入当前密码" show-password>
              <template #prefix>
                <el-icon><Key /></el-icon>
              </template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="新密码" prop="newPassword">
            <el-input v-model="passwordForm.newPassword" type="password" placeholder="请设置新密码" show-password>
              <template #prefix>
                <el-icon><Key /></el-icon>
              </template>
            </el-input>
            <div class="password-strength">
              <div class="strength-label">密码强度要求:</div>
              <div class="strength-item">至少8个字符</div>
              <div class="strength-item">包含大小写字母</div>
              <div class="strength-item">包含数字</div>
              <div class="strength-item">包含特殊字符</div>
            </div>
          </el-form-item>
          
          <el-form-item label="确认新密码" prop="confirmPassword">
            <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" show-password>
              <template #prefix>
                <el-icon><Key /></el-icon>
              </template>
            </el-input>
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" @click="updatePassword">
              <el-icon><Edit /></el-icon>
              修改密码
            </el-button>
          </el-form-item>
        </el-form>
      </el-tab-pane>
    </el-tabs>
    
    <!-- 手机验证对话框 -->
    <el-dialog
      v-model="phoneVerifyVisible"
      title="手机验证"
      width="400px"
    >
      <div class="verify-dialog-content">
        <p class="verify-tip">验证码将发送到您的手机: {{ basicForm.phone }}</p>
        <div class="verification-input">
          <el-input v-model="verificationCode" placeholder="请输入验证码" />
          <el-button 
            type="primary" 
            :disabled="countdown > 0" 
            @click="sendVerificationCode"
          >
            {{ countdown > 0 ? `${countdown}秒后重发` : '发送验证码' }}
          </el-button>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="phoneVerifyVisible = false">取消</el-button>
          <el-button type="primary" @click="submitPhoneVerification">验证</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 邮箱验证对话框 -->
    <el-dialog
      v-model="emailVerifyVisible"
      title="邮箱验证"
      width="400px"
    >
      <div class="verify-dialog-content">
        <p class="verify-tip">验证邮件已发送到您的邮箱: {{ basicForm.email }}</p>
        <p class="verify-tip">请前往邮箱查收并点击邮件中的验证链接完成验证</p>
        <div class="verify-icon-container">
          <el-icon class="verify-icon"><Message /></el-icon>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="emailVerifyVisible = false">我知道了</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.user-profile {
  min-height: 100%;
  height: auto;
  background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 100%);
  padding: 20px;
  display: flex;
  flex-direction: column;
  overflow: visible;
}

.profile-header {
  display: flex;
  margin-bottom: 24px;
  background: #FFFFFF;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.03);
}

.profile-avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-right: 30px;
}

.avatar-uploader {
  margin-top: 10px;
}

.profile-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.username {
  margin: 0 0 8px 0;
  font-size: 22px;
  font-weight: 500;
  color: #303133;
}

.user-meta {
  display: flex;
  gap: 16px;
  color: #909399;
  font-size: 14px;
}

.profile-tabs {
  flex: none;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.03);
  overflow: visible;
}

:deep(.el-tabs__header) {
  background: #F8FAFC;
  margin: 0;
  padding: 0 20px;
}

:deep(.el-tabs__content) {
  padding: 20px;
  overflow: hidden;
}

:deep(.el-tab-pane) {
  overflow: hidden;
}

:deep(.el-tabs__inner-scroll) {
  overflow: hidden;
}

:deep(.el-tabs__nav-scroll) {
  overflow: hidden;
}

:deep(.el-form-item__content) {
  overflow: hidden;
}

:deep(.el-drawer__body) {
  overflow: hidden;
}

:deep(.el-dialog__body) {
  overflow: hidden;
}

.profile-form {
  max-width: 600px;
  overflow: hidden;
}

.form-item-with-status {
  display: flex;
  align-items: center;
  gap: 16px;
}

.verify-status {
  width: 80px;
  text-align: center;
}

.password-strength {
  margin-top: 8px;
  font-size: 12px;
  color: #909399;
}

.strength-label {
  margin-bottom: 4px;
  color: #606266;
}

.strength-item {
  margin-bottom: 2px;
}

.verify-dialog-content {
  text-align: center;
  overflow: hidden;
}

.verify-tip {
  margin-bottom: 20px;
  color: #606266;
}

.verification-input {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.verify-icon-container {
  margin: 20px 0;
}

.verify-icon {
  font-size: 40px;
  color: #409EFF;
}
</style>
