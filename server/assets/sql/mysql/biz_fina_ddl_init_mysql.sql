CREATE TABLE `sys_user`
(
    `uid`         int      NOT NULL COMMENT '雪花算法ID',
    `account`     varchar(100) DEFAULT NULL COMMENT '账号',
    `nick_name`   varchar(255) DEFAULT NULL COMMENT '昵称',
    `e_mail`      varchar(255) DEFAULT NULL COMMENT 'Email',
    `sex`         char(1)  NOT NULL COMMENT '性别:M.男，W.女，O.其他',
    `telphone`    varchar(30)  DEFAULT NULL COMMENT '电话',
    `level`       varchar(10)  DEFAULT NULL COMMENT '级别',
    `status`      char(1)      DEFAULT NULL COMMENT '状态：L:锁定',
    `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最新修改时间',
    PRIMARY KEY (`uid`),
    UNIQUE KEY `account` (`account`),
    UNIQUE KEY `telphone` (`telphone`),
    UNIQUE KEY `e_mail` (`e_mail`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='用户基础信息表';

CREATE TABLE `fu_bar_info`
(
    `CODE`        varchar(50) NOT NULL COMMENT '合约编码',
    `G_CODE`      varchar(50) NOT NULL COMMENT '商品编码',
    `CYCLE`       varchar(5)  NOT NULL COMMENT '周期',
    `DATE`        varchar(20) NOT NULL COMMENT '时间',
    `OPEN`        float    DEFAULT NULL COMMENT '开盘价',
    `HIGH`        float    DEFAULT NULL COMMENT '最高盘价',
    `LOW`         float    DEFAULT NULL COMMENT '最低盘价',
    `CLOSE`       float    DEFAULT NULL COMMENT '收盘价',
    `VOL`         bigint   DEFAULT NULL COMMENT '成交量',
    `AMOUNT`      double   DEFAULT NULL COMMENT '持仓量',
    `UPDATE_TIME` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`G_CODE`, `CODE`, `CYCLE`, `DATE`) USING BTREE,
    KEY `IDX_FOR_NAME` (`CODE`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='期货bar数据列表';


CREATE TABLE `fu_goods_info`
(
    `ID`          int NOT NULL AUTO_INCREMENT COMMENT '主键',
    `CODE`        varchar(255) DEFAULT NULL COMMENT '编码',
    `NAME`        varchar(255) DEFAULT NULL COMMENT '名称',
    `MAIN_NUM`    varchar(255) DEFAULT NULL COMMENT '主力编号',
    `MARKET_CODE` varchar(255) DEFAULT NULL COMMENT '市场编码',
    `MARKET_NAME` varchar(255) DEFAULT NULL COMMENT '市场名称',
    `IS_ENABLE`   tinyint      DEFAULT NULL COMMENT '启用状态：1.启用，0.禁用',
    `CREATE_BY`   varchar(255) DEFAULT NULL COMMENT '创建人',
    `CREATE_TIME` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `UPDATE_BY`   varchar(255) DEFAULT NULL COMMENT '更新人',
    `UPDATE_TIME` datetime     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`ID`) USING BTREE,
    UNIQUE KEY `idx_code_unique` (`CODE`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='期货商品信息';



CREATE TABLE `fu_trade_info`
(
    `id`          int       NOT NULL AUTO_INCREMENT,
    `FOR_CODE`    varchar(255)   DEFAULT NULL COMMENT '合约编码',
    `FOR_NAME`    varchar(255)   DEFAULT NULL COMMENT '合约名称',
    `G_CODE`      varchar(255)   DEFAULT NULL COMMENT '商品编码',
    `STRATEGY`    varchar(255)   DEFAULT NULL COMMENT '策略',
    `TREND`       tinyint        DEFAULT NULL COMMENT '趋势,0.空，1.多',
    `CYCLE`       varchar(255)   DEFAULT NULL COMMENT '开仓周期',
    `OPEN_AT`     float          DEFAULT NULL COMMENT '开仓点位',
    `OPEN_TIME`   datetime       DEFAULT NULL COMMENT '开仓时间',
    `CLOSE_AT`    float          DEFAULT NULL COMMENT '平仓点位',
    `CLOSE_TIME`  datetime       DEFAULT NULL COMMENT '平仓时间',
    `CUR_STATUS`  tinyint        DEFAULT NULL COMMENT '状态:1.持有中,2.以平仓',
    `MAX_AT`      float          DEFAULT NULL COMMENT '最大值',
    `MIN_AT`      float          DEFAULT NULL COMMENT '最小值',
    `CREATE_BY`   varchar(255)   DEFAULT NULL COMMENT '创建人',
    `CREATE_TIME` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `UPDATE_BY`   varchar(255)   DEFAULT NULL COMMENT '更新人',
    `UPDATE_TIME` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE `fu_min_mapping` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `cycle_5m` time NOT NULL COMMENT '5分钟时间',
    `cycle_15m` time DEFAULT NULL COMMENT '15分钟时间',
    `cycle_20m` time DEFAULT NULL COMMENT '20分钟时间',
    `cycle_30m` time DEFAULT NULL COMMENT '30分钟时间',
    `cycle_1h` time DEFAULT NULL COMMENT '1小时时间',
    `cycle_2h` time DEFAULT NULL COMMENT '2小时时间',
    `cycle_4h` time DEFAULT NULL COMMENT '4小时时间',
    `cycle_d` time DEFAULT NULL COMMENT '日',
    `last_update_time` datetime DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='期货分钟周期映射';