package cn.kdaiy.future.controller;

import cn.hutool.core.util.NumberUtil;
import cn.kdaiy.common.basic.vo.Response;
import cn.kdaiy.common.boot.utils.SecurityUtils;
import cn.kdaiy.future.entity.UserTrainEntity;
import cn.kdaiy.future.service.UserTrainService;
import cn.kdaiy.future.vo.SymbolInfoVo;
import com.mybatisflex.core.paginate.Page;
import lombok.extern.slf4j.Slf4j;
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
 * 用户训练记录
 *
 * @author hzboy192
 * @since v1
 */
@RestController
@Slf4j
@RequestMapping("/userTrain")
public class UserTrainController {

    @Resource
    private UserTrainService userTrainService;


    /**
     * 保存用户训练记录
     *
     * @param userTrain 用户训练记录
     * @return response 响应结果，成功后返回完整数据，带生成的主键
     */
    @PostMapping
    public Response<?> add(@RequestBody UserTrainEntity userTrain) {
        userTrain.setUserId(SecurityUtils.getUserId());
        boolean isSuccess = userTrainService.addUserTrain(userTrain);
        if (!isSuccess) {
            return Response.bizError("保存失败！");
        }
        return Response.success(userTrain);
    }


    /**
     * 根据主键删除
     *
     * @param id 主键
     * @return {@code true} 删除成功，{@code false} 删除失败
     */
    @DeleteMapping("/{id}")
    public Response<Boolean> remove(@PathVariable Long id) {
        return Response.success(userTrainService.deleteUserTrain(id));
    }


    /**
     * 根据主键更新
     *
     * @param entity 用户训练记录
     * @return {@code true} 更新成功，{@code false} 更新失败
     */
    @PutMapping
    public Response<Boolean> update(@RequestBody UserTrainEntity entity) {
        return Response.success(userTrainService.updateById(entity));
    }

    /**
     * 根据用户训练记录主键获取详细信息。
     *
     * @param id userTrain主键
     * @return 用户训练记录详情
     */
    @GetMapping("/{id}")
    public Response<?> getInfo(@PathVariable Serializable id) {
        UserTrainEntity trainEntity = userTrainService.getById(id);
        if (trainEntity == null || !NumberUtil.equals(trainEntity.getUserId(), SecurityUtils.getUserId())) {
            return Response.bizError("用户训练记录不存在！");
        }
        return Response.success(trainEntity);
    }


    /**
     * 分页查询用户训练记录
     *
     * @param page 分页对象
     * @return 分页对象
     */
    @GetMapping("/page")
    public Response<Page<UserTrainEntity>> page(Page<UserTrainEntity> page) {
        return Response.success(userTrainService.page(page));
    }

    /**
     * 获取训练合约的配置信息
     *
     * @param infoVo 合约信息
     * @return 合约配置信息/合约手续费...
     */
    @PostMapping("/SymbolInfo")
    public Response<SymbolInfoVo> SymbolInfo(@RequestBody SymbolInfoVo infoVo) {
        return Response.success(userTrainService.getSymbolInfo(infoVo));
    }
}