package cn.kdaiy.future.controller;

import cn.kdaiy.common.basic.vo.Response;
import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.entity.UserTrainDtlEntity;
import cn.kdaiy.future.service.UserTrainDtlService;
import cn.kdaiy.future.vo.TrainSummaryVo;
import com.mybatisflex.core.paginate.Page;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.io.Serializable;
import java.util.List;

/**
 * 训练交易记录
 *
 * @author hzboy192
 * @since v1
 */
@RestController
@RequestMapping("/userTrainDtl")
public class UserTrainDtlController {

    @Resource
    private UserTrainDtlService userTrainDtlService;

    /**
     * 用户开仓
     *
     * @param userTrainDtl 开仓记录
     * @return 操作结果
     */
    @PostMapping("/open")
    public Response<?> open(@RequestBody UserTrainDtlEntity userTrainDtl) {
        return Response.success(userTrainDtlService.open(userTrainDtl));
    }

    /**
     * 用户平仓
     *
     * @param dtlList 平仓记录
     * @return 操作结果
     */
    @PostMapping("/close")
    public Response<FundAccountEntity> close(@RequestBody List<UserTrainDtlEntity> dtlList) {
        // 平仓后返回资金账户信息
        FundAccountEntity fundAccount = userTrainDtlService.close(dtlList);
        return Response.success(fundAccount);
    }

    /**
     * 根据主键删除
     *
     * @param id 主键
     * @return {@code true} 删除成功，{@code false} 删除失败
     */
    @DeleteMapping("/{id}")
    public Response<Boolean> remove(@PathVariable Serializable id) {
        return Response.success(userTrainDtlService.removeById(id));
    }


    /**
     * 根据条件查询列表
     *
     * @return 所有数据
     */
    @GetMapping("/list")
    public Response<List<UserTrainDtlEntity>> list(UserTrainDtlEntity entity) {
        return Response.success(userTrainDtlService.list());
    }

    /**
     * 分页查询训练交易记录
     *
     * @param page 分页对象
     * @return 分页对象
     */
    @GetMapping("/page")
    public Response<Page<UserTrainDtlEntity>> page(Page<UserTrainDtlEntity> page) {
        return Response.success(userTrainDtlService.page(page));
    }


    /**
     * 获取训练交易汇总
     *
     * @param traId 训练记录ID
     * @return 交易汇总信息：总交易次数/盈利次数/亏损次数/最大盈利/最大亏损/总手续费/总利润/总亏损/总收益/盈亏比...
     */
    @GetMapping("/summary/{traId}")
    public Response<TrainSummaryVo> getUserTrain(@PathVariable Long traId) {
        return Response.success(userTrainDtlService.getTrainSummary(traId));
    }
}