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
    <title>产品系统导入</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    

</head>
<body>
  <div class="p_container" >
  	<form id="searchProductForm">
		<dd class="inl-bl">
						<div class="dd_left">产品:</div>
						<div class="dd_right grey">
							<input id="txtcode"   name="txtcode" type="text" placeholder="输入产品名称或编码" style="width:400px;"/>
						</div>
						<div class="clear"></div>
				</dd>
				
				<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="getProduct_Ashx()" class="button button-primary button-small">查询</button>
							
							 <button type="button" onclick="setReturn()" class="button button-primary button-small">确定</button>
						</div>
						<div class="clear"></div>
				</dd>			
    </form>
    
    <table cellspacing="0" cellpadding="0" class="w_table">
    <col width="6%"/>
    <col width="13%"/>
    <col width="45%"/>
    <col width="15%"/>
    <col width="15%"/>
    <col width="6%"/>
    <thead>
    <tr>
        <th>序号<i class="w_table_split"></i></th>
        <th>产品编码<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th>价格<i class="w_table_split"></i></th>
        <th>发班<i class="w_table_split"></i></th>
        <th>选择<i class="w_table_split"></i></th>
    </tr>
    </thead>
    <tbody class="w_tbodyss">

    </tbody>
</table>
</div>
</body>
<script type="text/javascript">
function getProduct_Ashx() {
	var options = {
			url:"import_productAY_getProductList.do",
	    	type:"post",
	    	dataType:"json",
	    	success:function(data){
	    		//console.table(data);
	    		$(".w_tbodyss").empty();
	    		$.each(data, function(i, result){
	    			var item = "<tr ><td>"+(i+1)+"</td><td>"+result['pcode']+"</td><td>"+result['pname']+"</td><td>"+result['price_adult']+"</td><td>"+result['departure_plan']+"</td><td><input type='checkbox' id='chk_"+result['pid']+"'></td></tr>";
	    			$('.w_table').append(item);
	    		}); 
	    	},
	    	error:function(XMLHttpRequest, textStatus, errorThrown){
	    		alert(textStatus);
	    	}
	    };
	    $("#searchProductForm").ajaxSubmit(options);	
    
}

function setReturn(){
	var ids = "";
	$("input[type='checkbox']").each(function(){
		if ($(this).attr("checked") || $(this).prop("checked"))
			ids += $(this).attr("id").split("_")[1] + ","
	});
	parent.setImportProduct(ids);
	
	var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
	parent.layer.close(index);
}
</script>


</html>