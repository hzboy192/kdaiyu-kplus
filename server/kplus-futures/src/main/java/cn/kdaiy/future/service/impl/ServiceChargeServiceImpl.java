package cn.kdaiy.future.service.impl;


import cn.kdaiy.future.entity.ServiceChargeEntity;
import cn.kdaiy.future.mapper.ServiceChargeMapper;
import cn.kdaiy.future.service.ServiceChargeService;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;


/**
 * 期货手续费 服务层实现。
 *
 * @author hzboy192
 * @since v1
 */
@Service
public class ServiceChargeServiceImpl extends ServiceImpl<ServiceChargeMapper, ServiceChargeEntity> implements ServiceChargeService {

}