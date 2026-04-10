# 业务规则

> K线模拟训练系统核心业务逻辑

## 业务概述

Kplus 是一个期货K线模拟训练系统，用户可以：
1. 选择期货商品和K线周期
2. 设置训练时间范围和初始资金
3. 通过K线逐根播放进行仿真交易
4. 进行开仓/平仓操作
5. 实时计算盈亏并统计训练成绩

## 核心业务实体

### UserTrainEntity - 用户训练记录

| 字段 | 类型 | 说明 |
|------|------|------|
| traId | Long | 主键（雪花ID） |
| userId | Long | 用户ID |
| goodCode | String | 商品编码 |
| symbol | String | 合约编号（主力合约） |
| period | String | K线周期 |
| status | Integer | 状态：0.未开始, 1.进行中, -1.已结束 |
| startTime | Date | 训练开始时间（K线时间范围） |
| finishTime | Date | 训练结束时间（K线时间范围） |
| firstAmount | BigDecimal | 账户初始金额 |
| finishAmount | BigDecimal | 账户结余金额 |
| fundId | Long | 资金账户ID |
| serCharge | BigDecimal | 手续费单价 |
| unitPrice | BigDecimal | 每跳单价 |

### UserTrainDtlEntity - 训练交易记录

| 字段 | 类型 | 说明 |
|------|------|------|
| trdId | Long | 主键（雪花ID） |
| traId | Long | 训练记录ID |
| trdAt | Date | 开仓/平仓时间点 |
| type | Integer | 类型：0.开仓单, 1.平仓结算单 |
| open | BigDecimal | 开仓点位 |
| direction | Integer | 方向：1.多, -1.空, 0.平 |
| trdNum | Integer | 交易手数 |
| status | Integer | 状态：1.持有中, 0.已平仓 |
| close | Integer | 平仓点位 |
| serAmount | BigDecimal | 手续费金额 |
| income | BigDecimal | 收益金额 |

### BarInfoEntity - K线数据

| 字段 | 类型 | 说明 |
|------|------|------|
| code | String | 合约编码 |
| gCode | String | 商品编码 |
| cycle | String | 周期 |
| date | String | 时间 |
| open | Float | 开盘价 |
| high | Float | 最高价 |
| low | Float | 最低价 |
| close | Float | 收盘价 |
| vol | Long | 成交量 |
| amount | Double | 持仓量 |

### GoodsInfoEntity - 期货商品信息

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Integer | 主键 |
| code | String | 编码 |
| name | String | 名称 |
| mainNum | String | 主力编号 |
| mainName | String | 主力名称 |
| marketCode | String | 市场编码 |
| marketName | String | 市场名称 |

## 训练状态定义

```javascript
// 前端 TrainCore.js
const TRAIN_STATUS = {
  READY: 0,      // 未开始
  RUNNING: 1,    // 进行中
  FINISH: -1     // 已结束
}

// 后端 UserTrainService.java
Integer TRAIN_STATUS_READY = 0;      // 未开始
Integer TRAIN_STATUS_RUNNING = 1;    // 进行中
Integer TRAIN_STATUS_FINISH = -1;    // 已结束
```

## 交易方向定义

```javascript
const TRADE_DIRECTION = {
  UP: 1,        // 做多
  DOWN: -1,     // 做空
  CLOSE: 0      // 平仓
}
```

## 仓单状态定义

```javascript
const TRADE_STATUS = {
  HOLDING: 1,   // 持有中
  CLOSED: 0     // 已平仓
}
```

## K线周期定义

| 周期 | key | 说明 | 每页数据量 |
|------|-----|------|-----------|
| 1分钟 | 1m | 1分钟K线 | 2000根 |
| 5分钟 | 5m | 5分钟K线 | 400根 |
| 15分钟 | 15m | 15分钟K线 | 133根 |
| 30分钟 | 30m | 30分钟K线 | 67根 |
| 60分钟 | 60m | 60分钟K线 | 33根 |
| 日线 | 1d | 日K线 | 约20根 |

## 训练流程

### 1. 训练初始化

