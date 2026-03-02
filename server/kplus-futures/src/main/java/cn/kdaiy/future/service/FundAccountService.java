package cn.kdaiy.future.service;


import cn.kdaiy.common.basic.exception.BizException;
import cn.kdaiy.common.basic.utils.StringUtils;
import cn.kdaiy.future.entity.FundAccountEntity;
import com.mybatisflex.core.query.QueryChain;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.core.service.IService;

import java.math.BigDecimal;
import java.util.List;

/**
 * 用户资金账户 服务层。
 *
 * @author hzboy192
 * @since v1
 */
public interface FundAccountService extends IService<FundAccountEntity> {

    /**
     * 查询账户列表
     * 
     * @param entity 账户信息
     * @return 账户列表
     */
    default List<FundAccountEntity> queryList(FundAccountEntity entity){
        QueryWrapper query = QueryWrapper.create(entity).from(FundAccountEntity.class);
        return this.list(query);
    }

    /**
     * 获取用户默认账户
     * 
     * @param userId 用户ID
     * @return 默认账户
     */
    default FundAccountEntity getDefaultFundAccount(Long userId){
        if (userId == null) {
            return null;
        }
        return QueryChain.of(getMapper()).select().from(FundAccountEntity.class)
                .where(FundAccountEntity::getUserId).eq(userId)
                    .and(FundAccountEntity::getIsDefault).eq(true)
                .one();
    }

    /**
     * 增加资金
     * @param fundId 账户ID
     * @param amount 金额，正数增加，负数减少
     * @return 是否成功
     */
    default FundAccountEntity updateFundAmount(Long fundId, BigDecimal amount) {
        if (fundId == null || amount == null){
            return null;
        }
        FundAccountEntity entity = getById(fundId);
        if (entity == null){
            throw new BizException(StringUtils.format("资金账户{}不存在！", fundId));
        }
        entity.setAmount(entity.getAmount().add(amount));
        this.updateById(entity);
        return entity;
    }
}