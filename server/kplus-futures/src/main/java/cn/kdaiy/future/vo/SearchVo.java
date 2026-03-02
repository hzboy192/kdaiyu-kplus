package cn.kdaiy.future.vo;

import lombok.Data;

import java.io.Serializable;

@Data
public class SearchVo implements Serializable {
    private static final long serialVersionUID = 2426482634234234L;
    private String symbol;
    private String period;
    private Long from;
    private Long to;
}
