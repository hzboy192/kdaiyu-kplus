package cn.kdaiy.future.service.impl;


import cn.hutool.core.bean.BeanUtil;
import cn.kdaiy.future.entity.BarInfoEntity;
import cn.kdaiy.future.entity.table.BarInfoEntityTableDef;
import cn.kdaiy.future.entity.table.MinMappingEntityTableDef;
import cn.kdaiy.future.mapper.BarInfoMapper;
import cn.kdaiy.future.service.BarInfoService;
import cn.kdaiy.future.vo.BarVo;
import cn.kdaiy.future.vo.SearchVo;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static cn.kdaiy.future.entity.table.BarInfoEntityTableDef.BAR_INFO_ENTITY;
import static cn.kdaiy.future.entity.table.MinMappingEntityTableDef.MIN_MAPPING_ENTITY;
import static com.mybatisflex.core.query.QueryMethods.column;
import static com.mybatisflex.core.query.QueryMethods.select;
import static com.mybatisflex.core.query.QueryMethods.string;

/**
 * 期货bar数据列表 服务层实现。
 *
 * @author hzboy192
 * @since v1
 */
@Service
public class BarInfoServiceImpl extends ServiceImpl<BarInfoMapper, BarInfoEntity> implements BarInfoService {

    private final BarInfoEntityTableDef bar = BAR_INFO_ENTITY.as("b");

    private final MinMappingEntityTableDef mp = MIN_MAPPING_ENTITY.as("mp");

    @Override
    public QueryWrapper query() {
        return super.query().from(bar);
    }

    @Override
    public Page<BarInfoEntity> page(Page<BarInfoEntity> page, BarInfoEntity entity) {
        return this.mapper.xmlPaginate("selectBarList", page, null, BeanUtil.beanToMap(entity, false, true));
    }

    @Override
    public List<BarVo> getHistoryBars(SearchVo svo) {
        if (StringUtils.equalsIgnoreCase(svo.getPeriod(), "D") || StringUtils.equalsIgnoreCase(svo.getPeriod(), "5M")) {
            return mapper.selectHistoryBar(svo);
        } else if (StringUtils.endsWithIgnoreCase(svo.getPeriod(), "M") || StringUtils.endsWithIgnoreCase(svo.getPeriod(), "H")) {
            return mapper.selectHistoryBarForMinute(svo);
        } else if (StringUtils.endsWithIgnoreCase(svo.getPeriod(), "W")) {
            return mapper.selectHistoryBarForWeek(svo);
        }
        return new ArrayList<>();
    }

    @Override
    public List<BarVo> getBarList(SearchVo svo) {
        if (StringUtils.equalsIgnoreCase(svo.getPeriod(), "D") || StringUtils.equalsIgnoreCase(svo.getPeriod(), "5M")) {
            return getRealBarList(svo);
        } else if (StringUtils.endsWithIgnoreCase(svo.getPeriod(), "M") || StringUtils.endsWithIgnoreCase(svo.getPeriod(), "H")) {
            return getSummaryMiBarList(svo);
        } else if (StringUtils.endsWithIgnoreCase(svo.getPeriod(), "W")) {
            return getSummaryDBarList(svo);
        }
        return Collections.emptyList();
    }

    // SELECT CODE as symbol, CYCLE as period, EXTRACT(epoch FROM date + '-8 hour') *1000::INTEGER AS timestamp, OPEN, HIGH, LOW,
    // CLOSE,
    // VOL as volume
    // FROM FU_BAR_INFO WHERE CODE=#{symbol} and CYCLE=#{period}
    // <if test="from != null">
    // and DATE <![CDATA[ > ]]> TO_TIMESTAMP(#{from,javaType=LONG}/1000) + '8 hour'
    //     </if>
    //     <if test="to != null">
    // and DATE <![CDATA[ <= ]]> TO_TIMESTAMP(#{to, javaType=LONG}/1000) + '8 hour'
    //     </if>
    // ORDER BY DATE ASC
    // limit 500000

    /**
     * 查询数据库中实际的周期数据
     *
     * @param svo
     * @return
     */
    private List<BarVo> getRealBarList(SearchVo svo) {
        QueryWrapper query = query()
                .select(bar.CODE.as("symbol"), bar.CYCLE.as("period"), column("EXTRACT(epoch FROM date + '-8 hour') *1000::INTEGER").as("timestamp"),
                        bar.OPEN, bar.HIGH, bar.LOW, bar.CLOSE, bar.VOL.as("volume"))
                .limit(50000);
        setCondition(svo, query);
        return this.listAs(query, BarVo.class);
    }


    // WITH temp_select_bar AS(
    //         SELECT CODE as symbol, CYCLE as period, to_char(date, 'YYYY-MM-DD ') || m.cycle_30M as dt,
    // FIRST_VALUE(OPEN) OVER (PARTITION BY CODE, CYCLE, to_char(date, 'YYYY-MM-DD ') || m.cycle_30M ORDER BY date ASC) as open,
    // LAST_VALUE(CLOSE) OVER (PARTITION BY CODE, CYCLE, to_char(date, 'YYYY-MM-DD ') || m.cycle_30M ORDER BY date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as close,
    // HIGH, LOW, VOL as volume
    // from FU_BAR_INFO t
    // LEFT JOIN FU_MIN_MAPPING m
    // ON m.cycle_5m = to_char(date, 'HH24:MI:SS')::time
    // where CODE='RBL9' and CYCLE='5M'
    // AND date > to_date('2013-07-08 00:00:00', 'YYYY-MM-DD HH24-MI-SS')
    // AND date < to_date('2013-07-09 00:00:00', 'YYYY-MM-DD HH24-MI-SS')
    //         )
    //
    // SELECT s.symbol, '30M' as period,
    // EXTRACT(epoch FROM to_timestamp(dt, 'YYYY-MM-DD HH24-MI-SS') + '-8 hour')*1000::INTEGER as timestamp,
    // MIN(s.OPEN) as open, max(s.HIGH) as high, MIN(s.LOW) as low, MAX(s.CLOSE) as close, SUM(s.volume) as volume
    // FROM temp_select_bar s GROUP BY s.symbol, s.period, s.dt
    // ORDER BY s.dt ASC;

