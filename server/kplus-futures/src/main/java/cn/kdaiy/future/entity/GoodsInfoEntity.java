package cn.kdaiy.future.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import lombok.Data;

import java.util.Date;

/**
 * 期货商品信息 实体类。
 *
 * @author hzboy192
 * @since v1
 */
@Data
@Table(value = "fu_goods_info")
public class GoodsInfoEntity {

    /**
     * 主键
     */
    @Id(keyType = KeyType.Auto)
    private Integer id;

    /**
     * 编码
     */
    @Column(value = "CODE")
    private String code;

    /**
     * 名称
     */
    @Column(value = "NAME")
    private String name;

    /**
     * 主力编号
     */
    @Column(value = "MAIN_NUM")
    private String mainNum;

    /**
     * 主力名称
     */
    @Column(value = "MAIN_NAME")
    private String mainName;

    /**
     * 市场编码
     */
    @Column(value = "MARKET_CODE")
    private String marketCode;

    /**
     * 市场名称
     */
    @Column(value = "MARKET_NAME")
    private String marketName;

    /**
     * 启用状态：Y.启用，N.禁用
     */
    @Column(value = "IS_ENABLE")
    @JsonIgnore
    private String isEnable;

    /**
     * 更新时间
     */
    @Column(value = "UPDATE_TIME")
    @JsonIgnore
    private Date updateTime;


}
