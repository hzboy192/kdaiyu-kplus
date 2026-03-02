package cn.kdaiy.future.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 合约配置信息
 * 手续费/保障金/交易规则...
 *
 * @author francis
 * @date 2024/12/26 11:36:15
 * @version v1.0
 */
@Data
public class SymbolInfoVo implements Serializable {
    /**
     * 商品编码
     */
    private String goodCode;

    /**
     * 商品名称
     */
    private String goodName;

    /**
     * 合约编码
     */
    private String symbol;

    /**
     * 保证金%
     */
    private BigDecimal securityDepositCent;

    /**
     * 手续续费
     */
    private BigDecimal serCharge;

    /**
     * 手续费计算类型（M.固定金额，P.百分比）
     */
    private String serCalcType;

    /**
     * 每跳单价
     */
    private BigDecimal unitPrice;

    /**
     * 合约数据最早时间
     */
    private Date fromTime;

    /**
     * 合约数据最晚时间
     */
    private Date endTime;
}
