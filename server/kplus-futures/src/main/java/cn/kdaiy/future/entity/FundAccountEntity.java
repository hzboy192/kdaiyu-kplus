package cn.kdaiy.future.entity;

import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 用户资金账户 实体类。
 *
 * @author hzboy192
 * @since v1
 */
@Data
@Table(value = "fu_fund_account")
public class FundAccountEntity {

    /**
     * 账户ID
     */
    @Id(keyType = KeyType.Auto)
    private Long id;

    /**
     * 用户ID
     */
    @Column(value = "user_id")
    private Long userId;

    /**
     * 账户名称
     */
    @Column(value = "acc_name")
    private String accName;

    /**
     * 账户总金额
     */
    @Column(value = "amount")
    private BigDecimal amount;

    /**
     * 是否默认账户
     */
    @Column(value = "is_default")
    private Boolean isDefault;

    @Column(value = "update_time")
    private Date updateTime;


}
