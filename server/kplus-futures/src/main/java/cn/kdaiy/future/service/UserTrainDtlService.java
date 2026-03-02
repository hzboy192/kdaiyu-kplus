package cn.kdaiy.future.service;


import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.entity.UserTrainDtlEntity;
import cn.kdaiy.future.vo.TrainSummaryVo;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.core.service.IService;

import java.util.List;

/**
 * 训练交易记录 服务层。
 *
 * @author hzboy192
 * @since v1
 */
public interface UserTrainDtlService extends IService<UserTrainDtlEntity> {

    /**
     * 交易记录类型：结算单
     */
    Integer TRAIN_DTL_TYPE_BILLING = 1;

    /**
     * 持仓状态：CLOSED: 0
     */
    Integer TRAIN_DTL_TYPE_HOLDING = 1;

    /**
     * 持仓状态：CLOSED: 0
     */
    Integer TRAIN_DTL_TYPE_CLOSED = 0;

    default List<UserTrainDtlEntity> queryList(UserTrainDtlEntity entity) {
        QueryWrapper query = QueryWrapper.create(entity).from(UserTrainDtlEntity.class);
        return this.list(query);
    }

    /**
     * 用户平仓
     * 累计账户收益，修改开仓记录状态
     * @param dtlList 交易记录
     * @return FundAccountEntity
     */
    FundAccountEntity close(List<UserTrainDtlEntity> dtlList);

    /**
     * 用户开仓
     * 开仓只做数据保存
     *
     * @param userTrainDtl 交易记录
     * @return boolean
     */
    UserTrainDtlEntity open(UserTrainDtlEntity userTrainDtl);

    /**
     * 清空训练记录下的所有交易记录
     *
     * @param traId 训练记录ID
     * @return boolean
     */
    boolean deleteUserTrainDtl(Long traId);

    /**
     * 获取训练记录汇总信息
     *
     * @param traId 训练记录ID
     * @return 成绩单
     */
    TrainSummaryVo getTrainSummary(Long traId);

}