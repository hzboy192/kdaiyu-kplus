package cn.kdaiy.future.service;


import cn.kdaiy.future.entity.BarInfoEntity;
import cn.kdaiy.future.vo.BarVo;
import cn.kdaiy.future.vo.SearchVo;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.service.IService;

import java.util.List;

/**
 * 期货bar数据列表 服务层。
 *
 * @author hzboy192
 * @since v1
 */
public interface BarInfoService extends IService<BarInfoEntity> {
    Page<BarInfoEntity> page(Page<BarInfoEntity> page, BarInfoEntity entity);

    List<BarVo> getHistoryBars(SearchVo svo);

    List<BarVo> getBarList(SearchVo svo);
}