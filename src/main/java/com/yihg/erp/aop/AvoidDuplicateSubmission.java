package com.yihg.erp.aop;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.yihg.erp.contant.TokenConstant.tokenActionEnum;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AvoidDuplicateSubmission {
	tokenActionEnum validToken();
	
}
