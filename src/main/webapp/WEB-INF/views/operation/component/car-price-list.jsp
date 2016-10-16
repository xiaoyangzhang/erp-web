<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript">
	function getPrice(){
		return $("input[name='price']:checked").val();
	}
</script>
</head>
	<body>

	    	<dl class="">
	    		<dd>
                	<table cellspacing="0" cellpadding="0" class="w_table" > 
                		
						<col width="20%" />
						<col width="9%" />
						<col width="9%" />
						<col width="30%" />
						<col width="6%" />
						<col />
			        	<thead>
			            	<tr>
			             		<th>日期<i class="w_table_split"></i></th>
			             		<th>车型<i class="w_table_split"></i></th>
			             		<th>座位数<i class="w_table_split"></i></th>
			             		<th>产品价<i class="w_table_split"></i></th>
			             		<th>优先级<i class="w_table_split"></i></th>
			             		<th>备注</th>
			             		
			             	</tr>
			             </thead>
			             <tbody> 
			             	<c:forEach items="${priceList}" var="price" varStatus="v">
			             		<tr> 
				                  <td>${price.startDateStr}至${price.endDateStr}</td> 
				                  <td>${price.itemTypeName }</td>
				                  <td>${price.itemType2Name}~${price.itemType3Name}</td>
				                  <td style="text-align:left">
				                  	<c:if test="${price.extList!=null }">
					                  	<ul>				                  	
					                  		<c:forEach items="${price.extList}" var="ext">
							                  	<li >
							                  		<label><input type="radio" name="price" value='${ext.price }'/>
							                  		${ext.price }【${ext.brandName }】</label>
							                  	</li>	                  	
					                  		</c:forEach>
					                  	</ul>				                  	
				                  	</c:if>
				                  </td>
				                  <td>${price.datePriority }</td> 
				                  <td style="text-align:left">${price.note }</td> 
				                  
			               		</tr>
			             	</c:forEach>
			             </tbody>
	          		 </table>
	    		</dd>
	    	</dl>	
   
	</body>
</html>
