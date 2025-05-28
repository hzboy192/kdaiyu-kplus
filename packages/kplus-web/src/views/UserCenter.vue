<template>
  <!--参考：
  https://img.zcool.cn/community/015387568b330132f8759f047daa77.png@1280w_1l_2o_100sh.png
  https://img.zcool.cn/community/031f7c058d0e072a801219c77857c47.jpg
  个人中心、工作台页面参考：
  https://vuejs-core.cn/admin-plus/?from=authorization#/setting/personalCenter
  小米个人中心页面参考：
  https://account.xiaomi.com/fe/service/account?cUserId=ElAAgUZxavgBz403TRk0UvAYuk8&userId=2183126680&_locale=zh_CN
  -->
  <div class="user-center">
    <el-container>
      <el-header>
        <div class="header-content">
          <div class="vcenter">
            <span style="width: 15px">&nbsp;</span>
            <img alt="口袋鱼" src="/image/logo.png" width="40px" height="40px" />
            <span>口袋鱼</span>
          </div>
          <div class="vcenter">
            <ul>
              <li title="训练营" @click="goTraining"><i class="iconfont icon-xunlianying" /></li>
              <li>
                <i class="iconfont icon-bell">
                  <el-badge is-dot class="badge-msg" />
                </i>
              </li>
              <li>
                <user-head-avatar />
              </li>
            </ul>
          </div>
        </div>
      </el-header>
      <el-main>
        <el-menu :default-active="activeMenu">
          <div class="menu-user-info">
            <el-avatar :size="110" src="/image/user.jpg" />
            <span>泊远万里</span>
          </div>

          <el-menu-item v-for="menu in menuData" :key="menu.id" :index="menu.id" @click="menuHandle(menu)">
            <i :class="['iconfont', menu.icon]">&nbsp;</i><span>{{ menu.name }}</span>
          </el-menu-item>
        </el-menu>
        <div class="content">
          <router-view />
        </div>
      </el-main>
      <!--<el-footer />-->
    </el-container>
  </div>
</template>

<script setup>
import { useRouter, useRoute } from 'vue-router'
import UserHeadAvatar from '@c/user/UserHeadAvatar.vue'

const router = useRouter()
const route = useRoute()

let menuData = reactive([
  { id: 'dashboard', name: '数据总览', icon: 'icon-gongzuotai', routeTo: '/userCenter' },
  { id: 'analyses', name: '交易统计', icon: 'icon-shujufenxi-baobeifenxi', routeTo: '/userCenter/analyses' },
  { id: 'accountMgr', name: '账户管理', icon: 'icon-zhanghaoguanli', routeTo: '/userCenter/accountMgr' },
  { id: 'profile', name: '信息维护', icon: 'icon-zhanghaoguanli', routeTo: '/userCenter/profile' }
])

let activeMenu = computed(() => {
  return menuData.find((it) => it.routeTo === route.path).id
})

let goTraining = () => {
  router.push('/kline-plus')
}

let menuHandle = (menu) => {
  router.replace({ path: menu.routeTo })
}
</script>

<style scoped>
.user-center {
  background-color: #f4f5f5;
  --bg-color: #ffffff;
  --top-nav-height: 60px;
  --main-content-width: 78%;
  --el-menu-text-color: rgba(0, 0, 0, 0.8);
  --el-text-color-primary: #141414;
  --el-menu-hover-bg-color: #e9e9eb;
  --el-menu-user-info-height: 180px;
}

.el-header {
  position: fixed;
  width: 100%;
  height: var(--top-nav-height);
  background-color: #18222c;
  box-shadow: 0 1px 1px 1px #f9f9f9;
  color: rgba(255, 255, 255, 0.8);
  z-index: 100;
  padding: 0;

  .header-content {
    display: flex;
    height: 100%;
    line-height: var(--top-nav-height);
    justify-content: space-between;

    ul,
    li {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0 12px;
    }
  }
}

.vcenter {
  display: flex;
  justify-content: center;
  align-items: center;

  li {
    padding: 0 15px;
  }
}
.badge-msg {
  margin-top: -20px;
  margin-right: -5px;
}
.el-main {
  display: flex;
  padding: calc(var(--top-nav-height) + 2px) 0 0;
  min-height: calc(100vh - 10px);
  color: var(--el-text-color-primary);

  .el-menu {
    background-color: var(--bg-color);
    width: 200px;
    border-right: 0;
    height: max-content;

    .el-avatar {
      border: 4px solid #eee;
    }

    .menu-user-info {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding-top: 15px;
      width: 100%;
      height: var(--el-menu-user-info-height);
      border-bottom: solid 1px #e3e5e8;
    }

    .el-menu-item {
      justify-content: center;
    }

    .is-active {
      color: var(--el-text-color-primary);
      font-weight: bold;
    }
  }

  .content {
    flex: 1;
    margin-left: 5px;
    background-color: var(--bg-color);
    padding: 15px;
  }
}

.el-main,
.header-content {
  min-width: 1024px;
  width: var(--main-content-width);
  margin: 0 auto;
}

.el-footer {
  margin: 0 auto;
  padding: 0 20px;
  height: 100px;
  width: var(--main-content-width);
  font-size: 20px;
  background-color: var(--bg-color);
}
</style>