```javascript
// 用户设置训练参数
let trainSetting = {
  goods: { code, mainNum },      // 商品信息
  period: { key, pageSize },     // 周期信息
  from: startDate,               // 开始时间
  to: endDate,                   // 结束时间
  openNum: 1,                    // 默认开仓手数
  closeNum: 1                    // 默认平仓手数
}

// 创建训练记录（后端）
POST /api/userTrain
{
  fundId: accountInfo.fundAccount.id,
  goodCode: trainSetting.goods.code,
  symbol: trainSetting.goods.mainNum,
  period: trainSetting.period.key,
  status: 1,
  startTime: trainSetting.from,
  finishTime: trainSetting.to,
  serCharge: symbolInfo.serCharge,
  unitPrice: symbolInfo.unitPrice
}

// 返回训练ID
Response: { traId: "55420297526000146" }
```

### 2. 加载K线数据

```javascript
// 分批加载K线数据
getBarData(symbol, period, from, to).then(list => {
  // 将数据分成两部分
  let drawData = list.splice(0, list.length / 2)  // 先绘制前半部分
  trainOption.waitDrawList = list                  // 后半部分待播放
  
  // 初始化图表
  chart.applyNewData(drawData)
})
```

### 3. K线播放

```javascript
// 快捷键绑定
key('s', updateNewData)  // 播放一根K线

// 播放逻辑
let updateNewData = () => {
  // 从待播放列表取出一根K线
  trainOption.lastK = trainOption.waitDrawList.splice(0, 1)[0]
  
  // 更新图表
  chart.updateData(trainOption.lastK)
  
  // 触发持仓收益重新计算
  refLastK.value = trainOption.lastK
}
```

### 4. 开仓操作

```javascript
// 快捷键绑定
key('d', openTradeMany)   // 做多（方向=1）
key('a', openTradeEmpty)  // 做空（方向=-1）

// 开仓规则
let openTrade = (direction) => {
  let lastTrade = trainOption.transList[trainOption.transList.length - 1]
  let isHolding = lastTrade && lastTrade.status === TRADE_STATUS.HOLDING
  
  // 规则1：不支持反向开仓
  if (isHolding && lastTrade.direction !== direction) {
    // 提示：不支持反向开仓，需先平仓
    return
  }
  
  // 规则2：同一时间点多次开仓，数量累加
  if (isHolding && lastTrade.direction === direction && 
      trainOption.lastK.timestamp === lastTrade.trdAt) {
    lastTrade.trdNum += trainOption.openNum
  } else {
    // 规则3：新建开仓单
    let tradeInfo = {
      trdId: null,
      traId: trainOption.traId,
      trdAt: trainOption.lastK.timestamp,
      type: 0,                          // 开仓单
      open: trainOption.lastK.close,    // 开仓点位
      direction: direction,             // 方向
      trdNum: trainOption.openNum,      // 手数
      closeNum: 0,                      // 已平仓数量
      status: TRADE_STATUS.HOLDING,     // 持有中
      serAmount: openNum * serCharge    // 手续费
    }
    trainOption.transList.push(tradeInfo)
  }
  
  // 保存到后端
  POST /api/userTrainDtl
}
```

### 5. 平仓操作

```javascript
// 快捷键绑定
key('w', closeTrade)  // 平仓

// 平仓规则
let closeTrade = () => {
  // 规则1：平仓手数不能大于持仓手数
  if (trainOption.closeNum > trainOption.holdingNum) {
    return
  }
  
  // 获取所有持仓中的仓单
  let holdingList = trainOption.transList.filter(
    it => it.status === TRADE_STATUS.HOLDING
  )
  
  // 生成平仓结算单
  let tradeBilling = {
    trdAt: trainOption.lastK.timestamp,
    type: 1,                           // 平仓结算单
    trdNum: trainOption.closeNum,      // 平仓手数
    close: trainOption.lastK.close,    // 平仓点位
    status: TRADE_STATUS.CLOSED,       // 已平仓
    serAmount: closeNum * serCharge    // 手续费
  }
  
  // 分配开仓点位（支持部分平仓）
  let closeCount = trainOption.closeNum
  let openArray = []
  
  for (let holding of holdingList) {
    let haveCount = holding.trdNum - holding.closeNum  // 剩余未平仓手数
    
    if (haveCount > closeCount) {
      // 部分平仓
      openArray.push(holding.open * closeCount)
      holding.closeNum += closeCount
      closeCount = 0
    } else {
      // 全部平仓
      closeCount -= haveCount
      holding.closeNum = holding.trdNum
      holding.status = TRADE_STATUS.CLOSED
      openArray.push(holding.open * haveCount)
    }
  }
  
  // 计算平均开仓点位
  tradeBilling.open = sum(openArray) / trainOption.closeNum
  
  // 计算收益
  // 收益 = (平仓点位 - 开仓点位) * 手数 * 每跳单价 - 手续费
  tradeBilling.income = 
    (direction === 1 ? close - open : open - close) * 
    trdNum * unitPrice - serAmount
  
  // 保存到后端
  POST /api/userTrainDtl/close
}
```

