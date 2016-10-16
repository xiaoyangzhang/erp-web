package com.yihg.erp.aop;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Post请求响应处理，配合前端JS函数YM.post()使用
 * 
 * @author Jing.Zhuo
 * @create 2015年7月24日 下午1:19:44
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface PostHandler {
}
