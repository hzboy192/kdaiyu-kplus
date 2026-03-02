package cn.kdaiy.future.service.impl;


import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.mapper.FundAccountMapper;
import cn.kdaiy.future.service.FundAccountService;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * 用户资金账户 服务层实现。
 *
 * @author hzboy192
 * @since v1
 */
@Service
public class FundAccountServiceImpl extends ServiceImpl<FundAccountMapper, FundAccountEntity> implements FundAccountService {

}