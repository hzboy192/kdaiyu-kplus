package cn.kdaiy.future.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 期货手续费 实体类。
 *
 * @author hzboy192
 * @since v1
 */
@Data
@Table(value = "fu_service_charge")
public class ServiceChargeEntity {

    /**
     * 商品编码
     */
    @Id(keyType = KeyType.Auto)
    private String goodCode;

    /**
     * 商品名称
     */
    @Column(value = "good_name")
    private String goodName;

    /**
     * 保证金%
     */
    @Column(value = "security_deposit_cent")
    private BigDecimal securityDepositCent;

    /**
     * 手续续费
     */
    @Column(value = "ser_charge")
    private BigDecimal serCharge;

    /**
     * 手续费计算类型（M.固定金额，P.百分比）
     */
    @Column(value = "ser_calc_type")
    private String serCalcType;

    /**
     * 每跳单价
     */
    @Column(value = "unit_price")
    private BigDecimal unitPrice;

    /**
     * 更新时间
     */
    @Column(value = "update_time")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;


}
