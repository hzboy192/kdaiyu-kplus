package cn.kdaiy.future.mapper;

import cn.kdaiy.future.entity.ServiceChargeEntity;
import cn.kdaiy.future.entity.table.ServiceChargeEntityTableDef;
import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.core.query.QueryWrapper;
import org.apache.ibatis.annotations.Mapper;

import static cn.kdaiy.future.entity.table.ServiceChargeEntityTableDef.SERVICE_CHARGE_ENTITY;

/**
 * 期货手续费 映射层。
 *
 * @author hzboy192
 * @since v1
 */
@Mapper
public interface ServiceChargeMapper extends BaseMapper<ServiceChargeEntity> {

    ServiceChargeEntityTableDef t = SERVICE_CHARGE_ENTITY.as("t");

    default QueryWrapper query() {
        return QueryWrapper.create().from(t);
    }

}
