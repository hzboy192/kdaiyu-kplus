<template>
  <div class="app-container">
    <el-form :model="form" ref="formRef" label-width="100px">
      <el-form-item label="操作类型">
        <el-radio-group v-model="form.type">
          <el-radio label="aes">AES</el-radio>
          <el-radio label="rsa">RSA</el-radio>
          <el-radio label="base64">Base64</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="操作行为">
        <el-radio-group v-model="form.action">
          <el-radio label="encrypt">{{ actionLabels.encrypt }}</el-radio>
          <el-radio label="decrypt">{{ actionLabels.decrypt }}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="待处理文本">
        <el-input v-model="form.text" type="textarea" :rows="5" placeholder="请输入待处理的文本"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSubmit">提交</el-button>
      </el-form-item>
      <el-form-item label="结果">
        <el-input v-model="result" type="textarea" :rows="5" readonly></el-input>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import CryptoJS from 'crypto-js';
import { aesEncrypt, aesDecrypt, rsaEncrypt, rsaDecrypt } from '@/api/tool/crypto';

const form = ref({
  type: 'aes',
  action: 'encrypt',
  text: ''
});

const result = ref('');
const formRef = ref(null);

const actionLabels = computed(() => {
  if (form.value.type === 'base64') {
    return { encrypt: '编码', decrypt: '解码' };
  }
  return { encrypt: '加密', decrypt: '解密' };
});

watch(() => form.value.type, () => {
  form.value.action = 'encrypt';
});

const handleSubmit = () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      const { type, action, text } = form.value;
      if (!text) {
        result.value = '请输入待处理的文本';
        return;
      }
      let res;
      try {
        if (type === 'base64') {
          if (action === 'encrypt') {
            result.value = CryptoJS.enc.Base64.stringify(CryptoJS.enc.Utf8.parse(text));
          } else {
            result.value = CryptoJS.enc.Base64.parse(text).toString(CryptoJS.enc.Utf8);
          }
          return;
        }

        if (type === 'aes') {
          if (action === 'encrypt') {
            res = await aesEncrypt(text);
          } else {
            res = await aesDecrypt(text);
          }
        } else if (type === 'rsa') {
          if (action === 'encrypt') {
            res = await rsaEncrypt(text);
          } else {
            res = await rsaDecrypt(text);
          }
        }
        result.value = res.data;
      } catch (error) {
        result.value = '操作失败: ' + error.message;
      }
    }
  });
};
</script>
