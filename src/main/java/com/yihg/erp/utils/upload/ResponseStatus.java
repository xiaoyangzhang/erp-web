package com.yihg.erp.utils.upload;

/**
 * @author wenfeng zhang @ 10/21/14
 */
public enum ResponseStatus {

    SUCCESS(200, "uplod success!"),
    ERROR(500, "system error!"),
    FILE_TO_BIG(800, "文件过大，不能上传!"),
    ;

    public Integer VALUE;
    public String MESSAGE;

    ResponseStatus(Integer value, String message) {
        this.VALUE = value;
        this.MESSAGE = message;
    }

}
