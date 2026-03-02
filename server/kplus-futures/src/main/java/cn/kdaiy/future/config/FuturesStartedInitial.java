package cn.kdaiy.future.config;

import cn.kdaiy.common.boot.listener.AppStartedInitial;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * 启动执行类
 *
 * @author: PengHao
 * @date: 2025/12/30 17:46:41
 * @version: v1.0
 */
@Component
@Slf4j
public class FuturesStartedInitial implements AppStartedInitial {
    @Override
    public void onAppStarted() {
        log.info("=>>Futures start event running ...");
        log.info("=>>Futures onAppStarted initial execute.");
        log.info("=>>Futures start event completed ...");
    }
}
