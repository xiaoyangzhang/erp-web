<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<%@ include file="../../../include/top.jsp"%>
</head>
	<body>
		<p class="p_paragraph_title">
			<b>接送信息</b>
		</p>
		<div class="p_container" >
			
		    		<dd>
		    			<div class="dd_right" style="width:98%">
		                	<table cellspacing="0" cellpadding="0" class="w_table" > 
					        	<thead>
					            	<tr>
					             		<th>序号<i class="w_table_split"></i></th>
					             		<th>接送<i class="w_table_split"></i></th>
					             		<th>出发<i class="w_table_split"></i></th>					             		
					             		<th>到达<i class="w_table_split"></i></th>					             		
					             		<th>是否直达<i class="w_table_split"></i></th>
					             		<th>目的地</th>
					             	</tr>
					             </thead>
					             <tbody> 
					             	<c:forEach items="${transportList}" var="got" varStatus="v">
					             		<tr> 
						                  <td>${v.index+1}</td>
						                  <td>
						                  	<c:if test="${got.type==0 }">接</c:if> 
						                  	<c:if test="${got.type==1 }">送</c:if>/
						                  	<c:forEach items="${transportTypeList}" var="v">
												<c:if test="${v.id==got.method }">${v.value }</c:if>
											</c:forEach>
											<br>${got.classNo}
						                  </td>
						                  <td>${got.departureCity}/${got.departureStation}<br>${got.departureTime}</td>						                 
						                  <td>${got.arrivalCity}/${got.arrivalStation}<br>${got.arrivalTime}</td>
						                  <td>
						                  	<c:if test="${got.isDirect==0 }">否</c:if> 
						                  	<c:if test="${got.isDirect==1 }">是</c:if>
						                  </td>
						                  <td>${got.destination}</td>						                  
					               		</tr>
					             	</c:forEach>
					             </tbody>
			          		 </table>
		    			
		    		</dd>
		    	</dl>
		    
		</div>
	</body>
</html>
