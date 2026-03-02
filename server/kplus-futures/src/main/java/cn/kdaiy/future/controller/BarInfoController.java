package cn.kdaiy.future.controller;

import cn.hutool.core.lang.Assert;
import cn.kdaiy.common.basic.Constants;
import cn.kdaiy.common.basic.vo.Response;
import cn.kdaiy.future.entity.BarInfoEntity;
import cn.kdaiy.future.service.BarInfoService;
import cn.kdaiy.future.vo.SearchVo;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * bar数据列表
 *
 * @author hzboy192
 * @since v1
 */
@RestController
@RequestMapping("bar")
public class BarInfoController {

    @Resource
    private BarInfoService barInfoService;

    /**
     * 根据主键获取详细信息。
     *
     * @param id barDataList主键
     * @return 期货bar数据列表详情
     */
    @GetMapping("/{id}")
    public Response<BarInfoEntity> getInfo(@PathVariable Long id) {
        return Response.success(barInfoService.getById(id));
    }


    /**
     * 查询历史行情(旧)
     * 
     * @param svo
     * @return
     */
    @GetMapping("/historyBars")
    public Response<?> getHistoryBars(SearchVo svo) {
        Assert.notEmpty(svo.getSymbol(), Constants.CAN_NOT_BE_EMPTY, "symbol");
        Assert.notEmpty(svo.getPeriod(), Constants.CAN_NOT_BE_EMPTY, "period");
        if (StringUtils.contains("5m,15m,20m,30m,1H,2H,4H,D,W", svo.getPeriod())){
            return Response.success(barInfoService.getHistoryBars(svo));
        }
        return Response.bizError("period param not support!");
    }

    /**
     *  查询历史行情
     *  
     * @param svo
     * @return
     */
    @GetMapping("/list")
    public Response<?> getBarList(SearchVo svo) {
        Assert.notEmpty(svo.getSymbol(), Constants.CAN_NOT_BE_EMPTY, "symbol");
        Assert.notEmpty(svo.getPeriod(), Constants.CAN_NOT_BE_EMPTY, "period");
        if (StringUtils.contains("5m,15m,20m,30m,1H,2H,4H,D,W", svo.getPeriod())){
            return Response.success(barInfoService.getBarList(svo));
        }
        return Response.bizError("period param not support!");
    }
}