package cn.kdaiy.future.mapper;

import cn.kdaiy.future.entity.UserTrainDtlEntity;
import cn.kdaiy.future.entity.table.UserTrainDtlEntityTableDef;
import cn.kdaiy.future.vo.TrainSummaryVo;
import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.core.row.Db;
import com.mybatisflex.core.row.Row;
import com.mybatisflex.core.row.RowUtil;
import org.apache.ibatis.annotations.Mapper;

import static cn.kdaiy.future.entity.table.UserTrainDtlEntityTableDef.USER_TRAIN_DTL_ENTITY;

/**
 * 训练交易记录 映射层。
 *
 * @author hzboy192
 * @since v1
 */
@Mapper
public interface UserTrainDtlMapper extends BaseMapper<UserTrainDtlEntity> {

    UserTrainDtlEntityTableDef t = USER_TRAIN_DTL_ENTITY.as("t");

    default QueryWrapper query() {
        return QueryWrapper.create().from(t);
    }

    default int deleteUserTrainDtl(Long traId) {
        return this.deleteByQuery(query().where(t.TRA_ID.eq(traId)));
    }

    /**
     * 训练交易记录汇总
     * select t.tra_id as traId, t.first_amount as firstAmount, t.finish_amount as finishAmount,
     * 	(t.finish_amount - t.first_amount)  as totalProfit,
     * 	   dtl.*
     * from (select tra_id, 
     *              sum(case when type = 0 then 1 else 0 end) openTimes, -- 开仓次数
     *              sum(ser_amount) as totalFee,  -- 总手续费
     *              max(case when type = 1 and income >= 0 then income end) as maxProfit,  -- 最大收益
     *              min(case when type = 1 and income < 0 then income end) as maxLoss, -- 最小收益
     *              sum(case when type = 1 and income < 0 then income end) as totalLoss, -- 总亏损
     *              sum(case when type = 1 and income >= 0 then 1 else 0 end) as profitTimes, -- 盈利次数
     * 			 sum(case when type = 1 and income < 0 then 1 else 0 end) as lossTimes -- 亏损次数
     * 	  from fu_user_train_dtl
     * 	  where tra_id = 55420297526000146
     * 	  group by tra_id) dtl
     *  left join fu_user_train t on t.tra_id = dtl.tra_id
     *
     * @param traId 训练id
     * @return 训练交易记录汇总
     */
    default TrainSummaryVo getTrainSummary(Long traId) {
        String summarySql = "select t.tra_id as traId, t.first_amount as firstAmount, t.finish_amount as finishAmount,\n" +
                "\t(t.finish_amount - t.first_amount)  as totalProfit,\n" +
                "\t   dtl.*\n" +
                "from (select tra_id, \n" +
                "             sum(case when type = 0 then 1 else 0 end) openTimes, -- 开仓次数\n" +
                "             sum(ser_amount) as totalFee,  -- 总手续费\n" +
                "             max(case when type = 1 and income >= 0 then income end) as maxProfit,  -- 最大收益\n" +
                "             min(case when type = 1 and income < 0 then income end) as maxLoss, -- 最小收益\n" +
                "             sum(case when type = 1 and income < 0 then income end) as totalLoss, -- 总亏损\n" +
                "             sum(case when type = 1 and income >= 0 then 1 else 0 end) as profitTimes, -- 盈利次数\n" +
                "\t\t\t sum(case when type = 1 and income < 0 then 1 else 0 end) as lossTimes -- 亏损次数\n" +
                "\t  from fu_user_train_dtl\n" +
                "\t  where tra_id = ? \n" +
                "\t  group by tra_id) dtl\n" +
                " left join fu_user_train t on t.tra_id = dtl.tra_id";
        Row row = Db.selectOneBySql(summarySql, traId);
        if (row == null) {
            return null;
        }
        return RowUtil.toEntity(row, TrainSummaryVo.class);
    }
}
