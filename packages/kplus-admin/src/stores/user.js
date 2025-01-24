import { defineStore } from 'pinia'
import { userLogin, getCurrentUser, logout } from '@d/user_data'

const useUserStore = defineStore('user', {
  state: () => {
    return { token: null, user: null, roles: [], permissions: [] }
  },
  actions: {
    login(userInfo) {
      return new Promise((resolve, reject) => {
        userLogin(userInfo)
          .then(({ status, data, message }) => {
            if (status === 200) {
              this.token = data
            }
            resolve({ status, data, message })
          })
          .catch((error) => {
            reject(error)
          })
      })
    },

    getInfo() {
      return new Promise((resolve, reject) => {
        getCurrentUser()
          .then(({ data }) => {
            this.user = data.user
            this.permissions = data.permissions
            this.roles = data.roles
            resolve(data)
          })
          .catch((error) => {
            reject(error)
          })
      })
    },

    logout() {
      return new Promise((resolve, reject) => {
        logout()
          .then(() => {
            this.token = null
            this.user = null
            this.permissions = []
            this.roles = []
            resolve()
          })
          .catch((error) => {
            reject(error)
          })
      })
    }
  },
  persist: true
})
export default useUserStore
