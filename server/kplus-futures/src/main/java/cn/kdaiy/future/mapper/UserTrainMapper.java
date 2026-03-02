package cn.kdaiy.future.mapper;

import cn.kdaiy.future.entity.UserTrainEntity;
import cn.kdaiy.future.entity.table.UserTrainEntityTableDef;
import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.core.query.QueryWrapper;
import org.apache.ibatis.annotations.Mapper;

import static cn.kdaiy.future.entity.table.UserTrainEntityTableDef.USER_TRAIN_ENTITY;

/**
 * 用户训练记录 映射层。
 *
 * @author hzboy192
 * @since v1
 */
@Mapper
public interface UserTrainMapper extends BaseMapper<UserTrainEntity> {
    UserTrainEntityTableDef t = USER_TRAIN_ENTITY.as("t");

    default QueryWrapper query() {
        return QueryWrapper.create().from(t);
    }

}
