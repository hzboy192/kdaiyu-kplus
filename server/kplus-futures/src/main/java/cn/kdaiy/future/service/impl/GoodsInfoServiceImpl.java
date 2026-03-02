package cn.kdaiy.future.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.kdaiy.common.basic.Constants;
import cn.kdaiy.future.entity.GoodsInfoEntity;
import cn.kdaiy.future.entity.table.GoodsInfoEntityTableDef;
import cn.kdaiy.future.mapper.GoodsInfoMapper;
import cn.kdaiy.future.service.GoodsInfoService;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

import static cn.kdaiy.future.entity.table.GoodsInfoEntityTableDef.GOODS_INFO_ENTITY;


/**
 * 期货商品信息 服务层实现。
 *
 * @author hzboy192
 * @since v1
 */
@Service
public class GoodsInfoServiceImpl extends ServiceImpl<GoodsInfoMapper, GoodsInfoEntity> implements GoodsInfoService {
    private final GoodsInfoEntityTableDef g = GOODS_INFO_ENTITY.as("g");
    
    @Override
    public QueryWrapper query() {
        return super.query().from(g);
    }

    @Override
    public Page<GoodsInfoEntity> pageXml(Page<GoodsInfoEntity> page, GoodsInfoEntity goodsInfo) {
        return this.mapper.xmlPaginate("pageGoodsList", page, null, BeanUtil.beanToMap(goodsInfo, false, true));
    }

    @Override
    public List<GoodsInfoEntity> listGoods(String searchValue) {
        QueryWrapper query = query().select(g.CODE, g.NAME, g.MARKET_CODE, g.MARKET_NAME, g.MAIN_NUM, g.MAIN_NAME)
                .where(g.NAME.like(searchValue).or(g.CODE.like(searchValue)))
                .and(g.IS_ENABLE.eq(Constants.ENABLE_Y));
        return this.list(query);
    }
}