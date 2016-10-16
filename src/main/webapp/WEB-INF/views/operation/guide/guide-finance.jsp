<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>导游列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
</head>
<body>
    <div class="p_container" >
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
   				<dd>
   					<div class="dd_left">团号：</div>
   					<div class="dd_right">${group.groupCode }(
   					<c:if test="${group.groupMode==0 }">散客团</c:if>                 
	    			<c:if test="${group.groupMode!=0 }">团队</c:if>)</div>
   					<div class="clear"></div>
   				</dd>
   				<dd>
   					<div class="dd_left">产品名称：</div>
   					<div class="dd_right">【${group.productBrandName }】${group.productName }</div>
   					<div class="clear"></div>
   				</dd>
   				<dd>
   					<div class="dd_left">组团社：</div>
   					<div class="dd_right">${supplierName }</div>
   					<div class="clear"></div>
   				</dd>
   				<dd>
   					<div class="dd_left">总人数：</div>
   					<div class="dd_right">${group.totalAdult+group.totalChild }人</div>
   					<div class="clear"></div>
   				</dd>
   				
   				<dd>
   					<div class="dd_left">导游：</div>
   					<div class="dd_right">${guidesVo.guide.guideName}（${guidesVo.guide.guideMobile}）</div>
   					<div class="clear"></div>
   				</dd>
   				
   				<dd>
   					<div class="dd_left">团计调：</div>
   					<div class="dd_right">${group.operatorName}</div>
   					<div class="clear"></div>
   				</dd>
   				
   				<dd>
   					<div class="dd_left">上/下团时间：</div>
   					<div class="dd_right"> 
   					<c:forEach items="${guidesVo.guideTimes}" var="times" varStatus="i">
	    							${times.timeStart}
	    						 ~ ${times.timeEnd}<br />
	    						</c:forEach></div>
   					<div class="clear"></div>
   				</dd>
   				<dd>
   					<div class="dd_left">备注：</div>
   					<div class="dd_right">${guidesVo.guide.remark}</div>
   					<div class="clear"></div>
   				</dd>
	    	</dl>
	    	
            <dl class="p_paragraph_content">
            	<dd>
            		<ul class="con_box">
            		 <c:forEach items="${list}" var="list">
            			<c:if test="${list.supplierType eq 5 }"><a href="financeSupplierView.htm?groupId=${groupId }&bookingId=${bookingId}&supplierType=5&fromfin=${fromfin}"><li><p>景点门票</p><p>￥<fmt:formatNumber value="${list.total }" type="number" pattern="0.00"/></p></li></a></c:if>
            			<c:if test="${list.supplierType eq 3 }"><a href="financeSupplierView.htm?groupId=${groupId }&bookingId=${bookingId}&supplierType=3&fromfin=${fromfin}"><li><p>用房</p><p>￥<fmt:formatNumber value="${list.total }" type="number" pattern="0.00"/></p></li></a></c:if>
            			<c:if test="${list.supplierType eq 2 }"><a href="financeSupplierView.htm?groupId=${groupId }&bookingId=${bookingId}&supplierType=2&fromfin=${fromfin}"><li><p>用餐</p><p>￥<fmt:formatNumber value="${list.total }" type="number" pattern="0.00"/></p></li></a></c:if>
            			<c:if test="${list.supplierType eq 4 }"><a href="financeSupplierView.htm?groupId=${groupId }&bookingId=${bookingId}&supplierType=4&fromfin=${fromfin}"><li><p>用车</p><p>￥<fmt:formatNumber value="${list.total }" type="number" pattern="0.00"/></p></li></a></c:if>
            			<c:if test="${list.supplierType eq 120 }"><a href="financeSupplierView.htm?groupId=${groupId }&bookingId=${bookingId}&supplierType=120&fromfin=${fromfin}"><li><p>其他收入</p><p>￥<fmt:formatNumber value="${list.total }" type="number" pattern="0.00"/></p></li></a></c:if>
            			<c:if test="${list.supplierType eq 121 }"><a href="financeSupplierView.htm?groupId=${groupId }&bookingId=${bookingId}&supplierType=121&fromfin=${fromfin}"><li><p>其他支出</p><p>￥<fmt:formatNumber value="${list.total }" type="number" pattern="0.00"/></p></li></a></c:if>
            			
            		</c:forEach>
