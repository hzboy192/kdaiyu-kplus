package cn.kdaiy.future.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import lombok.Data;

/**
 * 期货bar数据列表 实体类。
 *
 * @author hzboy192
 * @since v1
 */
@Data
@Table(value = "fu_bar_info")
public class BarInfoEntity {

    /**
     * 合约编码
     */
    @Id(keyType = KeyType.Auto)
    private String code;

    /**
     * 商品编码
     */
    @Id(keyType = KeyType.Auto)
    private String gCode;

    /**
     * 周期
     */
    @Id(keyType = KeyType.Auto)
    private String cycle;

    /**
     * 时间
     */
    @Id(keyType = KeyType.Auto)
    private String date;

    /**
     * 开盘价
     */
    @Column(value = "OPEN")
    private Float open;

    /**
     * 最高盘价
     */
    @Column(value = "HIGH")
    private Float high;

    /**
     * 最低盘价
     */
    @Column(value = "LOW")
    private Float low;

    /**
     * 收盘价
     */
    @Column(value = "CLOSE")
    private Float close;

    /**
     * 成交量
     */
    @Column(value = "VOL")
    private Long vol;

    /**
     * 持仓量
     */
    @Column(value = "AMOUNT")
    private Double amount;

    /**
     * 更新时间
     */
    @Column(value = "UPDATE_TIME")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private java.util.Date updateTime;


}
