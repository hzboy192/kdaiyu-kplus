package cn.kdaiy.future.service;


import cn.kdaiy.future.entity.GoodsInfoEntity;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.service.IService;

import java.util.List;

/**
 * 期货商品信息 服务层。
 *
 * @author hzboy192
 * @since v1
 */
public interface GoodsInfoService extends IService<GoodsInfoEntity> {

    List<GoodsInfoEntity> listGoods(String searchValue);
    
    Page<GoodsInfoEntity> pageXml(Page<GoodsInfoEntity> page, GoodsInfoEntity goodsInfo);
}