set search_path = fina;

CREATE TABLE fina.fu_bar_info (
      code varchar(50) collate pg_catalog.default not null,
      g_code varchar(50) collate pg_catalog.default not null,
      cycle varchar(5) collate pg_catalog.default not null,
      date timestamp(6) not null,
      open numeric(10,2) default null::numeric,
      high numeric(10,2) default null::numeric,
      low numeric(10,2) default null::numeric,
      close numeric(10,2) default null::numeric,
      vol int8,
      amount int8,
      update_time timestamp(6) default current_timestamp,
      constraint unique_idx unique (code, g_code, cycle, date)
)
;

ALTER TABLE fina.fu_bar_info OWNER TO root;

CREATE UNIQUE INDEX idx_fu_bar_pk ON fina.fu_bar_info USING btree (
    CODE COLLATE pg_catalog.default pg_catalog.text_ops ASC NULLS LAST,
    CYCLE COLLATE pg_catalog.default pg_catalog.text_ops ASC NULLS LAST,
    DATE pg_catalog.timestamp_ops ASC NULLS LAST
);

CREATE INDEX idx_fu_g_code ON fina.fu_bar_info USING btree (G_CODE COLLATE pg_catalog.default pg_catalog.text_ops ASC NULLS LAST);

COMMENT ON COLUMN fina.fu_bar_info.CODE IS '合约编码';
COMMENT ON COLUMN fina.fu_bar_info.G_CODE IS '商品编码';
COMMENT ON COLUMN fina.fu_bar_info.CYCLE IS '周期';
COMMENT ON COLUMN fina.fu_bar_info.DATE IS '时间';
COMMENT ON COLUMN fina.fu_bar_info.OPEN IS '开盘价';
COMMENT ON COLUMN fina.fu_bar_info.HIGH IS '最高盘价';
COMMENT ON COLUMN fina.fu_bar_info.LOW IS '最低盘价';
COMMENT ON COLUMN fina.fu_bar_info.CLOSE IS '收盘价';
COMMENT ON COLUMN fina.fu_bar_info.VOL IS '成交量';
COMMENT ON COLUMN fina.fu_bar_info.AMOUNT IS '持仓量';
COMMENT ON COLUMN fina.fu_bar_info.UPDATE_TIME IS '更新时间';


DROP TABLE IF EXISTS fina.fu_ef_base_info;
CREATE TABLE fina.fu_ef_base_info (
    id serial PRIMARY KEY,
    code varchar(255),
    m_continuous_code varchar(255),
    name varchar(255),
    market_code varchar(255),
    market_name varchar(255),
    remark varchar(500)
);
COMMENT ON COLUMN fina.fu_ef_base_info.code IS '编码';
COMMENT ON COLUMN fina.fu_ef_base_info.m_continuous_code IS '主力连续编码';
COMMENT ON COLUMN fina.fu_ef_base_info.name IS '名称';
COMMENT ON COLUMN fina.fu_ef_base_info.market_code IS '市场ID';
COMMENT ON COLUMN fina.fu_ef_base_info.market_name IS '市场名词';
COMMENT ON COLUMN fina.fu_ef_base_info.remark IS '备注';


DROP TABLE IF EXISTS fina.fu_goods_info;
create table fu_goods_info
(
    id          serial4 primary key,
    code        varchar(255),
    name        varchar(255),
    main_num    varchar(255),
    main_name   varchar(255),
    market_code varchar(255),
    market_name varchar(255),
    is_enable   char,
    update_time timestamp(6) default LOCALTIMESTAMP
);

comment on table fu_goods_info is '期货商品信息';
comment on column fu_goods_info.id is '主键';
comment on column fu_goods_info.code is '编码';
comment on column fu_goods_info.name is '名称';
comment on column fu_goods_info.main_num is '主力编号';
comment on column fu_goods_info.main_name is '主力名称';
comment on column fu_goods_info.market_code is '市场编码';
comment on column fu_goods_info.market_name is '市场名称';
comment on column fu_goods_info.is_enable is '启用状态：Y.启用，N.禁用';
comment on column fu_goods_info.update_time is '更新时间';


