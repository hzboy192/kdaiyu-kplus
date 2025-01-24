<template>
  <el-dialog v-model="fundDialog.show" title="资金账户" width="500" draggable :close-on-click-modal="false" :show-close="false">
    <el-form ref="formRef" :inline="false" label-position="right" size="default" :model="formData" :rules="formRules" @submit.prevent>
      <el-form-item label-width="0">
        <el-alert title="首次使用请先创建资金账户，可自定义初始金额。" type="warning" show-icon :closable="false" />
      </el-form-item>
      <el-form-item prop="accName" label="账号" :required="true">
        <el-input v-model="formData.accName" placeholder="默认账号" />
      </el-form-item>
      <el-form-item prop="amount" label="金额" :required="true">
        <el-input-number v-model="formData.amount" :min="10000" :max="99999999" placeholder="请输入金额" :step="1000" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button type="primary" @click="submit">提交</el-button>
    </template>
  </el-dialog>
</template>
<script setup>
import { saveFundAccount } from '@d/fund_account'

const emit = defineEmits(['success', 'cancel'])
const formRef = ref()
const fundDialog = reactive({
  show: false
})

const formData = reactive({
  accName: '默认账号',
  amount: 50000,
  isDefault: true
})

const formRules = {
  accName: [{ required: true, message: '账户名称不能为空!' }],
  amount: [{ required: true, message: '金额不能为空!' }]
}

function submit() {
  formRef.value.validate((valid) => {
    if (valid) {
      saveFundAccount(formData).then((res) => {
        fundDialog.show = false
        emit('success', res)
      })
    }
  })
}

let showDialog = () => {
  fundDialog.show = true
}
defineExpose({ showDialog })
</script>
<style></style>
