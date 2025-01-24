import { SnowflakeIdv1 } from 'simple-flakeid'

//默认id生成器配置 epoch: 时间2024-01-01 00:00:00
let defaultIdGenerator = new SnowflakeIdv1({ workerId: 1, baseTime: 1704038400000 })

// 雪花算法ID, 客户端生成ID方案有缺陷，尽量在服务器上生成ID
export const simpleFlakeId = () => {
  return defaultIdGenerator.NextNumber()
}
