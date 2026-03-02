package cn.kdaiy.future.entity;

import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import lombok.Data;

import java.time.LocalTime;
import java.util.Date;

/**
 * 期货分钟周期映射 实体类。
 *
 * @author hzboy192
 * @since v1
 */
@Data
@Table(value = "fu_min_mapping")
public class MinMappingEntity {

    @Id(keyType = KeyType.Auto)
    private Integer id;

    /**
     * 5分钟时间
     */
    @Column(value = "cycle_5m")
    private LocalTime cycle5m;

    /**
     * 15分钟时间
     */
    @Column(value = "cycle_15m")
    private LocalTime cycle15m;

    /**
     * 20分钟时间
     */
    @Column(value = "cycle_20m")
    private LocalTime cycle20m;

    /**
     * 30分钟时间
     */
    @Column(value = "cycle_30m")
    private LocalTime cycle30m;

    /**
     * 1小时时间
     */
    @Column(value = "cycle_1h")
    private LocalTime cycle1h;

    /**
     * 2小时时间
     */
    @Column(value = "cycle_2h")
    private LocalTime cycle2h;

    /**
     * 4小时时间
     */
    @Column(value = "cycle_4h")
    private LocalTime cycle4h;

    /**
     * 日
     */
    @Column(value = "cycle_d")
    private LocalTime cycleD;

    @Column(value = "last_update_time")
    private Date lastUpdateTime;


}
