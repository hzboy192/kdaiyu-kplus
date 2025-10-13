import request from '@/utils/request'

// AES 加密
export function aesEncrypt(data) {
  return request({
    url: '/tools/crypto/aes/encrypt',
    method: 'post',
    data: data
  })
}

// AES 解密
export function aesDecrypt(data) {
  return request({
    url: '/tools/crypto/aes/decrypt',
    method: 'post',
    data: data
  })
}

// RSA 加密
export function rsaEncrypt(data) {
  return request({
    url: '/tools/crypto/rsa/encrypt',
    method: 'post',
    data: data
  })
}

// RSA 解密
export function rsaDecrypt(data) {
  return request({
    url: '/tools/crypto/rsa/decrypt',
    method: 'post',
    data: data
  })
}