<%--             			<a href="financeSupplierGuideView.htm?groupId=${groupId }&bookingId=${bookingId}&fromfin=${fromfin}"><li><p>购物佣金</p><p>￥<fmt:formatNumber value="${countCommision}" type="number" pattern="0.00"/></p></li></a>
 --%>            		</ul>
            	</dd>
            	<dd>
            		<div class="money_count ml-30 mt-30">
            			<div class=""><b>报账总额：<fmt:formatNumber value="${count}" type="number" pattern="0.00"/>元</b></div>
            		</div>
            	</dd>
            	<dd>
            		<div class="ml-30 mt-50">
            			状态:
            			<c:if test="${guidesVo.guide.stateBooking eq 0 || empty guidesVo.guide.stateBooking}">未提交</c:if>
            			<c:if test="${guidesVo.guide.stateBooking eq 1 }">计调处理中</c:if>
            			<c:if test="${guidesVo.guide.stateBooking eq 2 }">财务处理中</c:if>
            			<c:if test="${guidesVo.guide.stateBooking eq 3 }">已报账</c:if>
            		</div>
            	</dd>
            	<dd>
            		<div class="btn ml-30 mt-50">
            		
            			<c:if test="${reqpm.isHidden ne true}">
	            			<c:if test="${guidesVo.guide.stateBooking eq 0  || empty guidesVo.guide.stateBooking || guidesVo.guide.stateBooking eq 1 }">
	            				<button onclick="submit2fin()" class="button button-rounded button-primary button-small mr-20">提交财务</button>
	            			</c:if>
	            			<c:if test="${guidesVo.guide.stateBooking eq 2 && !empty fromfin && fromfin eq 1 }">
		            			<c:if test="${guidesVo.guide.stateFinance ne 1 }">
		            				<button onclick="audit()" class="button button-rounded button-primary button-small mr-20">审核通过</button>
		            				<button onclick="reject()" class="button button-rounded button-primary button-small mr-20">驳回</button>
		            			</c:if>
		            			<c:if test="${guidesVo.guide.stateFinance eq 1 }">
									<button onclick="delAudit()" class="button button-rounded button-primary button-small mr-20">取消审核</button>
								</c:if>
	            			</c:if>
	            		</c:if>
  						<a class="button  button-primary button-rounded button-small mr-20" href="<%=staticPath%>/bookingGuide/printDetail.htm?isHidden=true&isPrint=true&groupId=${groupId }&bookingId=${bookingId}" target="_blank">打印</a>
	            		<button onclick="closeWindow()"class="button button-primary button-rounded button-small">关闭</button>
            		</div>
            	</dd>
            </dl>
	    </div>
    </div> 
<script type="text/javascript">

	// 提交计调
	function submit2op(){
		YM.post("../finance/guide/submit2op.do",{billId:'${guidesVo.guide.id}'},function(data){
			$.success("提交成功");
			location.reload();
		});
	}
	// 提交财务
	function submit2fin(){
		YM.post("../finance/guide/submit2fin.do",{billId:'${guidesVo.guide.id}'},function(data){
			$.success("提交成功");
			location.reload();
		});
	}
	// 审核通过
	function audit(){
		YM.post("../finance/guide/auditGuideBill.do",{billId:'${guidesVo.guide.id}'},function(data){
			$.success("审核成功");
			location.reload();
		});
	}
	// 取消审核
	function delAudit(){
		YM.post("../finance/guide/delAuditGuideBill.do",{billId:'${guidesVo.guide.id}'},function(data){
			$.success("取消审核成功");
			location.reload();
		});
	}
	// 驳回
	function reject(){
		YM.post("../finance/guide/rejectGuideBill.do",{billId:'${guidesVo.guide.id}'},function(data){
			$.success("驳回成功");
			location.reload();
		});
	}
</script>
</body>
</html>
