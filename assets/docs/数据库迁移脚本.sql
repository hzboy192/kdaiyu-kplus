-- 期货交易模拟训练平台 - 个性化与社区功能数据库迁移脚本
-- 版本：V1.0
-- 创建时间：2025-12-11

-- 注意：本脚本适用于MySQL数据库，如需适配PostgreSQL请调整语法

-- ============================================
-- 第一部分：用户中心功能相关表
-- ============================================

-- 1. 用户扩展信息表
CREATE TABLE IF NOT EXISTS `fu_user_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `introduction` text COMMENT '个人简介',
  `trading_experience` varchar(50) DEFAULT NULL COMMENT '交易经验(新手/入门/熟练/专家)',
  `investment_style` varchar(50) DEFAULT NULL COMMENT '投资风格(保守/稳健/激进)',
  `risk_tolerance` varchar(50) DEFAULT NULL COMMENT '风险承受能力(低/中/高)',
  `favorite_products` text COMMENT '关注商品列表(JSON格式)',
  `notification_settings` json DEFAULT NULL COMMENT '通知设置',
  `privacy_settings` json DEFAULT NULL COMMENT '隐私设置',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户扩展信息表';

-- 2. 用户登录记录表
CREATE TABLE IF NOT EXISTS `fu_user_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `login_ip` varchar(50) DEFAULT NULL COMMENT '登录IP',
  `login_location` varchar(100) DEFAULT NULL COMMENT '登录地点',
  `login_device` varchar(200) DEFAULT NULL COMMENT '登录设备',
  `login_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
  `logout_time` datetime DEFAULT NULL COMMENT '登出时间',
  `session_duration` int DEFAULT NULL COMMENT '会话时长(秒)',
  `login_status` tinyint DEFAULT '1' COMMENT '登录状态(1成功 0失败)',
  `fail_reason` varchar(200) DEFAULT NULL COMMENT '失败原因',
  PRIMARY KEY (`id`),
  KEY `idx_user_id_time` (`user_id`,`login_time`),
  KEY `idx_login_time` (`login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户登录记录表';

