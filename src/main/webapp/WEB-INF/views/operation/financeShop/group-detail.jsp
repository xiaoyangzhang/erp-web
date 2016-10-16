<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
 <%@ include file="../../../include/path.jsp" %>
 	<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
 
<p class="p_paragraph_title">
	<b>团组信息</b>
</p>
<dl class="p_paragraph_content">
	<dd>
		<input type="hidden" name="groupId" id="groupId" value="${groupId }">
		<input type="hidden" name="stype" id="stype" value="${stype}">
		<input type="hidden" name="flag" id="flag" value="1">
	</dd>
	<dd>
		<div class="dd_left">
			<b>团号：</b>
		</div>
		<div class="dd_right">${group.groupCode }</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>团类别：</b>
		</div>
		<div class="dd_right">
			<c:if test="${group.groupMode==0 }">散客团</c:if>                 
	    	<c:if test="${group.groupMode!=0 }">团队</c:if>
	    </div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>团日期：</b>
		</div>
		<div class="dd_right">
			<fmt:formatDate pattern='yyyy-MM-dd' value='${group.dateStart}' />&nbsp;/&nbsp;<fmt:formatDate pattern='yyyy-MM-dd' value='${group.dateEnd}' />
		</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>产品名称：</b>
		</div>
		<div class="dd_right">
			<input type="hidden" id="brandId" value="${group.prudctBrandId }" />
			【${group.productBrandName }】${group.productName }
		</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>组团社：</b>
		</div>
		<div class="dd_right">
			<c:if test="${group.groupMode==0 }">散客团</c:if>                 
	    	<c:if test="${group.groupMode!=0 }">${supplierName }</c:if>
		</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>人数：</b>
		</div>
		<div class="dd_right">${group.totalAdult+group.totalChild+group.totalGuide }人</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>销售计调：</b>
		</div>
		<div class="dd_right">${group.operatorName }</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>服务标准：</b>
		</div>
		<div class="dd_right position_relative">
			<div class="dd_text">
				<p><%-- <c:if test="${fn:contains (group.serviceStandard,\n)}">
					${fn:replace(group.serviceStandard,"\n","<br/>")}</c:if> --%>
					${group.serviceStandard }
					</p>
				<br />
			</div>
			<c:if test="${fn:length(group.serviceStandard)>150}">

			<div class="dd_more"><a href="javascript:void(0)" class="blue">更多</a></div>
			</c:if> 
			
		</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>备注：</b>
		</div>
		<div class="dd_right position_relative">
			<div class="dd_text">
				<p>
					${group.remark }</p>
				<br />
			</div>
			<c:if test="${fn:length(group.remark)>150}">

			<div class="dd_more"><a href="javascript:void(0)" class="blue">更多</a></div>
			</c:if> 
		</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>内部备注：</b>
		</div>
		<div class="dd_right position_relative">
			<div class="dd_text">
				<p>
					${group.remarkInternal }
				</p>
				<br />
			</div>
			<c:if test="${fn:length(group.remarkInternal)>150}">

			<div class="dd_more"><a href="javascript:void(0)" class="blue">更多</a></div>
			</c:if> 
		</div>
		<div class="clear"></div>
	</dd>
</dl>
 
	
<script type="text/javascript">
	
	
	$(function() {
		//更多
		//var maxh=$(".dd_text").height();
		$(".dd_more a").click(function  () {
			if ($(this).text()=="更多") {
				var maxh=$(this).parent().siblings(".dd_text").find("p").height();
				console.log(maxh);
				$(this).text("收起").parent().siblings(".dd_text").animate({"height":maxh});
			} else{
				$(this).text("更多").parent().siblings(".dd_text").animate({"height":"50px"});
			}
		})
		
	})   

</script>




