package com.yihg.erp.aop;
import java.io.Serializable;

/**
 * Ajax请求返回结果
 * 
 * @author 88144881
 */
public class ResultBean implements Serializable {

    private static final long serialVersionUID = 7316027768178960373L;

    private Object data;
    private boolean success;
    private String msg;

    public boolean getSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
