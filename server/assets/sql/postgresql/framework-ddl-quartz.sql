DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

create table qrtz_calendars
(
    sched_name    varchar(120) not null,
    calendar_name varchar(200) not null,
    calendar      bytea        not null,
    primary key (sched_name, calendar_name)
);
comment on table qrtz_calendars is '日历信息表';
comment on column qrtz_calendars.sched_name is '调度名称';
comment on column qrtz_calendars.calendar_name is '日历名称';
comment on column qrtz_calendars.calendar is '存放持久化calendar对象';


create table qrtz_fired_triggers
(
    sched_name        varchar(120) not null,
    entry_id          varchar(95)  not null,
    trigger_name      varchar(200) not null,
    trigger_group     varchar(200) not null,
    instance_name     varchar(200) not null,
    fired_time        bigint       not null,
    sched_time        bigint       not null,
    priority          integer      not null,
    state             varchar(16)  not null,
    job_name          varchar(200),
    job_group         varchar(200),
    is_nonconcurrent  varchar(20),
    requests_recovery varchar(20),
    primary key (sched_name, entry_id)
);
comment on table qrtz_fired_triggers is '已触发的触发器表';
comment on column qrtz_fired_triggers.sched_name is '调度名称';
comment on column qrtz_fired_triggers.entry_id is '调度器实例id';
comment on column qrtz_fired_triggers.trigger_name is 'qrtz_triggers表trigger_name的外键';
comment on column qrtz_fired_triggers.trigger_group is 'qrtz_triggers表trigger_group的外键';
comment on column qrtz_fired_triggers.instance_name is '调度器实例名';
comment on column qrtz_fired_triggers.fired_time is '触发的时间';
comment on column qrtz_fired_triggers.sched_time is '定时器制定的时间';
comment on column qrtz_fired_triggers.priority is '优先级';
comment on column qrtz_fired_triggers.state is '状态';
comment on column qrtz_fired_triggers.job_name is '任务名称';
comment on column qrtz_fired_triggers.job_group is '任务组名';
comment on column qrtz_fired_triggers.is_nonconcurrent is '是否并发';
comment on column qrtz_fired_triggers.requests_recovery is '是否接受恢复执行';


create table qrtz_job_details
(
    sched_name        varchar(120) not null,
    job_name          varchar(200) not null,
    job_group         varchar(200) not null,
    description       varchar(250),
    job_class_name    varchar(250) not null,
    is_durable        varchar(50)  not null,
    is_nonconcurrent  varchar(50)  not null,
    is_update_data    varchar(50)  not null,
    requests_recovery varchar(50)  not null,
    job_data          bytea,
    primary key (sched_name, job_name, job_group)
);

comment on table qrtz_job_details is '任务详细信息表';
comment on column qrtz_job_details.sched_name is '调度名称';
comment on column qrtz_job_details.job_name is '任务名称';
comment on column qrtz_job_details.job_group is '任务组名';
comment on column qrtz_job_details.description is '相关介绍';
comment on column qrtz_job_details.job_class_name is '执行任务类名称';
comment on column qrtz_job_details.is_durable is '是否持久化';
comment on column qrtz_job_details.is_nonconcurrent is '是否并发';
comment on column qrtz_job_details.is_update_data is '是否更新数据';
comment on column qrtz_job_details.requests_recovery is '是否接受恢复执行';
comment on column qrtz_job_details.job_data is '存放持久化job对象';


create table qrtz_locks
(
    sched_name varchar(120) not null,
    lock_name  varchar(40)  not null,
    primary key (sched_name, lock_name)
);

comment on table qrtz_locks is '存储的悲观锁信息表';
comment on column qrtz_locks.sched_name is '调度名称';
comment on column qrtz_locks.lock_name is '悲观锁名称';


create table qrtz_paused_trigger_grps
(
    sched_name    varchar(120) not null,
    trigger_group varchar(200) not null,
    primary key (sched_name, trigger_group)
);

