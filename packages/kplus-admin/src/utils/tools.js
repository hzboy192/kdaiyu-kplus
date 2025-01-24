import CryptoJS from 'crypto-js'

const key = CryptoJS.enc.Utf8.parse('***REMOVED***')
const iv = CryptoJS.enc.Utf8.parse('***REMOVED***')
const aesCfg = { iv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 }
// AES加密
export function encrypt(text, keyIv) {
  if (keyIv) {
    return CryptoJS.AES.encrypt(text, key, Object.assign({}, aesCfg, { iv: CryptoJS.enc.Utf8.parse(keyIv) })).toString()
  }
  return CryptoJS.AES.encrypt(text, key, aesCfg).toString()
}

// AES解密
export function decrypt(text, keyIv) {
  let decrypt = ''
  if (keyIv) {
    decrypt = CryptoJS.AES.decrypt(text, key, Object.assign({}, aesCfg, { iv: CryptoJS.enc.Utf8.parse(keyIv) }))
  } else {
    decrypt = CryptoJS.AES.decrypt(text, key, aesCfg)
  }
  return CryptoJS.enc.Utf8.stringify(decrypt).toString()
}
