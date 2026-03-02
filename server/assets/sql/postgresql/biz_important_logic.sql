-- 由分钟周期汇总到更多周期
SELECT s.symbol, '30M' as period, EXTRACT(epoch FROM to_timestamp(s.d || s.mi, 'YYYY-MM-DDHH24-MI-SS') + '-8 hour')*1000::INTEGER as timestamp,
       MIN(s.OPEN) as open, max(s.HIGH) as high, MIN(s.LOW) as low, MAX(s.CLOSE) as close, SUM(s.volume) as volume
FROM
    (
        SELECT
            CODE as symbol,
            CYCLE as period,
            date,
            to_char(date, 'YYYY-MM-DD') as d,
            m.cycle_30M mi,
            FIRST_VALUE(OPEN) OVER (PARTITION BY CYCLE, to_char(date, 'YYYY-MM-DD'), m.cycle_30M ORDER BY date ASC) as open,
            LAST_VALUE(CLOSE) OVER (PARTITION BY CYCLE, to_char(date, 'YYYY-MM-DD'), m.cycle_30M ORDER BY date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as close,
            HIGH,
            LOW,
            VOL as volume
        from FU_BAR_INFO t
                 LEFT JOIN FU_MIN_MAPPING m
                           ON to_char(m.cycle_5m,'HH24-MI-SS')=to_char(date, 'HH24-MI-SS')
        where CODE='RBL9' and CYCLE='5M'
          AND date > to_date('2013-07-08 00:00:00', 'YYYY-MM-DD HH24-MI-SS')
          AND date < to_date('2013-07-09 00:00:00', 'YYYY-MM-DD HH24-MI-SS')
        ORDER BY DATE ASC
    ) s
GROUP BY s.symbol, s.period, s.d, s.mi;	