    /**
     * 查询由5分钟计算汇总到更多周期的数据
     *
     * @param svo
     * @return
     */
    private List<BarVo> getSummaryMiBarList(SearchVo svo) {
        String period = svo.getPeriod();
        QueryWrapper subSelect = select(
                bar.CODE.as("symbol"),
                bar.CYCLE.as("period"), 
                column("to_char(date, 'YYYY-MM-DD ') || mp.cycle_"+period).as("dt"),
                column("FIRST_VALUE(OPEN) OVER (PARTITION BY CODE, CYCLE, to_char(date, 'YYYY-MM-DD ') || mp.cycle_" + period + " ORDER BY date ASC)").as("open"),
                column("LAST_VALUE(CLOSE) OVER (PARTITION BY CODE, CYCLE, to_char(date, 'YYYY-MM-DD ') || mp.cycle_" + period + " ORDER BY date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)").as("close"),
                bar.HIGH, bar.LOW, bar.VOL.as("volume")
        ).from(bar)
                .leftJoin(mp)
                .on(mp.CYCLE5M.eq(column("to_char(date, 'HH24:MI:SS')::time")));
        // 过滤5M周期数据进行计算
        svo.setPeriod("5M");
        setCondition(svo, subSelect);

        QueryWrapper query = select(
                column("s.symbol"), string(period).as("period"),
                column("EXTRACT(epoch FROM to_timestamp(s.dt, 'YYYY-MM-DD HH24-MI-SS') + '-8 hour')*1000::INTEGER").as("timestamp"),
                column("MIN(s.OPEN)").as("open"), column("max(s.HIGH)").as("high"), column("MIN(s.LOW)").as("low"),
                column("MAX(s.CLOSE)").as("close"), column("SUM(s.volume)").as("volume"))
            .from(subSelect).as("s")
                .groupBy("s.symbol", "s.period", "s.dt")
                .orderBy("s.dt ASC");
        return this.listAs(query, BarVo.class);
    }

    // SELECT t.symbol, 'W' as period, EXTRACT(epoch FROM t.wk + '-8 hour')*1000::INTEGER as timestamp, min(t.open) as OPEN,
    // max(t.close) as CLOSE, MIN(LOW) as LOW, MAX(HIGH) as HIGH, SUM(volume) as VOLUME FROM
    //         (
    //                 select CODE as symbol, CYCLE as period,
    //                 date_trunc('week', DATE) as wk,
    // FIRST_VALUE(OPEN) OVER (PARTITION BY CODE, CYCLE, date_trunc('week', DATE) ORDER BY date ASC) as open,
    // LAST_VALUE(CLOSE) OVER (PARTITION BY CODE, CYCLE, date_trunc('week', DATE) ORDER BY date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as close,
    // HIGH, LOW, VOL as volume
    // from fu_bar_info where CODE='RBL9' and CYCLE='D'
    // ) t
    // GROUP BY t.symbol, t.period, t.wk
    // ORDER BY t.wk;

    /**
     * 查询由日线计算汇总到周的数据
     *
     * @param svo
     * @return
     */
    private List<BarVo> getSummaryDBarList(SearchVo svo) {
        String period = svo.getPeriod();
        QueryWrapper subSelect = select(
                bar.CODE.as("symbol"),
                bar.CYCLE.as("period"), bar.DATE,
                column("date_trunc('week', DATE)").as("wk"),
                column("FIRST_VALUE(OPEN) OVER (PARTITION BY CODE, CYCLE, DATE_TRUNC('week', DATE) ORDER BY date ASC)").as("open"),
                column("LAST_VALUE(CLOSE) OVER (PARTITION BY CODE, CYCLE, DATE_TRUNC('week', DATE) ORDER BY date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)").as("close"),
                bar.HIGH, bar.LOW, bar.VOL.as("volume")
        ).from(bar);
        // 由日K汇总
        svo.setPeriod("D");
        setCondition(svo, subSelect);

        QueryWrapper query = select(
                column("t.symbol"), string("W").as("period"),
                column("EXTRACT(epoch FROM t.wk + '-8 hour') * 1000::INTEGER").as("timestamp"),
                column("MIN(t.OPEN)").as("open"), column("max(t.HIGH)").as("high"), column("MIN(t.LOW)").as("low"),
                column("MAX(t.CLOSE)").as("close"), column("SUM(t.volume)").as("volume")
        ).from(subSelect).as("t")
                .groupBy("t.symbol", "t.period", "t.wk")
                .orderBy("t.wk");
        return this.listAs(query, BarVo.class);
    }

    private void setCondition(SearchVo svo, QueryWrapper query) {
        query.where(bar.CODE.eq(svo.getSymbol()))
                .and(bar.CYCLE.eq(svo.getPeriod()))
                .and(bar.DATE.gt(column("TO_TIMESTAMP(" + svo.getFrom() + "/1000) + '8 hour'"), svo.getFrom() != null))
                .and(bar.DATE.le(column("TO_TIMESTAMP(" + svo.getTo() + "/1000) + '8 hour'"), svo.getTo() != null));

    }
}