comment on table qrtz_paused_trigger_grps is '暂停的触发器表';
comment on column qrtz_paused_trigger_grps.sched_name is '调度名称';
comment on column qrtz_paused_trigger_grps.trigger_group is 'qrtz_triggers表trigger_group的外键';


create table qrtz_scheduler_state
(
    sched_name        varchar(120) not null,
    instance_name     varchar(200) not null,
    last_checkin_time bigint       not null,
    checkin_interval  bigint       not null,
    primary key (sched_name, instance_name)
);

comment on table qrtz_scheduler_state is '调度器状态表';
comment on column qrtz_scheduler_state.sched_name is '调度名称';
comment on column qrtz_scheduler_state.instance_name is '实例名称';
comment on column qrtz_scheduler_state.last_checkin_time is '上次检查时间';
comment on column qrtz_scheduler_state.checkin_interval is '检查间隔时间';


create table qrtz_triggers
(
    sched_name     varchar(120) not null,
    trigger_name   varchar(200) not null,
    trigger_group  varchar(200) not null,
    job_name       varchar(200) not null,
    job_group      varchar(200) not null,
    description    varchar(250),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority       integer,
    trigger_state  varchar(16)  not null,
    trigger_type   varchar(8)   not null,
    start_time     bigint       not null,
    end_time       bigint,
    calendar_name  varchar(200),
    misfire_instr  smallint,
    job_data       bytea,
    primary key (sched_name, trigger_name, trigger_group),
    constraint qrtz_triggers_ibfk_1
        foreign key (sched_name, job_name, job_group) references qrtz_job_details
);

comment on table qrtz_triggers is '触发器详细信息表';
comment on column qrtz_triggers.sched_name is '调度名称';
comment on column qrtz_triggers.trigger_name is '触发器的名字';
comment on column qrtz_triggers.trigger_group is '触发器所属组的名字';
comment on column qrtz_triggers.job_name is 'qrtz_job_details表job_name的外键';
comment on column qrtz_triggers.job_group is 'qrtz_job_details表job_group的外键';
comment on column qrtz_triggers.description is '相关介绍';
comment on column qrtz_triggers.next_fire_time is '上一次触发时间（毫秒）';
comment on column qrtz_triggers.prev_fire_time is '下一次触发时间（默认为-1表示不触发）';
comment on column qrtz_triggers.priority is '优先级';
comment on column qrtz_triggers.trigger_state is '触发器状态';
comment on column qrtz_triggers.trigger_type is '触发器的类型';
comment on column qrtz_triggers.start_time is '开始时间';
comment on column qrtz_triggers.end_time is '结束时间';
comment on column qrtz_triggers.calendar_name is '日程表名称';
comment on column qrtz_triggers.misfire_instr is '补偿执行的策略';
comment on column qrtz_triggers.job_data is '存放持久化job对象';


create table qrtz_blob_triggers
(
    sched_name    varchar(120) not null,
    trigger_name  varchar(200) not null,
    trigger_group varchar(200) not null,
    blob_data     bytea,
    primary key (sched_name, trigger_name, trigger_group),
    constraint qrtz_blob_triggers_ibfk_1
        foreign key (sched_name, trigger_name, trigger_group) references qrtz_triggers
);

comment on table qrtz_blob_triggers is 'Blob类型的触发器表';
comment on column qrtz_blob_triggers.sched_name is '调度名称';
comment on column qrtz_blob_triggers.trigger_name is 'qrtz_triggers表trigger_name的外键';
comment on column qrtz_blob_triggers.trigger_group is 'qrtz_triggers表trigger_group的外键';
comment on column qrtz_blob_triggers.blob_data is '存放持久化Trigger对象';


create table qrtz_cron_triggers
(
    sched_name      varchar(120) not null,
    trigger_name    varchar(200) not null,
    trigger_group   varchar(200) not null,
    cron_expression varchar(200) not null,
    time_zone_id    varchar(80),
    primary key (sched_name, trigger_name, trigger_group),
    constraint qrtz_cron_triggers_ibfk_1
        foreign key (sched_name, trigger_name, trigger_group) references qrtz_triggers
);

