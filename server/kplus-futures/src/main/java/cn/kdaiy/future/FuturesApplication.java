package cn.kdaiy.future;

import lombok.extern.slf4j.Slf4j;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.ComponentScan;

@Slf4j
@SpringBootApplication
@ComponentScan(basePackages = {"cn.kdaiy"})
@MapperScan({"cn.kdaiy.**.mapper"})
public class FuturesApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext app = SpringApplication.run(FuturesApplication.class, args);
        log.info("==>>startup finish! Running status is {}!", app.isRunning() ? "success" : "failed");
    }
}