DROP TABLE IF EXISTS fina.fu_min_mapping;
CREATE TABLE fina.fu_min_mapping (
    id serial PRIMARY KEY,
    cycle_5m time NOT NULL,
    cycle_15m time,
    cycle_20m time,
    cycle_30m time,
    cycle_1h time,
    cycle_2h time,
    cycle_4h time,
    cycle_d time,
    last_update_time timestamp
);
COMMENT ON COLUMN fina.fu_min_mapping.cycle_5m IS '5分钟时间';
COMMENT ON COLUMN fina.fu_min_mapping.cycle_15m IS '15分钟时间';
COMMENT ON COLUMN fina.fu_min_mapping.cycle_20m IS '20分钟时间';
COMMENT ON COLUMN fina.fu_min_mapping.cycle_30m IS '30分钟时间';
COMMENT ON COLUMN fina.fu_min_mapping.cycle_1h IS '1小时时间';
COMMENT ON COLUMN fina.fu_min_mapping.cycle_2h IS '2小时时间';
COMMENT ON COLUMN fina.fu_min_mapping.cycle_4h IS '4小时时间';
COMMENT ON COLUMN fina.fu_min_mapping.cycle_d IS '日';
COMMENT ON TABLE fina.fu_min_mapping IS '期货分钟周期映射';



DROP TABLE IF EXISTS fina.fu_trade_info;
CREATE TABLE fina.fu_trade_info (
    id serial PRIMARY KEY,
    for_code varchar(255),
    for_name varchar(255),
    g_code varchar(255),
    strategy varchar(255),
    trend int2,
    cycle varchar(255),
    open_at numeric(10,2),
    open_time timestamp,
    close_at numeric(10,2),
    close_time timestamp,
    cur_status int2,
    max_at numeric(10,2),
    min_at numeric(10,2),
    create_by varchar(255),
    create_time timestamp,
    update_by varchar(255),
    update_time timestamp
);
COMMENT ON COLUMN fina.fu_trade_info.for_code IS '合约编码';
COMMENT ON COLUMN fina.fu_trade_info.for_name IS '合约名称';
COMMENT ON COLUMN fina.fu_trade_info.g_code IS '商品编码';
COMMENT ON COLUMN fina.fu_trade_info.strategy IS '策略';
COMMENT ON COLUMN fina.fu_trade_info.trend IS '趋势,0.空，1.多';
COMMENT ON COLUMN fina.fu_trade_info.cycle IS '开仓周期';
COMMENT ON COLUMN fina.fu_trade_info.open_at IS '开仓点位';
COMMENT ON COLUMN fina.fu_trade_info.open_time IS '开仓时间';
COMMENT ON COLUMN fina.fu_trade_info.close_at IS '平仓点位';
COMMENT ON COLUMN fina.fu_trade_info.close_time IS '平仓时间';
COMMENT ON COLUMN fina.fu_trade_info.cur_status IS '状态:1.持有中,2.以平仓';
COMMENT ON COLUMN fina.fu_trade_info.max_at IS '最大值';
COMMENT ON COLUMN fina.fu_trade_info.min_at IS '最小值';
COMMENT ON COLUMN fina.fu_trade_info.create_by IS '创建人';
COMMENT ON COLUMN fina.fu_trade_info.create_time IS '创建时间';
COMMENT ON COLUMN fina.fu_trade_info.update_by IS '更新人';
COMMENT ON COLUMN fina.fu_trade_info.update_time IS '更新时间';


DROP TABLE IF EXISTS fina.fu_trade_setting;
CREATE TABLE fina.fu_trade_setting (
   id serial PRIMARY KEY,
   code varchar(255),
   name varchar(255),
   max_retreat int4,
   max_profit int4,
   cycle varchar(255),
   update_by varchar(255),
   update_time timestamp
)
;
COMMENT ON COLUMN fina.fu_trade_setting.code IS '编码';
COMMENT ON COLUMN fina.fu_trade_setting.name IS '名称';
COMMENT ON COLUMN fina.fu_trade_setting.max_retreat IS '最大回撤数';
COMMENT ON COLUMN fina.fu_trade_setting.max_profit IS '最大利润';
COMMENT ON COLUMN fina.fu_trade_setting.cycle IS '周期';
COMMENT ON COLUMN fina.fu_trade_setting.update_by IS '更新人';
COMMENT ON COLUMN fina.fu_trade_setting.update_time IS '更新时间';
COMMENT ON TABLE fina.fu_trade_setting IS '交易设置';


