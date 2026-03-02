package cn.kdaiy.future.controller;

import cn.kdaiy.common.basic.utils.SystemInfoUtils;
import cn.kdaiy.common.basic.vo.Response;
import cn.kdaiy.common.boot.annotation.Anonymous;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.entity.ContentType;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@Controller
@RequestMapping("health")
@Slf4j
public class HealthController {

    @Anonymous
    @GetMapping
    @ResponseBody
    public Response<?> health() {
        return Response.success("health", "futures app is live.");
    }

    @Anonymous
    @GetMapping("sysInfo")
    public void sysInfo(HttpServletResponse response) throws IOException {
        response.setStatus(HttpStatus.OK.value());
        response.setHeader(HttpHeaders.CONTENT_TYPE, ContentType.TEXT_PLAIN.getMimeType());
        StringBuilder sb = new StringBuilder();
        sb.append("---------------SystemInfo-----------------\r\n");
        sysInfoHtml(SystemInfoUtils.getInfo(), sb);
        response.getWriter().write(sb.toString());
        log.debug("system info summary finish!");
    }

    private void sysInfoHtml(JSONObject sysInfo, StringBuilder sb) {
        for (Map.Entry<String, Object> entry : sysInfo.entrySet()) {
            Object val = entry.getValue();
            if (val instanceof JSON) {
                sb.append("").append(entry.getKey()).append(": \n");
                sysInfoHtml((JSONObject) val, sb);
            } else {
                sb.append("").append(entry.getKey()).append(":").append(val).append("\n");
            }
        }
    }
}