-- 3. 用户收藏表
CREATE TABLE IF NOT EXISTS `fu_user_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `favorite_type` varchar(50) NOT NULL COMMENT '收藏类型(strategy/commodity/user/topic)',
  `target_id` bigint NOT NULL COMMENT '目标ID',
  `target_name` varchar(200) DEFAULT NULL COMMENT '目标名称',
  `tags` varchar(500) DEFAULT NULL COMMENT '标签',
  `notes` text COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_type_target` (`user_id`,`favorite_type`,`target_id`),
  KEY `idx_user_type` (`user_id`,`favorite_type`),
  KEY `idx_target` (`favorite_type`,`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户收藏表';

-- ============================================
-- 第二部分：交易统计功能相关表
-- ============================================

-- 4. 用户交易统计表
CREATE TABLE IF NOT EXISTS `fu_user_trade_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `statistic_date` date NOT NULL COMMENT '统计日期',
  `period_type` varchar(20) DEFAULT NULL COMMENT '统计周期(daily/weekly/monthly/total)',
  `total_trades` int DEFAULT '0' COMMENT '总交易次数',
  `winning_trades` int DEFAULT '0' COMMENT '盈利交易次数',
  `losing_trades` int DEFAULT '0' COMMENT '亏损交易次数',
  `win_rate` decimal(5,2) DEFAULT '0.00' COMMENT '胜率(%)',
  `total_profit` decimal(20,4) DEFAULT '0.0000' COMMENT '总盈利',
  `total_loss` decimal(20,4) DEFAULT '0.0000' COMMENT '总亏损',
  `net_profit` decimal(20,4) DEFAULT '0.0000' COMMENT '净利润',
  `profit_factor` decimal(10,2) DEFAULT '0.00' COMMENT '盈利因子',
  `max_drawdown` decimal(10,2) DEFAULT '0.00' COMMENT '最大回撤(%)',
  `avg_profit_per_trade` decimal(20,4) DEFAULT '0.0000' COMMENT '平均每笔盈利',
  `avg_loss_per_trade` decimal(20,4) DEFAULT '0.0000' COMMENT '平均每笔亏损',
  `risk_reward_ratio` decimal(10,2) DEFAULT '0.00' COMMENT '风险回报比',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_date_period` (`user_id`,`statistic_date`,`period_type`),
  KEY `idx_user_period` (`user_id`,`period_type`),
  KEY `idx_date_period` (`statistic_date`,`period_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户交易统计表';

-- 5. 收益排行榜表
CREATE TABLE IF NOT EXISTS `fu_profit_ranking` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `ranking_date` date NOT NULL COMMENT '榜单日期',
  `period_type` varchar(20) NOT NULL COMMENT '榜单周期(daily/weekly/monthly/total)',
  `rank_position` int NOT NULL COMMENT '排名位置',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `nick_name` varchar(100) DEFAULT NULL COMMENT '用户昵称',
  `avatar` varchar(500) DEFAULT NULL COMMENT '用户头像',
  `profit_amount` decimal(20,4) DEFAULT '0.0000' COMMENT '收益金额',
  `profit_rate` decimal(10,2) DEFAULT '0.00' COMMENT '收益率(%)',
  `win_rate` decimal(5,2) DEFAULT '0.00' COMMENT '胜率(%)',
  `total_trades` int DEFAULT '0' COMMENT '交易次数',
  `ranking_score` decimal(10,2) DEFAULT '0.00' COMMENT '排名分数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_date_period` (`ranking_date`,`period_type`),
  KEY `idx_user_period` (`user_id`,`period_type`),
  KEY `idx_rank_position` (`period_type`,`ranking_date`,`rank_position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='收益排行榜表';

-- 6. 交易分析报告表
CREATE TABLE IF NOT EXISTS `fu_trade_analysis_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `report_type` varchar(50) DEFAULT NULL COMMENT '报告类型(weekly/monthly/quarterly/custom)',
  `report_date` date DEFAULT NULL COMMENT '报告日期',
  `report_title` varchar(200) DEFAULT NULL COMMENT '报告标题',
  `report_content` json DEFAULT NULL COMMENT '报告内容(JSON格式)',
  `summary` text COMMENT '总结',
  `suggestions` text COMMENT '改进建议',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '是否已读',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_type_date` (`user_id`,`report_type`,`report_date`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='交易分析报告表';

-- ============================================
-- 第三部分：社区交流功能相关表
-- ============================================

-- 7. 社区帖子表
CREATE TABLE IF NOT EXISTS `fu_community_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_type` varchar(50) NOT NULL COMMENT '帖子类型(achievement/strategy/question/discussion)',
  `title` varchar(200) DEFAULT NULL COMMENT '帖子标题',
  `content` text NOT NULL COMMENT '帖子内容',
  `images` json DEFAULT NULL COMMENT '图片列表',
  `tags` varchar(500) DEFAULT NULL COMMENT '标签',
  `view_count` int DEFAULT '0' COMMENT '浏览数',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  `comment_count` int DEFAULT '0' COMMENT '评论数',
  `share_count` int DEFAULT '0' COMMENT '分享数',
  `is_top` tinyint(1) DEFAULT '0' COMMENT '是否置顶',
  `is_essence` tinyint(1) DEFAULT '0' COMMENT '是否精华',
  `visibility` varchar(20) DEFAULT 'public' COMMENT '可见性(public/friends/private)',
  `status` varchar(20) DEFAULT 'published' COMMENT '状态(published/draft/deleted)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_type` (`user_id`,`post_type`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_hot` (`like_count`,`comment_count`,`create_time`),
  KEY `idx_tags` (`tags`(255)),
  FULLTEXT KEY `ft_title_content` (`title`,`content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区帖子表';

-- 8. 社区评论表
CREATE TABLE IF NOT EXISTS `fu_community_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `parent_id` bigint DEFAULT '0' COMMENT '父评论ID',
  `content` text NOT NULL COMMENT '评论内容',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  `reply_count` int DEFAULT '0' COMMENT '回复数',
  `is_author` tinyint(1) DEFAULT '0' COMMENT '是否楼主回复',
  `status` varchar(20) DEFAULT 'normal' COMMENT '状态(normal/deleted)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区评论表';

-- 9. 用户关注关系表
CREATE TABLE IF NOT EXISTS `fu_user_follow` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `follower_id` bigint NOT NULL COMMENT '关注者ID',
  `following_id` bigint NOT NULL COMMENT '被关注者ID',
  `follow_type` varchar(20) DEFAULT 'normal' COMMENT '关注类型(normal/mutual)',
  `notes` varchar(200) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_follower_following` (`follower_id`,`following_id`),
  KEY `idx_follower` (`follower_id`),
  KEY `idx_following` (`following_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户关注关系表';

-- 10. 社区话题表
CREATE TABLE IF NOT EXISTS `fu_community_topic` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `topic_name` varchar(100) NOT NULL COMMENT '话题名称',
  `description` text COMMENT '话题描述',
  `icon` varchar(500) DEFAULT NULL COMMENT '话题图标',
  `post_count` int DEFAULT '0' COMMENT '帖子数',
  `follower_count` int DEFAULT '0' COMMENT '关注者数',
  `is_recommended` tinyint(1) DEFAULT '0' COMMENT '是否推荐',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` varchar(20) DEFAULT 'active' COMMENT '状态(active/inactive)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_topic_name` (`topic_name`),
  KEY `idx_sort` (`sort_order`),
  KEY `idx_recommended` (`is_recommended`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区话题表';

-- ============================================
-- 第四部分：高阶付费功能相关表
-- ============================================

-- 11. 会员等级表
CREATE TABLE IF NOT EXISTS `fu_member_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `level_name` varchar(50) NOT NULL COMMENT '等级名称',
  `level_code` varchar(20) NOT NULL COMMENT '等级代码',
  `description` text COMMENT '等级描述',
  `price_monthly` decimal(10,2) DEFAULT NULL COMMENT '月费价格',
  `price_quarterly` decimal(10,2) DEFAULT NULL COMMENT '季费价格',
  `price_yearly` decimal(10,2) DEFAULT NULL COMMENT '年费价格',
  `features` json DEFAULT NULL COMMENT '功能权限(JSON格式)',
  `max_strategies` int DEFAULT '10' COMMENT '最大策略数',
  `max_data_replay` int DEFAULT '5' COMMENT '最大数据回放次数',
  `ai_analysis` tinyint(1) DEFAULT '0' COMMENT 'AI分析功能',
  `priority_support` tinyint(1) DEFAULT '0' COMMENT '优先支持',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否激活',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_code` (`level_code`),
  KEY `idx_sort` (`sort_order`),
  KEY `idx_active` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员等级表';

-- 12. 用户会员表
CREATE TABLE IF NOT EXISTS `fu_user_membership` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `level_id` bigint NOT NULL COMMENT '等级ID',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `payment_amount` decimal(10,2) DEFAULT NULL COMMENT '支付金额',
  `payment_method` varchar(50) DEFAULT NULL COMMENT '支付方式',
  `transaction_id` varchar(100) DEFAULT NULL COMMENT '交易ID',
  `auto_renew` tinyint(1) DEFAULT '1' COMMENT '自动续费',
  `status` varchar(20) DEFAULT 'active' COMMENT '状态(active/expired/cancelled)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_status` (`user_id`,`status`),
  KEY `idx_end_time` (`end_time`),
  KEY `idx_transaction` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户会员表';

-- 13. 积分账户表
CREATE TABLE IF NOT EXISTS `fu_points_account` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_points` int DEFAULT '0' COMMENT '总积分',
  `available_points` int DEFAULT '0' COMMENT '可用积分',
  `frozen_points` int DEFAULT '0' COMMENT '冻结积分',
  `level_points` int DEFAULT '0' COMMENT '等级积分',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  KEY `idx_points` (`available_points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='积分账户表';

-- 14. 积分流水表
CREATE TABLE IF NOT EXISTS `fu_points_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `transaction_type` varchar(50) NOT NULL COMMENT '交易类型(earn/consume/transfer)',
  `points_change` int NOT NULL COMMENT '积分变动',
  `current_points` int DEFAULT NULL COMMENT '当前积分',
  `description` varchar(200) DEFAULT NULL COMMENT '描述',
  `reference_type` varchar(50) DEFAULT NULL COMMENT '关联类型',
  `reference_id` bigint DEFAULT NULL COMMENT '关联ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_time` (`user_id`,`create_time`),
  KEY `idx_reference` (`reference_type`,`reference_id`),
  KEY `idx_type_time` (`transaction_type`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='积分流水表';

-- 15. 虚拟商品表
CREATE TABLE IF NOT EXISTS `fu_virtual_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `goods_name` varchar(100) NOT NULL COMMENT '商品名称',
  `goods_type` varchar(50) DEFAULT NULL COMMENT '商品类型(strategy_template/data_pack/training_course)',
  `description` text COMMENT '商品描述',
  `cover_image` varchar(500) DEFAULT NULL COMMENT '封面图片',
  `price_points` int NOT NULL COMMENT '价格(积分)',
  `original_price` decimal(10,2) DEFAULT NULL COMMENT '原价(人民币)',
  `stock_quantity` int DEFAULT '-1' COMMENT '库存数量(-1表示无限)',
  `sales_count` int DEFAULT '0' COMMENT '销售数量',
  `is_recommended` tinyint(1) DEFAULT '0' COMMENT '是否推荐',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` varchar(20) DEFAULT 'active' COMMENT '状态(active/inactive)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_type_status` (`goods_type`,`status`),
  KEY `idx_sort` (`sort_order`),
  KEY `idx_recommended` (`is_recommended`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='虚拟商品表';

-- ============================================
-- 第五部分：初始化数据
-- ============================================

-- 初始化会员等级数据
INSERT INTO `fu_member_level` (`level_name`, `level_code`, `description`, `price_monthly`, `price_quarterly`, `price_yearly`, `features`, `max_strategies`, `max_data_replay`, `ai_analysis`, `priority_support`, `sort_order`, `is_active`) VALUES
('免费用户', 'free', '基础功能，适合新手体验', 0.00, 0.00, 0.00, '["基础交易模拟", "基础统计", "社区浏览"]', 3, 1, 0, 0, 1, 1),
('基础会员', 'basic', '适合日常训练用户', 29.90, 79.90, 299.00, '["高级交易模拟", "详细统计", "社区发帖", "基础策略"]', 10, 5, 0, 0, 2, 1),
('高级会员', 'premium', '适合专业交易者', 99.90, 269.90, 999.00, '["专业交易工具", "AI分析", "数据回放", "高级策略", "专属指导"]', 30, 20, 1, 1, 3, 1),
('专业会员', 'professional', '适合机构用户', 299.90, 799.90, 2999.00, '["全部功能", "团队管理", "API接口", "定制服务", "7x24支持"]', 100, 100, 1, 1, 4, 1);

-- 初始化社区话题数据
INSERT INTO `fu_community_topic` (`topic_name`, `description`, `icon`, `post_count`, `follower_count`, `is_recommended`, `sort_order`, `status`) VALUES
('交易心得', '分享交易经验和心得体会', NULL, 0, 0, 1, 1, 'active'),
('策略分享', '交易策略和技术分析分享', NULL, 0, 0, 1, 2, 'active'),
('新手入门', '新手学习交流区', NULL, 0, 0, 1, 3, 'active'),
('行情讨论', '市场行情分析和讨论', NULL, 0, 0, 1, 4, 'active'),
('技术分析', '技术指标和图表分析', NULL, 0, 0, 0, 5, 'active'),
('风险控制', '风险管理和资金管理', NULL, 0, 0, 0, 6, 'active'),
('模拟比赛', '模拟交易比赛和交流', NULL, 0, 0, 0, 7, 'active'),
('平台建议', '对平台的建议和反馈', NULL, 0, 0, 0, 8, 'active');

-- 初始化虚拟商品数据
INSERT INTO `fu_virtual_goods` (`goods_name`, `goods_type`, `description`, `cover_image`, `price_points`, `original_price`, `stock_quantity`, `sales_count`, `is_recommended`, `sort_order`, `status`) VALUES
('趋势跟踪策略模板', 'strategy_template', '基于移动平均线的趋势跟踪策略模板', NULL, 500, 50.00, -1, 0, 1, 1, 'active'),
('突破交易策略模板', 'strategy_template', '基于价格突破的交易策略模板', NULL, 800, 80.00, -1, 0, 1, 2, 'active'),
('历史数据包-2024', 'data_pack', '2024年完整期货历史数据包', NULL, 1000, 100.00, -1, 0, 1, 3, 'active'),
('交易心理学课程', 'training_course', '交易心理和情绪管理课程', NULL, 1500, 150.00, -1, 0, 1, 4, 'active'),
('技术分析入门课程', 'training_course', '技术分析基础入门课程', NULL, 800, 80.00, -1, 0, 0, 5, 'active'),
('风险管理实战课程', 'training_course', '风险管理实战应用课程', NULL, 1200, 120.00, -1, 0, 0, 6, 'active');

-- ============================================
-- 第六部分：索引优化建议
-- ============================================

-- 为高频查询字段添加索引
ALTER TABLE `fu_community_post` ADD INDEX `idx_user_status_time` (`user_id`, `status`, `create_time`);
ALTER TABLE `fu_user_trade_statistics` ADD INDEX `idx_user_date` (`user_id`, `statistic_date`);
ALTER TABLE `fu_profit_ranking` ADD INDEX `idx_period_date_rank` (`period_type`, `ranking_date`, `rank_position`);
ALTER TABLE `fu_user_follow` ADD INDEX `idx_following_time` (`following_id`, `create_time`);

-- ============================================
-- 第七部分：视图创建（可选）
-- ============================================

-- 用户综合信息视图
CREATE OR REPLACE VIEW v_user_comprehensive AS
SELECT
    u.user_id,
    u.user_name,
    u.nick_name,
    u.avatar,
    u.email,
    u.phonenumber,
    u.sex,
    p.introduction,
    p.trading_experience,
    p.investment_style,
    p.risk_tolerance,
    m.level_id,
    ml.level_name,
    m.end_time as membership_end_time,
    pa.available_points,
    (SELECT COUNT(*) FROM fu_user_follow f WHERE f.follower_id = u.user_id) as following_count,
    (SELECT COUNT(*) FROM fu_user_follow f WHERE f.following_id = u.user_id) as follower_count,
    (SELECT COUNT(*) FROM fu_community_post cp WHERE cp.user_id = u.user_id AND cp.status = 'published') as post_count
FROM sys_user u
LEFT JOIN fu_user_profile p ON u.user_id = p.user_id
LEFT JOIN fu_user_membership m ON u.user_id = m.user_id AND m.status = 'active'
LEFT JOIN fu_member_level ml ON m.level_id = ml.id
LEFT JOIN fu_points_account pa ON u.user_id = pa.user_id
WHERE u.del_flag = '0' AND u.status = '0';

-- 社区热门帖子视图
CREATE OR REPLACE VIEW v_hot_posts AS
SELECT
    p.id,
    p.title,
    p.content,
    p.post_type,
    p.tags,
    p.view_count,
    p.like_count,
    p.comment_count,
    p.create_time,
    u.user_id,
    u.nick_name,
    u.avatar,
    (p.like_count * 2 + p.comment_count * 3 + p.view_count * 0.1) as hot_score
FROM fu_community_post p
JOIN sys_user u ON p.user_id = u.user_id
WHERE p.status = 'published' AND p.visibility = 'public'
ORDER BY hot_score DESC, p.create_time DESC;

-- ============================================
-- 第八部分：存储过程和函数（可选）
-- ============================================

-- 计算用户综合评分函数
DELIMITER //
CREATE FUNCTION fn_calculate_user_score(user_id BIGINT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_score DECIMAL(10,2);

    -- 交易表现评分（占60%）
    SELECT COALESCE(
        (win_rate * 0.3 +
         (CASE WHEN profit_factor > 0 THEN LEAST(profit_factor, 5) ELSE 0 END) * 0.2 +
         (CASE WHEN total_trades >= 10 THEN 1 ELSE total_trades/10 END) * 0.1) * 60,
        0
    ) INTO total_score
    FROM fu_user_trade_statistics
    WHERE user_id = user_id AND period_type = 'total'
    ORDER BY statistic_date DESC LIMIT 1;

    -- 社区贡献评分（占30%）
    SELECT total_score + COALESCE(
        (SELECT
            (COUNT(DISTINCT post_id) * 0.5 +
             COUNT(*) * 0.3 +
             SUM(like_count) * 0.2) * 30 / 100
        FROM fu_community_post
        WHERE user_id = user_id AND status = 'published'),
        0
    ) INTO total_score;

    -- 活跃度评分（占10%）
    SELECT total_score + COALESCE(
        (SELECT
            CASE
                WHEN COUNT(*) >= 30 THEN 10
                ELSE COUNT(*) * 10 / 30
            END
        FROM fu_user_login_log
        WHERE user_id = user_id AND login_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)),
        0
    ) INTO total_score;

    RETURN LEAST(total_score, 100);
END //
DELIMITER ;

-- 更新排行榜存储过程
DELIMITER //
CREATE PROCEDURE sp_update_profit_ranking(
    IN p_period_type VARCHAR(20),
    IN p_ranking_date DATE
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_user_id BIGINT;
    DECLARE v_profit_amount DECIMAL(20,4);
    DECLARE v_rank_position INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT user_id, SUM(net_profit) as total_profit
        FROM fu_user_trade_statistics
        WHERE period_type = p_period_type
          AND statistic_date = p_ranking_date
        GROUP BY user_id
        ORDER BY total_profit DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 删除旧数据
    DELETE FROM fu_profit_ranking
    WHERE period_type = p_period_type AND ranking_date = p_ranking_date;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_user_id, v_profit_amount;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_rank_position = v_rank_position + 1;

        -- 插入新排名
        INSERT INTO fu_profit_ranking (
            ranking_date, period_type, rank_position, user_id, profit_amount
        ) VALUES (
            p_ranking_date, p_period_type, v_rank_position, v_user_id, v_profit_amount
        );
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

-- ============================================
-- 第九部分：触发器（可选）
-- ============================================

-- 帖子评论数自动更新触发器
DELIMITER //
CREATE TRIGGER trg_comment_count_update
AFTER INSERT ON fu_community_comment
FOR EACH ROW
BEGIN
    UPDATE fu_community_post
    SET comment_count = comment_count + 1,
        update_time = NOW()
    WHERE id = NEW.post_id;
END //
DELIMITER ;

-- 用户关注数自动更新触发器
DELIMITER //
CREATE TRIGGER trg_follow_count_update
AFTER INSERT ON fu_user_follow
FOR EACH ROW
BEGIN
    -- 更新被关注者的粉丝数（需要额外表存储，这里仅示例）
    -- 实际实现可能需要调整
    UPDATE sys_user_stats
    SET follower_count = follower_count + 1
    WHERE user_id = NEW.following_id;
END //
DELIMITER ;

-- ============================================
-- 第十部分：数据迁移脚本（从现有系统）
-- ============================================

-- 迁移现有用户数据到用户扩展表
INSERT INTO fu_user_profile (user_id, create_time, update_time)
SELECT user_id, NOW(), NOW()
FROM sys_user
WHERE del_flag = '0' AND status = '0'
ON DUPLICATE KEY UPDATE update_time = NOW();

-- 迁移现有交易数据到统计表（示例）
INSERT INTO fu_user_trade_statistics (
    user_id, statistic_date, period_type, total_trades,
    winning_trades, losing_trades, win_rate, net_profit,
    create_time, update_time
)
SELECT
    ut.user_id,
    DATE(ut.create_time) as statistic_date,
    'daily' as period_type,
    COUNT(*) as total_trades,
    SUM(CASE WHEN utd.profit > 0 THEN 1 ELSE 0 END) as winning_trades,
    SUM(CASE WHEN utd.profit <= 0 THEN 1 ELSE 0 END) as losing_trades,
    ROUND(SUM(CASE WHEN utd.profit > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as win_rate,
    SUM(utd.profit) as net_profit,
    NOW(),
    NOW()
FROM fu_user_train ut
JOIN fu_user_train_dtl utd ON ut.id = utd.train_id
WHERE ut.status = 'completed'
GROUP BY ut.user_id, DATE(ut.create_time)
ON DUPLICATE KEY UPDATE
    total_trades = VALUES(total_trades),
    winning_trades = VALUES(winning_trades),
    losing_trades = VALUES(losing_trades),
    win_rate = VALUES(win_rate),
    net_profit = VALUES(net_profit),
    update_time = NOW();

-- ============================================
-- 完成说明
-- ============================================

-- 1. 执行顺序：按文件顺序执行即可
-- 2. 生产环境建议：先备份数据库，在测试环境验证后再上线
-- 3. 性能优化：根据实际数据量调整索引
-- 4. 监控：上线后监控慢查询，及时优化

SELECT '数据库迁移脚本执行完成' as message;