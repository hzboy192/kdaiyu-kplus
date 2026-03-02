package cn.kdaiy.future.entity;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.RelationOneToMany;
import com.mybatisflex.annotation.Table;
import com.mybatisflex.core.keygen.KeyGenerators;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 用户训练记录 实体类。
 *
 * @author hzboy192
 * @since v1
 */
@Data
@Table(value = "fu_user_train")
public class UserTrainEntity {

    /**
     * 主键雪花ID
     */
    @Id(keyType = KeyType.Generator, value = KeyGenerators.flexId)
    @JsonSerialize(using = ToStringSerializer.class)
    private Long traId;

    /**
     * 用户ID
     */
    @Column(value = "user_id")
    private Long userId;

    /**
     * 商品Code
     */
    @Column(value = "g_code")
    private String goodCode;

    /**
     * 合约
     */
    @Column(value = "symbol")
    private String symbol;

    /**
     * 周期
     */
    @Column(value = "period")
    private String period;

    /**
     * 状态：0.未开始（默认）1.进行中 0.已结束
     */
    @Column(value = "status")
    private Integer status;

    /**
     * 训练开始时间
     */
    @Column(value = "start_time")
    private Date startTime;

    /**
     * 训练结束时间
     */
    @Column(value = "finish_time")
    private Date finishTime;

    /**
     * 账户初始金额
     */
    @Column(value = "first_amount")
    private BigDecimal firstAmount;

    /**
     * 账户结余金额
     */
    @Column(value = "finish_amount")
    private BigDecimal finishAmount;

    /**
     * 资金账户ID
     */
    @Column(value = "fund_id")
    private Long fundId;

    /**
     * 手续费单价
     */
    @Column(value = "ser_charge")
    private BigDecimal serCharge;

    /**
     * 每手单价
     */
    @Column(value = "unit_price")
    private BigDecimal unitPrice;

    /**
     * 创建时间
     */
    @Column(value = "create_time")
    private Date createTime;


    /**
     * 寻猎记录列表
     */
    @RelationOneToMany(selfField = "traId", targetField = "traId")
    private List<UserTrainDtlEntity> dtlList;

}
