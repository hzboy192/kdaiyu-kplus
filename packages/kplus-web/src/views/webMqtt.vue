<script setup>
import mqtt from 'mqtt'
import Stomp from 'stompjs'

let mqttSet = reactive({
  server: 'mqtt://192.168.10.37:15675/ws',
  client: {},
  vhost: '默认/，不支持修改',
  exchange: '默认amq.topic，不支持修改',
  routerKey: 'message-mqtt-topic',
  queue: '自动生成',
  history: '',
  message: '',
  destination: () => {
    return mqttSet.vhost + 'exchange/' + mqttSet.routerKey
  },
  send: () => {
    mqttSet.client.publish(mqttSet.routerKey, mqttSet.message)
    mqttSet.message = ''
  },
  clear: () => {
    mqttSet.history = ''
  },
  initMqtt: () => {
    mqttSet.client = mqtt.connect(mqttSet.server, { username: 'yizhen', password: 'yizhen@321' })
    mqttSet.client.on('connect', () => {
      mqttSet.history += 'connect success!\r\n'
      mqttSet.client.subscribe(mqttSet.routerKey, (err, res) => {
        if (!err) {
          mqttSet.history += mqttSet.routerKey + ' subscribed success!\r\n'
        }
      })
    })

    mqttSet.client.on('message', (topic, message) => {
      mqttSet.history += message.toString() + '\r\n'
    })
  },
  reSub: () => {
    mqttSet.client.unsubscribe(mqttSet.routerKey)
    mqttSet.client.end(true)
    mqttSet.history += 'unsubscribe ' + mqttSet.routerKey + ' message!\r\n'
    mqttSet.initMqtt()
  }
})

let stompSet = reactive({
  server: 'ws://192.168.10.37:15674/ws',
  client: {},
  headers: {},
  vhost: '/yizhen-cloud',
  exchange: 'amq.topic',
  routerKey: '',
  queue: '',
  history: '',
  message: '',
  send: () => {
    let topic = stompSet.exchange === '' ? stompSet.queue : '/exchange/' + stompSet.exchange + '/' + stompSet.queue
    stompSet.client.send(topic, stompSet.headers, '消息：' + stompSet.message)
    stompSet.message = ''
  },
  clear: () => {
    stompSet.history = ''
  },
  initStomp: () => {
    stompSet.client = Stomp.client(stompSet.server)
    stompSet.client.connect(
      'yizhen',
      'yizhen@321',
      (frm) => {
        stompSet.history += 'connect success!\r\n'
        stompSet.client.subscribe(
          stompSet.exchange === '' ? stompSet.queue : '/exchange/' + stompSet.exchange + '/' + stompSet.queue,
          (res) => {
            stompSet.history += res.body + '\r\n'
          },
          {
            id: stompSet.queue
          }
        )
      },
      (res) => {
        stompSet.history += res.body + '\r\n'
      },
      stompSet.vhost
    )
    stompSet.client.debug = false
  },
  reSub: () => {
    stompSet.history += 'unsubscribe ' + stompSet.queue + ' message !\r\n'
    stompSet.client.unsubscribe(stompSet.queue)
    stompSet.client.disconnect()

    stompSet.history += 'reconnection and subscribe.....\r\n'
    stompSet.initStomp()
  }
})

let socketSet = reactive({
  server: 'ws://localhost:8098/api/finance/ws/4444',
  client: {},
  vhost: '',
  exchange: '',
  routerKey: '',
  queue: '',
  history: '',
  message: '',
  send: () => {
    socketSet.client.send(socketSet.message)
    socketSet.message = ''
  },
  clear: () => {
    socketSet.history = ''
  },
  initWebsocket: () => {
    socketSet.client = new WebSocket(socketSet.server)
    socketSet.client.onmessage = function (msg) {
      socketSet.history += msg.data + '\r\n'
    }
    socketSet.client.onerror = function (err) {
      socketSet.history += 'onerror:' + err + '\r\n'
    }
    socketSet.client.onopen = function (op) {
      socketSet.history += 'WebSocket connection success！\r\n'
    }
  }
})

onMounted(() => {
  // mqttSet.initMqtt()
  // stompSet.initStomp()
  socketSet.initWebsocket()
})
</script>

<template>
  <div class="container el-row">
    <div class="el-col-8">
      <el-form :model="mqttSet" label-width="120px">
        <el-form-item label-width="0" class="mq-title"><span> MQTT实现 </span></el-form-item>
        <el-form-item label="MQ Server">
          <el-input v-model="mqttSet.server" />
        </el-form-item>
        <el-form-item label="v-hosts">
          <el-input v-model="mqttSet.vhost" readonly />
        </el-form-item>
        <el-form-item label="交换机">
          <el-input v-model="mqttSet.exchange" readonly />
        </el-form-item>
        <el-form-item label="router-key">
          <el-input v-model="mqttSet.routerKey" />
        </el-form-item>
        <el-form-item label="queue">
          <el-input v-model="mqttSet.queue" readonly />
        </el-form-item>
        <el-form-item label="通讯记录">
          <el-input v-model="mqttSet.history" type="textarea" rows="19" readonly />
        </el-form-item>
        <el-form-item label="输入内容">
          <el-input v-model="mqttSet.message" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="mqttSet.send">send</el-button>
          <el-button @click="mqttSet.clear">clear</el-button>
          <el-button @click="mqttSet.reSub">resub</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="el-col-8">
      <el-form :model="stompSet" label-width="120px">
        <el-form-item label-width="0" class="mq-title"><span> STOMP实现 </span></el-form-item>
        <el-form-item label="MQ Server">
          <el-input v-model="stompSet.server" />
        </el-form-item>
        <el-form-item label="v-hosts">
          <el-input v-model="stompSet.vhost" />
        </el-form-item>
        <el-form-item label="交换机">
          <el-input v-model="stompSet.exchange" />
        </el-form-item>
        <el-form-item label="router-key">
          <el-input v-model="stompSet.routerKey" />
        </el-form-item>
        <el-form-item label="queue">
          <el-input v-model="stompSet.queue" />
        </el-form-item>
        <el-form-item label="通讯记录">
          <el-input v-model="stompSet.history" type="textarea" rows="19" readonly />
        </el-form-item>
        <el-form-item label="输入内容">
          <el-input v-model="stompSet.message" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="stompSet.send">send</el-button>
          <el-button @click="stompSet.clear">clear</el-button>
          <el-button @click="stompSet.reSub">resub</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="el-col-8">
      <el-form :model="socketSet" label-width="120px">
        <el-form-item label-width="0" class="mq-title"><span> WebSocket实现 </span></el-form-item>
        <el-form-item label="MQ Server">
          <el-input v-model="socketSet.server" />
        </el-form-item>
        <el-form-item label="v-hosts">
          <el-input v-model="socketSet.vhost" />
        </el-form-item>
        <el-form-item label="交换机">
          <el-input v-model="socketSet.exchange" />
        </el-form-item>
        <el-form-item label="router-key">
          <el-input v-model="socketSet.routerKey" />
        </el-form-item>
        <el-form-item label="queue">
          <el-input v-model="socketSet.queue" />
        </el-form-item>
        <el-form-item label="通讯记录">
          <el-input v-model="socketSet.history" type="textarea" rows="19" readonly />
        </el-form-item>
        <el-form-item label="输入内容">
          <el-input v-model="socketSet.message" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="socketSet.send">send</el-button>
          <el-button @click="socketSet.clear">clear</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<style scoped>
.container {
  width: 100%;
  padding: 5px;
}
.mq-title span {
  font-weight: 800;
  font-size: 16px;
  margin: auto;
}
</style>