### 6. 盈亏计算

```javascript
// 实时计算持仓收益
watch([transList, refLastK], () => {
  let unitPrice = trainOption.symbolInfo.unitPrice
  let holdingNum = 0
  let holdingIncome = 0
  
  transList.forEach(it => {
    if (it.status === TRADE_STATUS.HOLDING) {
      let haveCount = it.trdNum - it.closeNum
      holdingNum += haveCount
      
      // 持仓收益 = (当前收盘价 - 开仓点位) * 手数 * 每跳单价
      holdingIncome += 
        (it.direction === 1 ? lastK.close - it.open : it.open - lastK.close) 
        * haveCount * unitPrice
    }
  })
  
  // 收益率
  let incomePercent = holdingNum > 0 ? 
    Math.round((holdingIncome / holdingAmount) * 100) : 0
  
  // 发布汇总事件
  emit.emit('onTrainSummary', {
    holdingNum,
    holdingIncome,
    incomePercent
  })
})
```

### 7. 训练结束

```javascript
// 当K线播放完毕
if (trainOption.waitDrawList.length === 0) {
  trainOption.status = TRAIN_STATUS.FINISH
  
  // 更新后端训练记录状态
  PUT /api/userTrain { status: -1 }
  
  // 显示训练成绩弹窗
  trainScoreDialogRef.value.showDialog(traId)
}
```

## 手续费计算

### 手续费类型

```javascript
// 按比例计算（serCalcType = 'P'）
serAmount = serCharge * closePrice

// 按固定值计算（serCalcType = 'F'）
serAmount = serCharge
```

### 获取合约信息

```javascript
POST /api/userTrain/SymbolInfo
{
  symbol: "IF2501",
  exchange: "SHFE"
}

Response: {
  serCharge: 25.0,       // 手续费单价
  unitPrice: 300,        // 每跳单价
  serCalcType: 'P'       // 计算类型
}
```

## 资金账户管理

### 资金账户实体

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键 |
| userId | Long | 用户ID |
| amount | BigDecimal | 账户余额 |
| isDefault | Boolean | 是否默认账户 |

### 资金更新逻辑

```java
// 平仓后更新账户余额
public FundAccountEntity refreshFundAmount(Long traId, BigDecimal amount) {
    UserTrainEntity train = getById(traId);
    FundAccountEntity fund = fundAccountService.getById(train.getFundId());
    fund.setAmount(fund.getAmount().add(amount));
    fundAccountService.updateById(fund);
    return fund;
}
```

## 快捷键定义

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| S | 播放K线 | 逐根播放下一根K线 |
| D | 开多单 | 做多开仓 |
| A | 开空单 | 做空开仓 |
| W | 平仓 | 平掉当前持仓 |
| P | 打印日志 | 打印交易记录调试 |

## 业务规则总结

### 开仓规则

1. **不支持反向开仓**：持有多单时不能开空单，反之亦然
2. **同一时间多次开仓**：数量累加，不新建仓单
3. **开仓手数**：由用户设置，默认1手

### 平仓规则

1. **平仓手数限制**：不能超过持仓手数
2. **部分平仓**：支持分批平仓，按开仓顺序分配
3. **平均开仓价**：分批平仓时计算平均开仓点位
4. **手续费双向收取**：开仓和平仓各收一次

### 盈亏计算

1. **持仓收益**：实时计算，随K线价格变化
2. **平仓收益**：平仓时结算，计入账户余额
3. **收益率**：(收益 / 持仓金额) * 100%

### 训练结束

1. **K线播完**：自动结束训练
2. **手动结束**：用户可提前结束
3. **成绩统计**：计算总收益、胜率等指标