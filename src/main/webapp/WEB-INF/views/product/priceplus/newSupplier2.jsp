<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>设置产品-组团社权限（资源交通管理【包机】->绑定产品->权限）</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
</head>
<body>
   <div class="p_container" >
	    <div class="p_container_sub" id="tab1">
	    	<p class="p_paragraph_title"><b>组团社列表</b>-${productName }</p>
	    	<dl class="p_paragraph_content">	    
	            <button onclick="selectSupplier()" class="button button-primary button-small mt-20 ml-20">添加客户</button>
    	        <a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
            </dl>
            <dl class="p_paragraph_content" style="padding-left:20px;">
            <form id="searchForm" method="post" action="supplier_list2.htm">
	    		组团社：<input type="hidden" name="productId" value="${productId }" />
	    		<input type="hidden" name="groupId" value="${groupId }" />
	    		<input type="text" id="supplierName" name="supplierName" value="${supplierName }" />
	    		区域：<input type="text" id="city" name="city" value="${city }" />
	    		<button type="submit" class="button button-primary button-small mt-20 ml-20">查询</button>
	    	</form>
	    	</dl>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_right" style="width:60%;padding-left:20px;">
                     <table cellspacing="0" cellpadding="0" class="w_table" id="priceTable" > 
		             <col width="8%" /><col width="8%" /><col width="15%" /><col width="" /><col width="12%" />
		             <thead>
		             	<tr>
		             		<!-- <th><input type="checkbox" class="all"/><i class="w_table_split"></i></th> -->
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>区域<i class="w_table_split"></i></th>
		             		<th>组团社<i class="w_table_split"></i></th>
		             		<th>最后更新日期<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody id="tbSupplier"> 
			             <input type="hidden" name="productId" value="${productId }"/>
			             <c:forEach items="${groupSuppliers}" var="gs" varStatus="status">
				               <tr id="${gs.id }"> 
				               		<input type="hidden" name="supplierId" value="${gs.supplierId }"/>
				               		<%-- <td><input type="checkbox" name="productSupplierId" value="${gs.id }"/></td> --%>
				            		<td>${status.index+1}</td>
				               		<td>${ gs.province}${gs.city }</td>
				                  <td>${ gs.supplierName}</td>
				                  <td><fmt:formatDate value="${ gs.updateTime}" pattern="yyyy-MM-dd"/> </td>
				                  <td> <a onclick="delPsupplier(${gs.id})" class="def" href="#">删除</a> </td>
				               </tr>
			                </c:forEach>		         
		             </tbody>
	          		</table>
	    			</div>
					<div class="clear"></div>
	    		</dd>
            </dl>
            </div>
            </div>    	
</body>

<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>

<script type="text/javascript">
$(function(){
	// fixHeader(30);
})

function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择客户',
		content : '<%=path%>/component/supplierList.htm?page=1&type=multi&supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选择客户");
				return false;
			}
			var sidArr = new Array();
			$("#tbSupplier tr").each(function(){
				sidArr.push($(this).find("input[name='supplierId']").val());
			})
			
			var dataAry = [];
			for(var i=0;i<arr.length;i++){
				//console.log("supplier_id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
				if(!supplierExist(sidArr,arr[i].id)){
					dataAry.push({'productId':${productId},'groupId':${groupId},"supplierId":arr[i].id,"supplierName":arr[i].name,"province":arr[i].province,"city":arr[i].city,"area":arr[i].area,"town":arr[i].town });					
				}
			}
			if(dataAry.length==0){
				return false;
			}			
			$.ajax({
				 url :"supplierSave.do",
				    type :"POST", 
				    dataType:"json",
				    data:{data:JSON.stringify(dataAry)},
				    success : function(data) {
				    	  if (data.success) {
				    		 $.success('操作成功',function(){
				    			window.location.href="<%=path%>/product/price/supplier_list2.htm?productId=${productId}&groupId=${groupId}";
							});
                         
                      } else {
                    	  $.error(data.msg);
                      }
				    },
				error:function(e){
					$.error("服务器处理错误");
				}
			});
	    }
	});
}

function supplierExist(sidArr,supplierId){
	if(sidArr.length==0){
		return false;
	}
	for(var i=0,len=sidArr.length;i<len;i++){
		if(sidArr[i]==supplierId){
			return true;
		}
	}
	return false;
}

function delPsupplier(id){
	$.confirm("确认删除吗？",function(){
	  $.post("delSupplier",{state:-1,id:id},function(data){
	   		if(data.success){
	   			$.success('删除成功！', function(){
                    $("#"+id).remove();
				});
	   		}else{
	   			$.info(data.msg);
	   		}
	  },"json");},
	  function(){
  			$.info('取消删除！');
	});
}


</script>
</html>
