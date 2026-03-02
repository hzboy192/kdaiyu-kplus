package cn.kdaiy.future.vo;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 训练统计
 * 
 * @author: peng_hao
 * @date: 2025/1/2 16:24:03
 * @version: v1.0
 */
@Data
public class TrainSummaryVo implements Serializable {
    
    private static final long serialVersionUID = 394103741834183749L;
    
    /**
     * 训练id
     */
    @JsonSerialize(using = ToStringSerializer.class)
    private Long traId;

    /**
     * 起始金额
     */
    private BigDecimal firstAmount;

    /**
     * 结束金额
     */
    private BigDecimal finishAmount;

    /**
     * 总利润
     */
    private BigDecimal totalProfit;

    /**
     * 总亏损
     */
    private BigDecimal totalLoss;

    /**
     * 盈亏比
     */
    private BigDecimal profitLossRatio;

    /**
     * 最大盈利
     */
    private BigDecimal maxProfit;

    /**
     * 最大亏损
     */
    private BigDecimal maxLoss;

    /**
     * 总手续费
     */
    private BigDecimal totalFee;

    /**
     * 开仓次数
     */
    private Integer openTimes;

    /**
     * 盈利次数
     */
    private Integer profitTimes;

    /**
     * 亏损次数
     */
    private Integer lossTimes;
}
