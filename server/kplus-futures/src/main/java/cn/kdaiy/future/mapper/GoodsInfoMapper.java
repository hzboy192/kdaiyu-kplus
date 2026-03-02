package cn.kdaiy.future.mapper;

import cn.kdaiy.future.entity.GoodsInfoEntity;
import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.core.paginate.Page;
import org.apache.ibatis.annotations.Mapper;

/**
 * 期货商品信息 映射层。
 *
 * @author hzboy192
 * @since v1
 */
@Mapper
public interface GoodsInfoMapper extends BaseMapper<GoodsInfoEntity> {

    Long pageGoodsList_COUNT(GoodsInfoEntity goodsInfo);

    Page<GoodsInfoEntity> pageGoodsList(GoodsInfoEntity goodsInfo);

}
