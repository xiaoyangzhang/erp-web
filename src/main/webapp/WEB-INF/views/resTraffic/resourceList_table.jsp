<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String staticPath = request.getContextPath();
%>
<!-- 	<SCRIPT type="text/javascript">
	$(function(){	
		alert($("#orderId").val())
	})
	</SCRIPT> -->

	<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="4%"/>
    <col width="5%"/>
    <col width="10%"/>
    <col width="7%"/>
    <col width="11%"/>
    
    <col width="5%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="7%"/>
    <col />
    <col width="4%"/>
    <col width="4%"/>
    <thead>
    <tr>
    	<th>序号<i class="w_table_split"></i></th>
        <th>类型<i class="w_table_split"></i></th>
        <th>资源名称<i class="w_table_split"></i></th>
        <th>日期<i class="w_table_split"></i></th>
        <th>交通信息<i class="w_table_split"></i></th>
        <th>成本价<i class="w_table_split"></i></th>
        <th>总数量<i class="w_table_split"></i></th>
        <th>机动位<i class="w_table_split"></i></th>
        <th>已售<i class="w_table_split"></i></th>
        <th>取消<i class="w_table_split"></i></th>
        <th>剩余<i class="w_table_split"></i></th>
        <th>出票<i class="w_table_split"></i></th>
        <th>截止报名时间<i class="w_table_split"></i></th>
        <th>备注<i class="w_table_split"></i></th>
        <th>状态<i class="w_table_split"></i></th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${pageBean.result}" var="res" varStatus="status">
        <tr id="${res.id }">
        	<td>${status.count }</td>
            <td><c:if test="${res.resMethod=='AIR'}">飞机</c:if>
            	<c:if test="${res.resMethod=='TRAIN'}">火车</c:if>
            	<c:if test="${res.resMethod=='CAR'}">汽车</c:if>
            	</td>
 			<td>${res.resName }</td>
            <td>${res.dateStart }</td>
            <td style="text-align:left"> ${res.lineInfo } </td>
       
            <td><fmt:formatNumber value="${res.costPrice}" pattern="#.##"/></td>            
            <td><a href="javascript:void(0)"   onclick="stocklog(this,'${res.id }')" class="def">${res.numStock }</a></td>            
            <td>${res.numDisable } </td>
            <td>${res.numSold } </td>   
             <td>${res.numCancel + res.numClean }</td>  
            <td>${res.numBalance } </td>   
            <td><a href="javascript:void(0)"   onclick="ticketInfo(this,'${res.id }')" class="def">出票</a></td>   
            <td><fmt:parseDate value="${fn:replace(res.dateLatest, ':00.0', ':00')}" pattern="yyyy-MM-dd HH:mm:ss" var="date1"></fmt:parseDate>  
            	<fmt:formatDate pattern="yyyy-MM-dd" value="${date1}" /><br/>
            	<fmt:formatDate pattern="HH:mm:ss" value="${date1}" /> 
            </td>   
            <td style="text-align:left;">${res.remark }</td>
            <td ><c:if test="${res.state=='1'}"><span class='log_action insert'>上架</span></c:if>
            	 <c:if test="${res.state=='0'}"><span class='log_action delete'>下架</span></c:if>
            </td>                     
            <td>
            <div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
						<a href="javascript:void(0)" class="def" onclick="editResource(${res.id})" > 修改</a>
                		<a href="javascript:stateChange_show(${res.id},${res.state});" class="def">状态</a>
                		<a href="javascript:goOrder(${res.id });" class="def">复制</a>
             			<a href="javascript:void(0)"onclick="toProductBindingList(${res.id})"class="def">绑定产品</a>
                		<a href="javascript:stockChange_show(${res.id});" class="def">库存调整</a>
                		<a href="javascript:goLogStock(${res.id }, 'traffic_res_stocklog');" class="def">库存日志</a>
                		<a href="javascript:goLog(${res.id }, 'traffic_res');" class="def">操作日志</a>
					</div>
				</div>
            </td>
        </tr>
			<c:set var="numStock" value="${numStock+res.numStock}" />
			<c:set var="numDisable" value="${numDisable+res.numDisable}" />
			<c:set var="numReserved" value="${numReserved+res.numReserved}" />
			<c:set var="numSold" value="${numSold+res.numSold}" />
			<c:set var="numBalance" value="${numBalance+res.numBalance}" />
			<c:set var="numCancel" value="${numCancel+res.numCancel+res.numClean}" />
	
    </c:forEach>
    </tbody>
    <tfoot>
		<tr class="footer1">
			<td></td>
            <td></td>
 			<td >合计</td>
            <td></td>
            <td></td>
            <td></td>            
            <td>${numStock }</td>            
            <td>${numDisable } </td>
            <td>${numSold } </td>   
              <td>${numCancel }</td> 
            <td>${numBalance } </td>   
            <td></td>   
            <td><td>
            <td></td>		
            <td></td>	
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>

<script type="text/javascript">
	function stocklog(obj,resId){
		newWindow("资源销售明细","resTraffic/resDetails.do?resId="+resId);
	}
	
	function ticketInfo(obj,resId){
		newWindow("订单出票","resTraffic/ticketInfo.do?resId="+resId);
	}
	
	function goOrder(resId){
		showInfo("资源复制","540px","460px","copyRes.do?resId="+resId);
	}
	
	function goLog(resId, tableName){
		showInfo("日志","950px","550px","<%=staticPath%>/basic/singleList.htm?tableName=" + tableName + "&tableId=" + resId);
	}
	
	function goLogStock(resId, tableName){
		showInfo("库存日志","950px","550px","<%=staticPath%>/basic/singleList.htm?tableName=" + tableName + "&tableParentId=" + resId);
	}
	
	function showInfo(title,width,height,url){
	 	layer.open({ 
	 		type : 2,
	 		title : title,
	 		shadeClose : true,
	 		shade : 0.5, 		
	 		area : [width,height],
	 		content : url
	 	});
	 }
	
	function editResource(id){
		newWindow('编辑资源','resTraffic/edit.do?id='+id);
	}
	
	function toProductBindingList(resId){
		newWindow('编辑资源','resTraffic/toProductBindingList.do?resId='+resId);
	}
</script>