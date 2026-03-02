package cn.kdaiy.future.controller;

import cn.kdaiy.common.basic.vo.Response;
import cn.kdaiy.common.boot.utils.SecurityUtils;
import cn.kdaiy.future.entity.FundAccountEntity;
import cn.kdaiy.future.service.FundAccountService;
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
import java.util.List;

/**
 * 用户资金账户
 *
 * @author hzboy192
 * @since v1
 */
@RestController
@RequestMapping("/fundAccount")
public class FundAccountController {

    @Resource
    private FundAccountService fundAccountService;

    /**
     * 添加 用户资金账户
     *
     * @param fundAccount 用户资金账户
     * @return {@code true} 添加成功，{@code false} 添加失败
     */
    @PostMapping
    public Response<FundAccountEntity> save(@RequestBody FundAccountEntity fundAccount) {
        fundAccount.setUserId(SecurityUtils.getUserId());
        fundAccountService.saveOrUpdate(fundAccount);
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
        return Response.success(fundAccountService.removeById(id));
    }


    /**
     * 根据主键更新
     *
     * @param entity 用户资金账户
     * @return {@code true} 更新成功，{@code false} 更新失败
     */
    @PutMapping
    public Response<Boolean> update(@RequestBody FundAccountEntity entity) {
        return Response.success(fundAccountService.updateById(entity));
    }


    /**
     * 根据条件查询列表
     *
     * @return 所有数据
     */
    @GetMapping("/list")
    public Response<List<FundAccountEntity>> list(FundAccountEntity entity) {
        entity.setUserId(SecurityUtils.getUserId());
        return Response.success(fundAccountService.queryList(entity));
    }


    
    @GetMapping("/{id}")
    public Response<FundAccountEntity> getInfo(@PathVariable Serializable id) {
        return Response.success(fundAccountService.getById(id));
    }

    /**
     * 获取用户默认的资金账户
     *
     * @return 用户资金账户详情
     */
    @GetMapping("/default")
    public Response<FundAccountEntity> getDefaultAccount() {
        return Response.success(fundAccountService.getDefaultFundAccount(SecurityUtils.getUserId()));
    }


    /**
     * 分页查询用户资金账户
     *
     * @param page 分页对象
     * @return 分页对象
     */
    @GetMapping("/page")
    public Response<Page<FundAccountEntity>> page(Page<FundAccountEntity> page) {
        return Response.success(fundAccountService.page(page));
    }
}