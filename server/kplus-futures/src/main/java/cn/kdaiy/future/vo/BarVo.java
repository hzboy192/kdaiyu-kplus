package cn.kdaiy.future.vo;

import lombok.Data;

import java.io.Serializable;

@Data
public class BarVo implements Serializable {
    private static final long serialVersionUID = 92348293840234L;
    private String symbol;
    private String period;
    // 时间戳，毫秒级别，必要字段
    private Long timestamp;
    // 开盘价，必要字段
    private Float open;
    // 收盘价，必要字段
    private Float close;
    // 最高价，必要字段
    private Float high;
    // 最低价，必要字段
    private Float low;
    // 成交量，非必须字段
    private Long volume;
    // 成交额，非必须字段，如果需要展示技术指标'EMV'和'AVP'，则需要为该字段填充数据。
    private Float turnover;
}
