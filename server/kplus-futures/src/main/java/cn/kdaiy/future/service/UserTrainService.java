package cn.kdaiy.future.service;


import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.entity.UserTrainEntity;
import cn.kdaiy.future.vo.SymbolInfoVo;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.core.service.IService;

import java.math.BigDecimal;
import java.util.List;

/**
 * 用户训练记录 服务层。
 *
 * @author hzboy192
 * @since v1
 */
public interface UserTrainService extends IService<UserTrainEntity> {

    // 训练状态：0.未开始
    Integer TRAIN_STATUS_READY = 0;
    // 训练状态：1.进行中
    Integer TRAIN_STATUS_RUNNING = 1;
    // 训练状态：-1.已结束，
    Integer TRAIN_STATUS_FINISH = -1;

    default List<UserTrainEntity> queryList(UserTrainEntity entity) {
        QueryWrapper query = QueryWrapper.create(entity).from(UserTrainEntity.class);
        return this.list(query);
    }

    /**
     * 添加用户训练记录及将以详情记录
     * <p>
     *
     * @param entity 训练记录及交易记录
     * @return boolean
     */
    boolean addUserTrain(UserTrainEntity entity);

    /**
     * 获取合约信息/手续费/保证金
     * @param infoVo 合约信息
     * @return 合约信息
     */
    SymbolInfoVo getSymbolInfo(SymbolInfoVo infoVo);

    /**
     * 更新资金
     * @param traId 用户训练记录
     * @param amount 金额
     */
    FundAccountEntity refreshFundAmount(Long traId, BigDecimal amount);

    /**
     * 删除用户训练记录
     *
     * @param traId 训练记录ID
     * @return boolean
     */
    Boolean deleteUserTrain(Long traId);

}