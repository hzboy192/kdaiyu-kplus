package cn.kdaiy.future.service.impl;


import cn.kdaiy.common.basic.exception.BizException;
import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.entity.UserTrainDtlEntity;
import cn.kdaiy.future.mapper.UserTrainDtlMapper;
import cn.kdaiy.future.service.UserTrainDtlService;
import cn.kdaiy.future.service.UserTrainService;
import cn.kdaiy.future.vo.TrainSummaryVo;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import io.jsonwebtoken.lang.Collections;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 训练交易记录 服务层实现。
 *
 * @author hzboy192
 * @since v1
 */
@Service
public class UserTrainDtlServiceImpl extends ServiceImpl<UserTrainDtlMapper, UserTrainDtlEntity> implements UserTrainDtlService {

    @Resource
    private UserTrainService userTrainService;

    @Override
    public FundAccountEntity close(List<UserTrainDtlEntity> dtlList) {
        if (Collections.isEmpty(dtlList)) {
            return null;
        }
        UserTrainDtlEntity tradeBilling = null;
        List<UserTrainDtlEntity> openList = new ArrayList<>();
        for (UserTrainDtlEntity dtlItem : dtlList) {
            if (TRAIN_DTL_TYPE_BILLING.equals(dtlItem.getType())) {
                tradeBilling = dtlItem;
            } else {
                dtlItem.setStatus(TRAIN_DTL_TYPE_CLOSED);
                openList.add(dtlItem);
            }
        }
        if (tradeBilling == null || openList.isEmpty()) {
            throw new BizException("结算单不存在或没有开仓记录！");
        }
        // 保存结算单
        this.save(tradeBilling);
        // 开仓单在开仓时已创建，此处只更新仓单状态。
        this.updateBatch(openList);
        // 更新账户信息
        return userTrainService.refreshFundAmount(tradeBilling.getTraId(), tradeBilling.getIncome());
    }
 
    @Override
    public UserTrainDtlEntity open(UserTrainDtlEntity userTrainDtl) {
        super.saveOrUpdate(userTrainDtl);
        return userTrainDtl;
    }

    @Override
    public boolean deleteUserTrainDtl(Long traId) {
        return mapper.deleteUserTrainDtl(traId) > 0;
    }

    @Override
    public TrainSummaryVo getTrainSummary(Long traId) {
        return mapper.getTrainSummary(traId);
    }
}