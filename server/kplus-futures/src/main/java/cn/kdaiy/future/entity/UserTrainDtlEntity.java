package cn.kdaiy.future.entity;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import com.mybatisflex.core.keygen.KeyGenerators;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 训练交易记录 实体类。
 *
 * @author hzboy192
 * @since v1
 */
@Data
@Table(value = "fu_user_train_dtl")
public class UserTrainDtlEntity {

    /**
     * 主键雪花ID
     */
    @Id(keyType = KeyType.Generator, value = KeyGenerators.flexId)
    @JsonSerialize(using = ToStringSerializer.class)
    private Long trdId;

    /**
     * 训练记录ID
     */
    @Column(value = "tra_id")
    private Long traId;

    /**
     * 开仓时间点
     */
    @Column(value = "trd_at")
    private Date trdAt;

    /**
     * 结算单标识，1.为平仓结算单
     */
    @Column(value = "type")
    private Integer type;

    /**
     * 开仓点位
     */
    @Column(value = "open")
    private BigDecimal open;

    /**
     * 开仓方向：1.多,-1.空,0.平
     */
    @Column(value = "direction")
    private Integer direction;

    /**
     * 开仓数量
     */
    @Column(value = "trd_num")
    private Integer trdNum;

    /**
     * 状态：1.持有中, 0.已平仓
     */
    @Column(value = "status")
    private Integer status;

    /**
     * 平仓点位
     */
    @Column(value = "close")
    private Integer close;

    /**
     * 手续费金额
     */
    @Column(value = "ser_amount")
    private BigDecimal serAmount;

    /**
     * 收益金额
     */
    @Column(value = "income")
    private BigDecimal income;

    /**
     * 创建时间
     */
    @Column(value = "create_time")
    private Date createTime;

}
