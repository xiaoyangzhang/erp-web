<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>下接社统计</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<script type="text/javascript" src="<%=staticPath %>/assets/js/chart/highcharts.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form id="queryForm" action="queryGroupNumber.htm" method="post">
					<input type="hidden" name="type" value="1"/>
					<dd class="inl-bl">
						<div class="dd_left">
							<select name="dateType" id="dateType">
								<option value="1" <c:if test="${groupOrder.dateType==1 }">selected="selected"</c:if> >出团日期</option>
								<option value="2" <c:if test="${groupOrder.dateType==2 }">selected="selected"</c:if> >输单日期</option>
							</select>
						</div>
						<div class="dd_right grey">
							<input name="startTime" id="startTime" type="text" class="Wdate" value="${groupOrder.startTime }" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
							~
							<input name="endTime" id="endTime" type="text" class="Wdate" value="${groupOrder.endTime }" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<input name="productBrandName" id="productBrandName" type="text" value="${groupOrder.productBrandName}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">数据类型:</div>
						<div class="dd_right grey">
							<select name="dataType" id="dataType">
								<option value="1" <c:if test="${dataType==1 }">selected="selected"</c:if>>订单数</option>
								<option value="0" <c:if test="${dataType==0 }">selected="selected"</c:if>>人数</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">订单类型:</div>
						<div class="dd_right grey">
							<select name="orderType" id="orderType">
								<option value="" >全部</option>
								<option value="-1" <c:if test="${groupOrder.orderType==-1 }">selected="selected"</c:if>>一地散</option>
								<option value="0" <c:if test="${groupOrder.orderType==0 }">selected="selected"</c:if>>散客</option>
								<option value="1" <c:if test="${groupOrder.orderType==1 }">selected="selected"</c:if>>团队</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">
							
						</div>
						<div class="dd_right">
						部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						</div>    		
						<div class="dd_right">
						计调:<select name="operType" id="operType">
								<option value="1" <c:if test="${groupOrder.operType==1 }">selected="selected"</c:if>  >销售计调</option>
								<option value="2" <c:if test="${groupOrder.operType==2 }">selected="selected"</c:if>>操作计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName"
								value="${groupOrder.saleOperatorName}" stag="userNames" readonly="readonly"  onclick="showUser()"/> <input
								name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden"
								value="${groupOrder.saleOperatorIds}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">显示条数:</div>
						<div class="dd_right grey">
							<select name="showNum" id="showNum">
								<option value="10" <c:if test="${groupOrder.showNum==10 }">selected="selected"</c:if>>10</option>
								<option value="20" <c:if test="${groupOrder.showNum==20 }">selected="selected"</c:if>>20</option>
								<option value="30" <c:if test="${groupOrder.showNum==30 }">selected="selected"</c:if>>30</option>
								<option value="50" <c:if test="${groupOrder.showNum==50 }">selected="selected"</c:if>>50</option>
								<option value="100" <c:if test="${groupOrder.showNum==100 }">selected="selected"</c:if>>100</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="submit"  class="button button-primary button-small">查询</button>
							<a href="javascript:void(0)" onclick="toPreview(this)"  class="button button-primary button-small" >打印预览</a>
						</div>
						<div class="clear"></div>
					</dd>
				</form>
			</dl>
			<dl class="p_paragraph_content">
				<div id="container" style="width:100%;height:100%;">
				</div>
			</dl>
		</div>
	</div>
</body>
</html>
<script type="text/javascript">

function toPreview(obj){
	
	$(obj).attr("target","_blank").attr("href","../query/expGroupNumber.do?dateType="+$("#dateType").val()+"&startTime="+$("#startTime").val()
			+"&endTime="+$("#endTime").val()+"&productBrandName="+$("#productBrandName").val()+"&orderType="+$("#orderType").val()+"&operType="+$("#operType").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()+"&dataType="+$("#dataType").val()
			+"&orgIds="+$("#orgIds").val()+"&showNum="+$("#showNum").val());
}

$(function () {	
    $('#container').highcharts({
    	chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        title: {
            text: '客户团量分析'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}：{point.y}'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '比例',
            data: [
                ${jsonStr}
            ]
        }]
    });
});	
</script>