comment on table qrtz_cron_triggers is 'Cron类型的触发器表';
comment on column qrtz_cron_triggers.sched_name is '调度名称';
comment on column qrtz_cron_triggers.trigger_name is 'qrtz_triggers表trigger_name的外键';
comment on column qrtz_cron_triggers.trigger_group is 'qrtz_triggers表trigger_group的外键';
comment on column qrtz_cron_triggers.cron_expression is 'cron表达式';
comment on column qrtz_cron_triggers.time_zone_id is '时区';


create table qrtz_simple_triggers
(
    sched_name      varchar(120) not null,
    trigger_name    varchar(200) not null,
    trigger_group   varchar(200) not null,
    repeat_count    bigint       not null,
    repeat_interval bigint       not null,
    times_triggered bigint       not null,
    primary key (sched_name, trigger_name, trigger_group),
    constraint qrtz_simple_triggers_ibfk_1
        foreign key (sched_name, trigger_name, trigger_group) references qrtz_triggers
);

comment on table qrtz_simple_triggers is '简单触发器的信息表';
comment on column qrtz_simple_triggers.sched_name is '调度名称';
comment on column qrtz_simple_triggers.trigger_name is 'qrtz_triggers表trigger_name的外键';
comment on column qrtz_simple_triggers.trigger_group is 'qrtz_triggers表trigger_group的外键';
comment on column qrtz_simple_triggers.repeat_count is '重复的次数统计';
comment on column qrtz_simple_triggers.repeat_interval is '重复的间隔时间';
comment on column qrtz_simple_triggers.times_triggered is '已经触发的次数';


create table qrtz_simprop_triggers
(
    sched_name    varchar(120) not null,
    trigger_name  varchar(200) not null,
    trigger_group varchar(200) not null,
    str_prop_1    varchar(512),
    str_prop_2    varchar(512),
    str_prop_3    varchar(512),
    int_prop_1    integer,
    int_prop_2    integer,
    long_prop_1   bigint,
    long_prop_2   bigint,
    dec_prop_1    numeric(13, 4),
    dec_prop_2    numeric(13, 4),
    bool_prop_1   varchar(2),
    bool_prop_2   varchar(2),
    primary key (sched_name, trigger_name, trigger_group),
    constraint qrtz_simprop_triggers_ibfk_1
        foreign key (sched_name, trigger_name, trigger_group) references qrtz_triggers
);
comment on table qrtz_simprop_triggers is '同步机制的行锁表';
comment on column qrtz_simprop_triggers.sched_name is '调度名称';
comment on column qrtz_simprop_triggers.trigger_name is 'qrtz_triggers表trigger_name的外键';
comment on column qrtz_simprop_triggers.trigger_group is 'qrtz_triggers表trigger_group的外键';
comment on column qrtz_simprop_triggers.str_prop_1 is 'String类型的trigger的第一个参数';
comment on column qrtz_simprop_triggers.str_prop_2 is 'String类型的trigger的第二个参数';
comment on column qrtz_simprop_triggers.str_prop_3 is 'String类型的trigger的第三个参数';
comment on column qrtz_simprop_triggers.int_prop_1 is 'int类型的trigger的第一个参数';
comment on column qrtz_simprop_triggers.int_prop_2 is 'int类型的trigger的第二个参数';
comment on column qrtz_simprop_triggers.long_prop_1 is 'long类型的trigger的第一个参数';
comment on column qrtz_simprop_triggers.long_prop_2 is 'long类型的trigger的第二个参数';
comment on column qrtz_simprop_triggers.dec_prop_1 is 'decimal类型的trigger的第一个参数';
comment on column qrtz_simprop_triggers.dec_prop_2 is 'decimal类型的trigger的第二个参数';
comment on column qrtz_simprop_triggers.bool_prop_1 is 'Boolean类型的trigger的第一个参数';
comment on column qrtz_simprop_triggers.bool_prop_2 is 'Boolean类型的trigger的第二个参数';


create index sched_name on qrtz_triggers (sched_name, job_name, job_group);

