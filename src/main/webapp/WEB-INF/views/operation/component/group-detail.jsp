<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
 <%@ include file="../../../include/path.jsp" %>
<p class="p_paragraph_title">
	<b>团组信息</b>
</p>
<dl class="p_paragraph_content">
	<dd>
		<input type="hidden" name="groupId" id="groupId" value="${groupId }">
		<input type="hidden" name="stype" id="stype" value="${stype}">
	</dd>
	<dd style="width:60%;margin-left:20px;">
	<table class="w_table">	
		<tr>
			<td width="10%"><b>团号：</b></td>
			<td width="40%" style="text-align:left;">${group.groupCode }</td>
			<td width="10%"><b>团类别：</b></td>
			<td width="40%" style="text-align:left;"><c:if test="${group.groupMode==0 }">散客团</c:if>                 
	    	<c:if test="${group.groupMode!=0 }">团队</c:if></td>
		</tr>
		<tr>
			<td><b>团日期：</b></td>
			<td style="text-align:left;"><fmt:formatDate pattern='yyyy-MM-dd' value='${group.dateStart}' />&nbsp;/&nbsp;<fmt:formatDate pattern='yyyy-MM-dd' value='${group.dateEnd}' /></td>
			<td><b>组团社：</b></td>
			<td style="text-align:left;"><c:if test="${group.groupMode==0 }">散客团</c:if>                 
	    	<c:if test="${group.groupMode!=0 }">${supplierName }</c:if></td>
		</tr>
		<tr>
			<td><b>人数：</b></td>
			<td style="text-align:left;">${group.totalAdult}大${group.totalChild }小${group.totalGuide }陪&nbsp;共${group.totalAdult+group.totalChild +group.totalGuide }人</td>
			<td><b>操作计调：</b></td>
			<td style="text-align:left;">${group.operatorName }</td>
		</tr>
		<tr>
			<td><b>产品名称：</b></td>
			<td colspan="3" style="text-align:left;"><input type="hidden" id="brandId" value="${group.prudctBrandId }" />
			【${group.productBrandName }】${group.productName }</td>			
		</tr>
	</table>
	</dd>	
	<dd class="clear" />
</dl>
 
	<div id="supplierRequirement">
		
	</div>
 


<p class="p_paragraph_title">
<a href="javascript:;" class="tab-show"><b>行程信息</b> <span class="caret"></span></a>
</p>
<dl class="p_paragraph_content dn">
	<dd>
		<div class="tab_journey pl-20 pr-20 w-1100">
			<table border="" cellspacing="0" cellpadding="0"
				class="w_table">
				<col width="5%" />
				<col width="" />
				<col width="15%" />
				<col width="10%" />
				<thead>
					<th>天数</th>
					<th>行程</th>
					<th>餐饮</th>
					<th>酒店</th>
				</thead>
				<c:forEach items="${routeList }" var="route" varStatus="st">
					<tr>				
						<td><fmt:formatDate value="${route.groupRoute.groupDate }" pattern="yyyy-MM-dd"/></td>
						<td class="td_journey">
							<p class="trafficFont">
								交通：
								<c:forEach items="${route.groupRouteTrafficList }" var="traffic">
									 <span class="blue"><b>${traffic.cityDeparture }</b></span>
									 <c:choose>
                                            <c:when test="${traffic.typeId == 1}">
                                                <img src = "<%=staticPath%>/assets/img/plane.png" class = "img_traffic"/>
                                            </c:when>
                                            <c:when test="${traffic.typeId == 2}">
                                                <img src = "<%=staticPath%>/assets/img/train.png" class = "img_traffic"/>
                                            </c:when>
                                            <c:when test="${traffic.typeId == 3}">
                                                <img src = "<%=staticPath%>/assets/img/bus.png" class = "img_traffic"/>
                                            </c:when>
                                            <c:when test="${traffic.typeId == 4}">
                                                <img src = "<%=staticPath%>/assets/img/ship.png" class = "img_traffic"/>
                                            </c:when>
                                     </c:choose> 
									 <span class="grey">(${traffic.miles}km,${traffic.duration}h)</span>
									 <span class="blue"><b>${traffic.cityArrival }</b></span>									 								
								</c:forEach>
							</p>
							<p>
								详情：<span class="grey">${route.groupRoute.routeDesp}</span>
							</p>
							<p class="jingdian">
                                <c:forEach items="${route.groupRouteOptionsSupplierList}" var="scenic">
                                    <c:if test="${scenic.supplierType eq 5}"><span>${scenic.supplierName}</span></c:if>
                                </c:forEach>
							</p>
						</td>
						<td class="td_food">
                            <p><span><b class="mr-5">早餐</b></span>
                                ${route.groupRoute.breakfast}
                            </p>

                            <p><span><b class="mr-5">午餐</b></span>
                                ${route.groupRoute.lunch}
                            </p>

                            <p><span><b class="mr-5">晚餐</b></span>
                               ${route.groupRoute.supper}
                            </p>
						</td>
						<td>${route.groupRoute.hotelName}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</dd>
</dl>
<p class="p_paragraph_title">
<a href="javascript:;" class="tab-show"><b>备注信息</b> <span class="caret"></span></a>
</p>
<dl class="p_paragraph_content dn">
	<dd>
		<div class="dd_left">
			<b>服务标准：</b>
		</div>
		<div class="dd_right position_relative">
			<!-- <div class="dd_text"> -->
			<div>
				<p>
					${group.serviceStandard }</p>
				<br />
			</div>
			<%-- <c:if test="${fn:length(group.serviceStandard)>150}">

			<div class="dd_more"><a href="javascript:void(0)" class="blue">更多</a></div>
			</c:if>  --%>
			
		</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>备注：</b>
		</div>
		<div class="dd_right position_relative">
			<!-- <div class="dd_text"> -->
			<div>
				<p>
					${group.remark }</p>
				<br />
			</div>
			<%-- <c:if test="${fn:length(group.remark)>150}">

			<div class="dd_more"><a href="javascript:void(0)" class="blue">更多</a></div>
			</c:if>  --%>
		</div>
		<div class="clear"></div>
	</dd>
	<dd>
		<div class="dd_left">
			<b>内部备注：</b>
		</div>
		<div class="dd_right position_relative">
			<!-- <div class="dd_text"> -->
			<div>
				<p>
					${group.remarkInternal }
				</p>
				<br />
			</div>
			<%-- <c:if test="${fn:length(group.remarkInternal)>150}">

			<div class="dd_more"><a href="javascript:void(0)" class="blue">更多</a></div>
			</c:if>  --%>
		</div>
		<div class="clear"></div>
	</dd>
</dl>

<script type="text/javascript">
	$(function(){
		var stype=$("#stype").val();
		if(!stype){
			return;
		}
		if(stype==4){
			 $("#supplierRequirement").load("<%=ctx%>/booking/bookingReq2.htm?groupId="+$("#groupId").val()+"&supplierType="+stype);
		 }
		 else if(stype==2||stype==3||stype==8||stype==9||stype==10){
			 $("#supplierRequirement").load("<%=ctx%>/booking/bookingReq.htm?groupId="+$("#groupId").val()+"&supplierType="+stype);
		 }
	})
	
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
		
		//隐藏表格		
		$(".tab-show").live("click",function () {
			$(this).closest("p").next("dl").slideToggle(200)
		})
		
	}) 
</script>




