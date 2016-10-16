<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<dl class="p_paragraph_content">
	<div class="group_con w-1100">
		<p class="group_h">
			<b>团信息</b>
		</p>
		<div class="group_msg">
			<dd class="inl-bl w-300">
				<div class="dd_left">团号：</div>
				<div class="dd_right">${one.group_code }</div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl w-600">
				<div class="dd_left">计调：</div>
				<div class="dd_right">${one.operator_name }</div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl w-300">
				<div class="dd_left">人数：</div>
				<div class="dd_right">
					<c:if test="${not empty one.total_adult}">${one.total_adult}大</c:if><c:if test="${not empty one.total_child}">${one.total_child}小</c:if><c:if test="${not empty one.total_guide}">${one.total_guide}陪</c:if>
				</div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl w-700">
				<div class="dd_left">产品名称：</div>
				<div class="dd_right">【${one.product_brand_name }】 ${one.product_name }</div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl w-300">
				<div class="dd_left">状态：</div>
				<div class="dd_right">
						<c:if test="${one.group_state eq 0}">未确认</c:if>
						<c:if test="${one.group_state eq 1}">已确认</c:if>
						<c:if test="${one.group_state eq 2}">作废</c:if>
						<c:if test="${one.group_state eq 3}">已审核</c:if>
						<c:if test="${one.group_state eq 4}">已封存</c:if>
				</div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl w-600">
				<div class="dd_left">起始日期：</div>
				<div class="dd_right">${one.date_start }~${one.date_end }</div>
				<div class="clear"></div>
			</dd>
		</div>
	</div>
</dl>