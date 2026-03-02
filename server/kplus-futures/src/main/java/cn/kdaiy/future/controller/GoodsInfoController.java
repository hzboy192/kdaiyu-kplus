package cn.kdaiy.future.controller;

import cn.kdaiy.common.basic.vo.Response;
import cn.kdaiy.future.entity.GoodsInfoEntity;
import cn.kdaiy.future.service.GoodsInfoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * 商品信息基本信息
 *
 * @author hzboy192
 * @since v1
 */
@RestController
@RequestMapping("/goodsInfo")
public class GoodsInfoController {

    @Resource
    private GoodsInfoService goodsInfoService;


    /**
     * 查询所有期货商品信息
     *
     * @return 所有数据
     */
    @GetMapping("/search")
    public Response<List<GoodsInfoEntity>> listGoods(String searchValue) {
        return Response.success(goodsInfoService.listGoods(searchValue));
    }
    

    /**
     * 根据主键获取详细信息。
     *
     * @param id goodsInfo主键
     * @return 期货商品信息详情
     */
    @GetMapping("/{id}")
    public Response<GoodsInfoEntity> getInfo(@PathVariable Long id) {
        return Response.success(goodsInfoService.getById(id));
    }

}