package cn.kdaiy.future.mapper;

import cn.kdaiy.future.entity.BarInfoEntity;
import cn.kdaiy.future.vo.BarVo;
import cn.kdaiy.future.vo.SearchVo;
import com.mybatisflex.core.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 期货bar数据列表 映射层。
 *
 * @author hzboy192
 * @since v1
 */
@Mapper
public interface BarInfoMapper extends BaseMapper<BarInfoEntity> {

    List<BarVo> selectHistoryBar(SearchVo svo);

    List<BarVo> selectHistoryBarForWeek(SearchVo svo);

    List<BarVo> selectHistoryBarForMinute(SearchVo svo);
}
