<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>库存已绑定产品信息</title>
<%@ include file="../../include/top.jsp"%>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">

			<!-- table  start -->
			<dl class="p_paragraph_content">
					
				
				<dd class="inl-bl">
					<div ><label style="color: red;">该库存已绑定的产品信息：</label></div>
					<div class="clear"></div>
				</dd>
				<dd>
					<input type="hidden" name=stockId id="stock_id" value="${stockId}" />
					
						
						<div class="pl-10 pr-10" style="padding-bottom: 1%;">
							<table cellspacing="0" cellpadding="0" class="w_table">


								<col width="5%" />
								<col width="15%" />
								<col width="30%"/>
								<col width="10%" />
								<col width="30%" />
								<col width="10%" />

								<thead>
								
									<tr>
										<th></th>
										<th>自编码<i class="w_table_split"></i></th>
										<th>产品名称<i class="w_table_split"></i></th>
										<th>商品属性<i class="w_table_split"></i></th>
										<th>套餐名称<i class="w_table_split"></i></th>
										<th>创建时间<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${proInfoList }" var="tbProduct" varStatus="v">
									
									<tr>
										<td>
											<input type="checkbox" name="tpsId" id="chkAll" value="${tbProduct.id }" />
										</td>
										<td>${tbProduct.outerId }</td>
										<td style="text-align: left;">${tbProduct.title }</td>
										<td>${tbProduct.props }</td>
										<td>${tbProduct.pidName }</td>
										<td><fmt:formatDate value="${tbProduct.created }" pattern="yyyy-MM-dd HH:mm:ss"/> </td>
									</tr>
									
									</c:forEach>
								</tbody>
							</table>
						</div>
					
					<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
						<button type="button" onclick="addTaoBaoProductBindingBtn();"  class="button button-primary button-rounded button-small">添加产品</button>
						<button type="button" onclick="deleteTaoBaoProductInfo();"  class="button button-primary button-rounded button-small">删除选中</button>
						<button type="button" onclick="javascript:location.reload()"  class="button button-primary button-rounded button-small">刷新</button>
						<button type="button" onclick="javascript:closeWindow()"  class="button button-primary button-rounded button-small">关闭</button>
					</div>
				</dd>
			</dl>
		</div>
	</div>
</body>
<script type="text/javascript">
/* 添加产品 */
function addTaoBaoProductBindingBtn() {
	var stock_id = $("#stock_id").val();
	layer.open({        
		type : 2,
		title : '选择产品名称',
		shadeClose : true,
		shade : 0.5,
		area : ['680px','480px'],
		content: '<%=path%>/taobaoProect/addTaobaoProduct.htm?',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var setId = "";
			 var body = layer.getChildFrame('body', index);
			    body.find("input[name='tpsId']").each(function(){
				if ($(this).attr("checked") || $(this).prop("checked")){
					//alert($(this).val());
					setId += $(this).val() + ",";  
				}
			    });
			    if(setId != ''){
			    	$.getJSON('../taobaoProect/saveStockProBinding.do?tpsId='+setId+"&stockId="+stock_id, function(data){
				    	/* $.success('添加成功',function(){
							layer.closeAll();
							parent.location.reload();
						}); */
				    	if (data.success == '1') {
							$.success('保存成功！', function(){
								layer.close(index);
								location.reload();
							});
						}
						if (data.error == 'spError') {
							$.error("您选择的产品信息已经存在！");
						}
			        }); 
			    }else{
			    	$.error("请选择需要绑定的产品信息！");
			    }
			    
	        	
		},cancel: function(index){
	    	layer.close(index);
	    }
	});
}

/* 删除 */
function deleteTaoBaoProductInfo(){
	var stock_id = $("#stock_id").val();
	var setId = "";
	$("input[name=tpsId]").each(function() {
        if ($(this).attr("checked")) {  
            setId += $(this).val() + ",";  
        }  
    });
	
	$.confirm("确认删除吗？",function(){
		  $.post("deleteTaoBaoStockProduct.do",{stockId:stock_id,tpsId:setId},function(data){
		   		if(data.success == 1){
		   			$.success('删除成功！', function(){
		   				//刷新页面
						location.reload();
					});			   			
		   		}else{
		   			$.info(data.msg);
		   		}
		  },"json");
	},function(){
	  $.info('取消删除！');

	});
}
</script>
</html>
