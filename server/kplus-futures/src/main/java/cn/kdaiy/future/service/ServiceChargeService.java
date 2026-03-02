package cn.kdaiy.future.service;


import cn.kdaiy.future.entity.ServiceChargeEntity;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.core.service.IService;

import java.util.List;

/**
 * 期货手续费 服务层。
 *
 * @author hzboy192
 * @since v1
 */
public interface ServiceChargeService extends IService<ServiceChargeEntity> {
    /**
     * 查询期货手续费 列表
     */
    default List<ServiceChargeEntity> queryList(ServiceChargeEntity entity) {
        QueryWrapper query = QueryWrapper.create(entity).from(ServiceChargeEntity.class);
        return this.list(query);
    }
}