DROP TABLE IF EXISTS fina.sys_message_info;
CREATE TABLE fina.sys_message_info (
    id SERIAL PRIMARY KEY,
    for_code varchar(100) NOT NULL,
    for_name varchar(255) NOT NULL,
    strategy varchar(255),
    trend varchar(10) NOT NULL,
    create_by varchar(100),
    create_time timestamp,
    update_by varchar(100),
    update_time timestamp
);
COMMENT ON COLUMN fina.sys_message_info.id IS '主键';
COMMENT ON COLUMN fina.sys_message_info.for_code IS '编码';
COMMENT ON COLUMN fina.sys_message_info.for_name IS '名称';
COMMENT ON COLUMN fina.sys_message_info.strategy IS '策略';
COMMENT ON COLUMN fina.sys_message_info.trend IS '趋势';
COMMENT ON COLUMN fina.sys_message_info.create_by IS '创建人';
COMMENT ON COLUMN fina.sys_message_info.create_time IS '创建时间';
COMMENT ON COLUMN fina.sys_message_info.update_by IS '更新人';
COMMENT ON COLUMN fina.sys_message_info.update_time IS '更新时间';
COMMENT ON TABLE fina.sys_message_info IS '通知记录表';


create table if not exists fina.fu_fund_account
(
	id          bigserial,
	user_id     bigint,
	acc_name    varchar(100)   default ''::character varying,
	amount      numeric(10, 2) default 0,
	is_default  boolean        default true,
	update_time timestamp      default LOCALTIMESTAMP,
	constraint fu_fund_account_pk primary key (id)
);
comment on table fina.fu_fund_account is '用户资金账户';
comment on column fina.fu_fund_account.id is '账户ID';
comment on column fina.fu_fund_account.user_id is '用户ID';
comment on column fina.fu_fund_account.acc_name is '账户名称';
comment on column fina.fu_fund_account.amount is '账户总金额';
comment on column fina.fu_fund_account.is_default is '是否默认账户';

drop table if exists fina.fu_user_train;
create table if not exists fina.fu_user_train
(
	tra_id        bigint         not null,
	user_id       bigint,
	g_code        varchar(50),
	symbol        varchar(50),
	period        varchar(5),
	status        smallint  default 0,
	start_time    timestamp,
	finish_time   timestamp,
	fund_id       bigint,
	first_amount  numeric(10, 2) not null,
	finish_amount numeric(10, 2) not null,
	create_time   timestamp default LOCALTIMESTAMP,
	constraint fu_user_train_t_pkey primary key (tra_id)
);

comment on table fina.fu_user_train is '用户训练记录';
comment on column fina.fu_user_train.tra_id is '主键雪花ID';
comment on column fina.fu_user_train.user_id is '用户ID';
comment on column fina.fu_user_train.g_code is '商品Code';
comment on column fina.fu_user_train.symbol is '合约';
comment on column fina.fu_user_train.period is '周期';
comment on column fina.fu_user_train.status is '状态：0.未开始（默认）1.进行中 0.已结束';
comment on column fina.fu_user_train.start_time is '训练开始时间';
comment on column fina.fu_user_train.finish_time is '训练结束时间';
comment on column fina.fu_user_train.fund_id is '资金账户ID';
comment on column fina.fu_user_train.first_amount is '账户初始金额';
comment on column fina.fu_user_train.finish_amount is '账户结余金额';
comment on column fina.fu_user_train.create_time is '创建时间';


create table if not exists fina.fu_user_train_dtl
(
	trd_id      bigint    not null,
	tra_id      bigint    not null,
	trd_at      timestamp not null,
	type        smallint  not null,
	open        integer,
	direction   smallint,
	trd_num     integer,
	status      smallint,
	close       numeric(10, 2),
	create_time timestamp default LOCALTIMESTAMP,
	constraint fu_user_train_dtl_t_pkey primary key (trd_id)
);

comment on table fina.fu_user_train_dtl is '用户训练交易记录';
comment on column fina.fu_user_train_dtl.trd_id is '主键雪花ID';
comment on column fina.fu_user_train_dtl.tra_id is '训练记录ID';
comment on column fina.fu_user_train_dtl.trd_at is '开仓时间点';
comment on column fina.fu_user_train_dtl.type is '结算单标识，1.为平仓结算单';
comment on column fina.fu_user_train_dtl.open is '开仓点位';
comment on column fina.fu_user_train_dtl.direction is '开仓方向：1.多,-1.空,0.平';
comment on column fina.fu_user_train_dtl.trd_num is '开仓数量';
comment on column fina.fu_user_train_dtl.status is '状态：1.持有中, 0.已平仓';
comment on column fina.fu_user_train_dtl.close is '平仓点位';
comment on column fina.fu_user_train_dtl.create_time is '创建时间';



