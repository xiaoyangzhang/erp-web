<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>查看</title>
    
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/finance/finance.css"/>
</head>
<body>
<!--startprint1-->
    <div class="p_container" >
    <form id="verifyBillForm">

	     <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="w-1100 pt-20 pl-20">
	    			<div class="dan_header">
	    				<div class="h_grey mt-15 mb-10 ml-135">
	    					<div>
	    						<div class="n_left">申请人：</div>
	    						<div class="n_right">${applicant}(计调)</div>
	    						<div class="clear"></div>
	    					</div>	    							    					
	    					<div>
	    						<div class="n_left">申请时间：</div>
	    						<div class="n_right"><fmt:formatDate value="${appliTime}" pattern="yyyy-MM-dd HH:mm"/></div>
	    						<div class="clear"></div>
	    					</div>
	    				</div>
	    				<c:if test="${appliState == 'RECEIVED' or appliState == 'VERIFIED'}">
	    				<div class="h_grey mt-15 mb-10 ml-135">
	    					<div>
	    						<div class="n_left">领单人：</div>
	    						<div class="n_right">${guideName}(导游)</div>
	    						<div class="clear"></div>
	    					</div>	    							    					
	    					<div>
	    						<div class="n_left">领单时间：</div>
	    						<div class="n_right"><fmt:formatDate value="${apprTime}" pattern="yyyy-MM-dd HH:mm"/></div>
	    						<div class="clear"></div>
	    					</div>
	    				</div>
	    				</c:if>
	    				<c:if test="${appliState == 'VERIFIED'}">
	    				<div class="h_grey mt-15 mb-10 ml-135">
	    					<div>
	    						<div class="n_left">销单人：</div>
	    						<div class="n_right">${guideName}(导游)</div>
	    						<div class="clear"></div>
	    					</div>	    							    					
	    					<div>
	    						<div class="n_left">销单时间：</div>
	    						<div class="n_right"><fmt:formatDate value="${veriTime}" pattern="yyyy-MM-dd HH:mm"/></div>
	    						<div class="clear"></div>
	    					</div>
	    				</div>
	    				</c:if>
	    				<div class="clear"></div>
	    				<div class="grey_bor">
	    					<div class="bg_grey1"></div>
	    					<c:if test="${appliState == 'RECEIVED' or appliState == 'VERIFIED'}">
		    				<div class="bg_grey2"></div>
		    				</c:if>
		    				<c:if test="${appliState == 'VERIFIED'}">
		    				<div class="bg_grey3"></div>
		    				</c:if>
	    				</div>	    				
	    			</div>
	    		</dd>	    		
	    		<dd class="w-1100 pt-20 pl-20">
	    			<div class="dan_b">
	    				<div class="g_num"><b>团号：${reqpm.groupCode}</b></div>
	    				<c:forEach items="${financeBillDetailList}" var="item" >
	    				<div class="tk_con">
	    				<input type="hidden" name="id" value="${item.id }">
	    					<div class="tk_l pt-40 pb-40">
	    						<c:forEach items="${billTypeList}" var="dicBill">
									<c:if test="${dicBill.code eq item.bill_type}">
										<p class="p3"><b>${dicBill.value}</b></p>
									</c:if>
								</c:forEach>
	    					</div>
	    					<div class="tk_r">
	    						<ul class="mt-15">
	    							<li class="w-50"><span class="tag-h bg-b">申请</span></li>
	    							<li class="w-160">
	    								<div class="n_left">数量：</div>
	    								<div class="n_right">${item.num }</div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-300">
	    								&nbsp;
	    							</li>
	    							<li class="w-400">
	    								<div class="n_left">备注：</div>
	    								<div class="n_right"><input type="text" readonly="readonly"  id="" value="${item.remark }" class="w-300"/></div>
	    								<div class="clear"></div>
	    							</li>
	    							<div class="clear"></div>
	    						</ul>
	    						<c:if test="${appliState == 'RECEIVED' or appliState == 'VERIFIED'}">
	    						<ul>
	    							<li class="w-50"><span class="tag-h bg-y">领单</span></li>
	    							<li class="w-160">
	    								<div class="n_left">领单数量：</div>
	    								<div class="n_right">${item.received_num }</div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-300">
	    								<div class="n_left">单据号：</div>
	    								<div class="n_right"><input type="text" readonly="readonly"  id="" value="${item.bill_num_receive }" class="w-200"/></div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-400">
	    								<div class="n_left">备注：</div>
	    								<div class="n_right"><input type="text" readonly="readonly"  id="" value="${item.remark_receive }" class="w-300"/></div>
	    								<div class="clear"></div>
	    							</li>
	    							<div class="clear"></div>
	    						</ul>
	    						</c:if>
	    						<c:if test="${appliState == 'VERIFIED'}">
	    						<ul>
	    							<li class="w-50"><span class="tag-h bg-o">销单</span></li></li>
	    							<li class="w-160">
	    								<div class="n_left">销单数量：</div>
	    								<div class="n_right">
	    									${item.returned_num }
	    								</div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-300">
	    								<div class="n_left">单据号：</div>
	    								<div class="n_right"><input type="text" readonly="readonly"  id="" value="${item.bill_num_return }" class="w-200"/></div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-400">
	    								<div class="n_left">备注：</div>
	    								<div class="n_right"><input type="text" readonly="readonly"  id="" value="${item.remark_return }" class="w-300"/></div>
	    								<div class="clear"></div>
	    							</li>
	    							<div class="clear"></div>
	    						</ul>
	    						</c:if>    							    						
	    					</div>
	    					<div class="clear"></div>
	    				</div>
	    				</c:forEach>
	    				<div class="dan_btn mt-30">
		    				<c:if test="${reqpm.isPrint ne true}">
		    					<a class="button  button-primary button-small mr-20" href="<%=staticPath%>/finance/checkBillPrint.htm?id=${reqpm.id }&guideId=${reqpm.guideId }&groupCode=${reqpm.groupCode}&appliState=${reqpm.appliState}&isPrint=true" target="_blank">打印</a>
<%-- 				    			<a class="button  button-primary button-small mr-20"  onclick="newWindow('领单打印','<%=staticPath%>/finance/checkBillPrint.htm?id=${reqpm.id }&guideId=${reqpm.guideId }&groupCode=${reqpm.groupCode}&appliState=${reqpm.appliState}')" >打印预览</a>
 --%>	    						<a href="javascript:closeWindow()" class="button  button-primary button-small mr-20" >关闭</a>
				    		</c:if>
	    				</div>
	    			</div>
	    		</dd>
	    	</dl>
	    	           
	    </div>
	  </form>
    </div>
    <!--endprint1-->
    <div id="tableDiv"></div>  
</body>
<%-- <script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script> --%>
<script type="text/javascript">


</script>
</html>
