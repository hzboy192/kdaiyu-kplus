package cn.kdaiy.future.controller;

import cn.kdaiy.common.basic.vo.Response;
import cn.kdaiy.future.entity.ServiceChargeEntity;
import cn.kdaiy.future.service.ServiceChargeService;
import com.mybatisflex.core.paginate.Page;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.io.Serializable;

/**
 * 期货手续费
 *
 * @author hzboy192
 * @since v1
 */
@RestController
@RequestMapping("/serviceCharge")
public class ServiceChargeController {

    @Resource
    private ServiceChargeService serviceChargeService;

    /**
     * 添加 期货手续费
     *
     * @param serviceCharge 期货手续费
     * @return {@code true} 添加成功，{@code false} 添加失败
     */
    @PostMapping
    public Response<?> save(@RequestBody ServiceChargeEntity serviceCharge) {
        return Response.success(serviceChargeService.saveOrUpdate(serviceCharge));
    }


    /**
     * 根据主键删除
     *
     * @param id 主键
     * @return {@code true} 删除成功，{@code false} 删除失败
     */
    @DeleteMapping("/{id}")
    public Response<?> remove(@PathVariable Serializable id) {
        return Response.success(serviceChargeService.removeById(id));
    }


    /**
     * 根据主键更新
     *
     * @param entity 期货手续费
     * @return {@code true} 更新成功，{@code false} 更新失败
     */
    @PutMapping
    public Response<?> update(@RequestBody ServiceChargeEntity entity) {
        return Response.success(serviceChargeService.updateById(entity));
    }


    /**
     * 根据条件查询列表
     *
     * @return 所有数据
     */
    @GetMapping("/list")
    public Response<?> list(ServiceChargeEntity entity) {
        return Response.success(serviceChargeService.queryList(entity));
    }


    /**
     * 根据期货手续费主键获取详细信息。
     *
     * @param id serviceCharge主键
     * @return 期货手续费详情
     */
    @GetMapping("/{id}")
    public Response<?> getInfo(@PathVariable Serializable id) {
        return Response.success(serviceChargeService.getById(id));
    }


    /**
     * 分页查询期货手续费
     *
     * @param page 分页对象
     * @return 分页对象
     */
    @GetMapping("/page")
    public Response<?> page(Page<ServiceChargeEntity> page) {
        return Response.success(serviceChargeService.page(page));
    }
}