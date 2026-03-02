package cn.kdaiy.future.mapper;

import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.entity.table.FundAccountEntityTableDef;
import com.mybatisflex.core.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

import static cn.kdaiy.future.entity.table.FundAccountEntityTableDef.FUND_ACCOUNT_ENTITY;

/**
 * 用户资金账户 映射层。
 *
 * @author hzboy192
 * @since v1
 */
@Mapper
public interface FundAccountMapper extends BaseMapper<FundAccountEntity> {

    FundAccountEntityTableDef fd = FUND_ACCOUNT_ENTITY.as("t");
}
