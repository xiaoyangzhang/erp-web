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
			<b>客人名单</b>
		</p>
		<div class="p_container" >
		    	<dl class="p_paragraph_content">
		    		<dd>
		                	<table cellspacing="0" cellpadding="0" class="w_table" > 
					        	<thead>
					            	<tr>
					             		<th>序号<i class="w_table_split"></i></th>
					             		<th>姓名<i class="w_table_split"></i></th>
					             		<th>性别<i class="w_table_split"></i></th>
					             		<th>年龄<i class="w_table_split"></i></th>
					             		<th>籍贯<i class="w_table_split"></i></th>
					             		
					             		<th>证件号码<i class="w_table_split"></i></th>
					             		<th>手机号<i class="w_table_split"></i></th>
					             		
					             		<th>备注<i class="w_table_split"></i></th>
					             	</tr>
					             </thead>
					             <tbody> 
					             	<c:forEach items="${guestList}" var="gog" varStatus="v">
					             		<tr> 
						                  <td>${v.index+1}</td>
						                  <td>${gog.name}</td> 
						                  <td>
						                  	<c:if test="${gog.gender==1}">男</c:if>
						                  	<c:if test="${gog.gender==0}">女</c:if>
						                  </td>
						                  <td>${gog.age}</td>
						                  <td>${gog.nativePlace}</td>
						                 
						                  <td>${gog.certificateNum}</td> 
						                  <td>${gog.mobile}</td> 
						                  
						                  <td>${gog.remark}</td>						                  
					               		</tr>
					             	</c:forEach>
					             </tbody>
			          		 </table>
		    			
		    		</dd>
		    	</dl>	
		    	</div>	   
	</body>
</html>
