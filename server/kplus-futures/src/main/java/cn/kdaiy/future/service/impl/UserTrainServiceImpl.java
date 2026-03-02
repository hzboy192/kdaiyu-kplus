package cn.kdaiy.future.service.impl;


import cn.hutool.core.util.NumberUtil;
import cn.kdaiy.common.basic.exception.BizException;
import cn.kdaiy.common.boot.utils.SecurityUtils;
import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.entity.ServiceChargeEntity;
import cn.kdaiy.future.entity.UserTrainEntity;
import cn.kdaiy.future.mapper.UserTrainDtlMapper;
import cn.kdaiy.future.mapper.UserTrainMapper;
import cn.kdaiy.future.service.FundAccountService;
import cn.kdaiy.future.service.ServiceChargeService;
import cn.kdaiy.future.service.UserTrainService;
import cn.kdaiy.future.vo.SymbolInfoVo;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.Date;

/**
 * 用户训练记录 服务层实现。
 *
 * @author hzboy192
 * @since v1
 */
@Service
@Slf4j
public class UserTrainServiceImpl extends ServiceImpl<UserTrainMapper, UserTrainEntity> implements UserTrainService {

    @Resource
    private FundAccountService fundAccountService;

    @Resource
    private ServiceChargeService chargeService;

    @Resource
    private UserTrainDtlMapper userTrainDtlMapper;

    @Override
    public boolean addUserTrain(UserTrainEntity entity) {
        FundAccountEntity fundAccount = fundAccountService.getById(entity.getFundId());
        // 设置初始资金
        entity.setFirstAmount(fundAccount.getAmount());
        entity.setFinishAmount(fundAccount.getAmount());
        entity.setCreateTime(new Date(Instant.now().toEpochMilli()));
        return super.save(entity);
    }

    @Override
    public SymbolInfoVo getSymbolInfo(SymbolInfoVo infoVo) {
        ServiceChargeEntity chargeEntity = chargeService.getById(infoVo.getGoodCode());
        infoVo.setSerCalcType(chargeEntity.getSerCalcType());
        infoVo.setSerCharge(chargeEntity.getSerCharge());
        infoVo.setSecurityDepositCent(chargeEntity.getSecurityDepositCent());
        infoVo.setUnitPrice(chargeEntity.getUnitPrice());
        return infoVo;
    }

    @Override
    public FundAccountEntity refreshFundAmount(Long traId, BigDecimal amount) {
        UserTrainEntity trainEntity = super.getById(traId);
        // 资金账户增加金额
        FundAccountEntity fundAccountEntity = fundAccountService.updateFundAmount(trainEntity.getFundId(), amount);
        // 刷新训练记录的结束金额
        trainEntity.setFinishAmount(fundAccountEntity.getAmount());
        super.updateById(trainEntity);
        return fundAccountEntity;
    }

    @Override
    public Boolean deleteUserTrain(Long traId) {
        UserTrainEntity trainEntity = this.getById(traId);
        if (trainEntity == null || !NumberUtil.equals(trainEntity.getUserId(), SecurityUtils.getUserId())) {
            throw new BizException("训练记录不存在！");
        }
        // 清空训练记录下的所有明细
        int count = userTrainDtlMapper.deleteUserTrainDtl(traId);
        if (count == 0) {
            log.warn("用户{}的训练记录{}下无交易记录！", SecurityUtils.getUsername(), traId);
        }
        return removeById(traId);
    }
}